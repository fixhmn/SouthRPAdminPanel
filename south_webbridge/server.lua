local RESOURCE_NAME = GetCurrentResourceName()
local TOKEN_CONVAR = "south_webbridge_token"
local onlinePlayers = {}
local inventoryHookRegistered = false
local inventoryHookDebugCount = 0

local function getBridgeToken()
    return tostring(GetConvar(TOKEN_CONVAR, ""))
end

local function jsonResponse(res, status, payload)
    res.writeHead(status, { ["Content-Type"] = "application/json; charset=utf-8" })
    res.send(json.encode(payload))
end

local function extractDiscordId(src)
    for _, ident in ipairs(GetPlayerIdentifiers(src)) do
        if type(ident) == "string" and ident:sub(1, 8) == "discord:" then
            return ident:sub(9)
        end
    end
    return nil
end

local function extractLicenseCandidates(src)
    local out = {}
    local seen = {}
    for _, ident in ipairs(GetPlayerIdentifiers(src)) do
        if type(ident) == "string" and (ident:sub(1, 8) == "license:" or ident:sub(1, 9) == "license2:") then
            if not seen[ident] then
                out[#out + 1] = ident
                seen[ident] = true
            end
        end
    end
    return out
end

local function licenseTail(ident)
    if type(ident) ~= "string" then
        return nil
    end
    local tail = ident:match("^[^:]+:(.+)$")
    if type(tail) == "string" and tail ~= "" then
        return tail
    end
    return nil
end

local function resolveStaticIdFromDbByLicense(licenseIdent)
    if type(licenseIdent) ~= "string" or licenseIdent == "" then
        return nil
    end
    local ok, row = pcall(function()
        return MySQL and MySQL.single and MySQL.single.await
            and MySQL.single.await("SELECT static_id FROM static_ids WHERE license = ? LIMIT 1", { licenseIdent })
            or nil
    end)
    if ok and row and row.static_id then
        return row.static_id
    end
    return nil
end

local function resolveStaticIdFromDbByTail(licenseIdent)
    local tail = licenseTail(licenseIdent)
    if not tail then
        return nil
    end
    local ok, row = pcall(function()
        return MySQL and MySQL.single and MySQL.single.await
            and MySQL.single.await(
                "SELECT static_id FROM static_ids WHERE SUBSTRING_INDEX(license, ':', -1) = ? LIMIT 1",
                { tail }
            )
            or nil
    end)
    if ok and row and row.static_id then
        return row.static_id
    end
    return nil
end

local function resolveStaticIdBySource(src)
    local staticId = nil
    local staticResource = exports["south_staticid"]

    local function tryStaticExport(method)
        if not staticResource or type(method) ~= "string" or method == "" then
            return nil
        end
        local ok1, val1 = pcall(function()
            local fn = staticResource[method]
            if type(fn) == "function" then
                return fn(staticResource, src)
            end
            return nil
        end)
        if ok1 and val1 then
            return val1
        end
        local ok2, val2 = pcall(function()
            return staticResource[method](src)
        end)
        if ok2 and val2 then
            return val2
        end
        return nil
    end

    local okA, valA = pcall(function()
        return exports["south_staticid"] and exports["south_staticid"]:getStaticIdFromServerId(src)
    end)
    if okA and valA then
        staticId = valA
    end
    if not staticId then
        staticId = tryStaticExport("getStaticIdFromPlayerId")
    end
    if not staticId then
        staticId = tryStaticExport("getStaticFromPlayerId")
    end
    if not staticId then
        staticId = tryStaticExport("getStaticIdFromPlayer")
    end
    if not staticId then
        for _, ident in ipairs(extractLicenseCandidates(src)) do
            staticId = resolveStaticIdFromDbByLicense(ident)
            if staticId then
                break
            end
        end
    end
    if not staticId then
        for _, ident in ipairs(extractLicenseCandidates(src)) do
            staticId = resolveStaticIdFromDbByTail(ident)
            if staticId then
                break
            end
        end
    end
    return staticId
end

local function buildOnlinePlayerSnapshot(src)
    if not src or not GetPlayerName(src) then
        return nil
    end

    local item = {
        source = src,
        name = GetPlayerName(src),
        citizenid = nil,
        static_id = resolveStaticIdBySource(src),
        discord_id = extractDiscordId(src),
        firstname = nil,
        lastname = nil,
        phone = nil,
        job = nil,
        gang = nil,
    }

    local okPlayer, player = pcall(function()
        return exports.qbx_core and exports.qbx_core:GetPlayer(src) or nil
    end)
    if okPlayer and player and player.PlayerData then
        local pd = player.PlayerData
        item.citizenid = pd.citizenid
        item.name = (pd.name and tostring(pd.name)) or item.name
        if not item.static_id then
            item.static_id = pd.static_id or pd.staticid
        end
        if pd.charinfo then
            item.firstname = pd.charinfo.firstname
            item.lastname = pd.charinfo.lastname
            item.phone = pd.charinfo.phone
            if (not item.name or item.name == "") and (item.firstname or item.lastname) then
                item.name = ((item.firstname or "") .. " " .. (item.lastname or "")):gsub("^%s+", ""):gsub("%s+$", "")
            end
        end
        if pd.job then
            item.job = pd.job.label or pd.job.name
        end
        if pd.gang then
            item.gang = pd.gang.label or pd.gang.name
        end
    end

    return item
end

local function resolvePlayerIdentity(src)
    if not src or not GetPlayerName(src) then
        return nil
    end
    local row = buildOnlinePlayerSnapshot(src) or {}
    local charName = nil
    if (row.firstname and tostring(row.firstname) ~= "") or (row.lastname and tostring(row.lastname) ~= "") then
        charName = ((tostring(row.firstname or "")) .. " " .. (tostring(row.lastname or ""))):gsub("^%s+", ""):gsub("%s+$", "")
        if charName == "" then
            charName = nil
        end
    end
    return {
        source = src,
        citizenid = row.citizenid,
        static_id = row.static_id,
        name = charName or row.name or GetPlayerName(src),
    }
end

local function coalesceItemData(payload)
    local fromSlot = type(payload.fromSlot) == "table" and payload.fromSlot or nil
    local toSlot = type(payload.toSlot) == "table" and payload.toSlot or nil
    local item = fromSlot or toSlot or {}
    local metadata = type(item.metadata) == "table" and item.metadata or {}
    local itemName = item.name or item.item
    local itemLabel = item.label
    local plate = metadata.plate and tostring(metadata.plate) or nil
    return itemName, itemLabel, plate
end

local function extractPlateFromInventoryId(invId)
    if type(invId) ~= "string" then
        return nil
    end
    local glove = invId:match("^glove(.+)$")
    if glove and glove ~= "" then
        return glove
    end
    local trunk = invId:match("^trunk(.+)$")
    if trunk and trunk ~= "" then
        return trunk
    end
    return nil
end

local function classifyInventoryAction(payload)
    local action = tostring(payload.action or "")
    local fromType = tostring(payload.fromType or "")
    local toType = tostring(payload.toType or "")

    if action == "give" and fromType == "player" and toType == "player" then
        return "give_player"
    end
    if action == "move" and fromType == "player" and toType == "drop" then
        return "drop_ground"
    end
    if action == "move" and fromType == "drop" and toType == "player" then
        return "pickup_drop"
    end
    if action == "move" and fromType == "player" and toType == "glovebox" then
        return "put_glovebox"
    end
    if action == "move" and fromType == "glovebox" and toType == "player" then
        return "take_glovebox"
    end
    if action == "move" and fromType == "player" and toType == "trunk" then
        return "put_trunk"
    end
    if action == "move" and fromType == "trunk" and toType == "player" then
        return "take_trunk"
    end
    if action == "move" and fromType == "trunk" and toType == "glovebox" then
        return "trunk_to_glovebox"
    end
    if action == "move" and fromType == "glovebox" and toType == "trunk" then
        return "glovebox_to_trunk"
    end
    if action == "stack" then
        return "stack"
    end
    if action == "swap" then
        return "swap"
    end
    return nil
end

local function tryInsertInventoryLog(payload)
    if not MySQL then
        if inventoryHookDebugCount < 5 then
            print(("[^1%s^7] inventory log skipped: MySQL object unavailable"):format(RESOURCE_NAME))
            inventoryHookDebugCount = inventoryHookDebugCount + 1
        end
        return
    end

    local fromInventory = tostring(payload.fromInventory or "")
    local toInventory = tostring(payload.toInventory or "")
    local actionKey = classifyInventoryAction(payload)
    if not actionKey then
        return
    end
    local itemName, itemLabel, plateFromMeta = coalesceItemData(payload)
    local plate = plateFromMeta or extractPlateFromInventoryId(fromInventory) or extractPlateFromInventoryId(toInventory)
    local dropId = payload.dropId or (fromInventory:match("^drop[%w_%-]+$") and fromInventory) or (toInventory:match("^drop[%w_%-]+$") and toInventory)

    local actorSource = tonumber(payload.source) or (tostring(payload.fromType) == "player" and tonumber(payload.fromInventory) or nil)
    local targetSource = (tostring(payload.toType) == "player" and tonumber(payload.toInventory) or nil)
    local actor = resolvePlayerIdentity(actorSource)
    local target = resolvePlayerIdentity(targetSource)

    local count = tonumber(payload.count) or 1
    if count < 1 then count = 1 end

    local payloadJson = nil
    local okEncode, encoded = pcall(function()
        return json.encode(payload)
    end)
    if okEncode then
        payloadJson = encoded
    end

    local insertSql = [[
        INSERT INTO web_game_inventory_logs (
            ts, action_key,
            item_name, item_label, item_count, plate, drop_id,
            actor_source, actor_citizenid, actor_static_id, actor_name,
            target_source, target_citizenid, target_static_id, target_name,
            from_type, to_type, from_inventory, to_inventory, payload_json
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]]
    local insertParams = {
        os.date("%Y-%m-%d %H:%M:%S"),
        actionKey,
        itemName and tostring(itemName) or nil,
        itemLabel and tostring(itemLabel) or nil,
        count,
        plate and tostring(plate) or nil,
        dropId and tostring(dropId) or nil,
        actor and actor.source or nil,
        actor and actor.citizenid or nil,
        actor and actor.static_id or nil,
        actor and actor.name or nil,
        target and target.source or nil,
        target and target.citizenid or nil,
        target and target.static_id or nil,
        target and target.name or nil,
        payload.fromType and tostring(payload.fromType) or nil,
        payload.toType and tostring(payload.toType) or nil,
        fromInventory ~= "" and fromInventory or nil,
        toInventory ~= "" and toInventory or nil,
        payloadJson,
    }

    local ok, err = pcall(function()
        if MySQL.insert and MySQL.insert.await then
            MySQL.insert.await(insertSql, insertParams)
            return
        end
        if MySQL.update and MySQL.update.await then
            MySQL.update.await(insertSql, insertParams)
            return
        end
        if MySQL.query and MySQL.query.await then
            MySQL.query.await(insertSql, insertParams)
            return
        end
        error("No await-capable MySQL method found (insert/update/query)")
    end)

    if not ok then
        print(("[^1%s^7] inventory log insert failed: %s"):format(RESOURCE_NAME, tostring(err)))
    elseif inventoryHookDebugCount < 10 then
        print(("[^2%s^7] inventory log inserted action=%s item=%s count=%s"):format(
            RESOURCE_NAME,
            tostring(actionKey),
            tostring(itemName),
            tostring(count)
        ))
        inventoryHookDebugCount = inventoryHookDebugCount + 1
    end
end

local function refreshOnlinePlayer(src)
    local row = buildOnlinePlayerSnapshot(src)
    if row then
        onlinePlayers[src] = row
    end
end

local function removeOnlinePlayer(src)
    onlinePlayers[src] = nil
end

local function rebuildOnlinePlayers()
    onlinePlayers = {}
    for _, srcStr in ipairs(GetPlayers()) do
        local src = tonumber(srcStr)
        if src then
            refreshOnlinePlayer(src)
        end
    end
end

local function getOnlinePlayersList()
    local out = {}
    for src, row in pairs(onlinePlayers) do
        if GetPlayerName(src) then
            out[#out + 1] = row
        else
            onlinePlayers[src] = nil
        end
    end
    table.sort(out, function(a, b)
        return tonumber(a.source or 0) < tonumber(b.source or 0)
    end)
    return out
end

local function normalizeArgs(args)
    if type(args) ~= "table" then
        return {}
    end
    return args
end

local function hasPositionalArgs(args)
    if type(args) ~= "table" then
        return false
    end
    return args[1] ~= nil
end

local function asNumber(v)
    if type(v) == "number" then
        return v
    end
    if type(v) == "string" and v ~= "" then
        local n = tonumber(v)
        if n then
            return n
        end
    end
    return nil
end

local function resolveTargetSource(payload)
    local values = payload.values or {}

    local sourceCandidate = asNumber(values.targetId) or asNumber(values.target_id) or asNumber(values.source)
    if sourceCandidate and GetPlayerName(sourceCandidate) then
        return sourceCandidate
    end

    local citizenid = payload.player and payload.player.citizenid or nil
    if type(citizenid) == "string" and citizenid ~= "" then
        -- Try qbx_core export first.
        local okByCitizen, byCitizen = pcall(function()
            return exports.qbx_core and exports.qbx_core:GetPlayerByCitizenId(citizenid) or nil
        end)
        if okByCitizen and byCitizen then
            local src = byCitizen.PlayerData and byCitizen.PlayerData.source or byCitizen.source
            if src and GetPlayerName(src) then
                return src
            end
        end

        -- Fallback: iterate online players and match citizenid.
        for _, srcStr in ipairs(GetPlayers()) do
            local src = tonumber(srcStr)
            if src then
                local okGetPlayer, player = pcall(function()
                    return exports.qbx_core and exports.qbx_core:GetPlayer(src) or nil
                end)
                if okGetPlayer and player and player.PlayerData and player.PlayerData.citizenid == citizenid then
                    return src
                end
            end
        end
    end

    local staticId = payload.player and payload.player.static_id or nil
    if staticId ~= nil and tostring(staticId) ~= "" then
        local okStatic, srcByStatic = pcall(function()
            return exports["south_staticid"] and exports["south_staticid"]:getPlayerIdFromStatic(tonumber(staticId))
        end)
        if okStatic and srcByStatic and GetPlayerName(srcByStatic) then
            return srcByStatic
        end
    end

    return nil
end

local function executeExport(template, args)
    if type(template.resource_name) ~= "string" or template.resource_name == "" then
        return false, "resource_name is required for export", nil
    end
    if type(template.action_name) ~= "string" or template.action_name == "" then
        return false, "action_name is required for export", nil
    end

    local ok, result, result2, result3 = pcall(function()
        return exports[template.resource_name][template.action_name](table.unpack(args))
    end)
    if not ok then
        return false, tostring(result), nil
    end

    -- Some exports (including ox_inventory:AddItem) can return false + reason.
    if result == false then
        local reason = result2 or "export returned false"
        if template.resource_name == "ox_inventory" and template.action_name == "AddItem" then
            local target = asNumber(args[1])
            local itemName = args[2]
            local amount = asNumber(args[3]) or 1

            -- Fallback: some servers still expose qbx item add flow.
            if tostring(reason) == "invalid_item" and target and type(itemName) == "string" and itemName ~= "" then
                local okPlayer, player = pcall(function()
                    return exports.qbx_core and exports.qbx_core:GetPlayer(target) or nil
                end)
                if okPlayer and player and player.Functions and player.Functions.AddItem then
                    local okFallback, fallbackResult = pcall(function()
                        return player.Functions.AddItem(itemName, amount)
                    end)
                    if okFallback and fallbackResult then
                        return true, "export executed (qbx fallback)", {
                            result = true,
                            extra = { "qbx_fallback_used", itemName, amount },
                        }
                    end
                end
            end
        end
        return false, tostring(reason), { result = result, extra = { result2, result3 } }
    end

    return true, "export executed", { result = result, extra = { result2, result3 } }
end

local function executeServerEvent(template, args)
    if type(template.action_name) ~= "string" or template.action_name == "" then
        return false, "action_name is required for server_event", nil
    end

    local ok, err = pcall(function()
        TriggerEvent(template.action_name, table.unpack(args))
    end)
    if not ok then
        return false, tostring(err), nil
    end
    return true, "server event executed", nil
end

local function executeQbxSetJob(payload)
    local values = payload.values or {}
    local job = values.job or values.Job
    local grade = asNumber(values.grade) or asNumber(values.Grade) or 0
    local targetSource = resolveTargetSource(payload)

    if type(job) ~= "string" or job == "" then
        return false, "job variable is required", nil
    end
    if not targetSource then
        return false, "target source is not resolved (player should be online)", nil
    end

    local okPlayer, player = pcall(function()
        return exports.qbx_core and exports.qbx_core:GetPlayer(targetSource) or nil
    end)
    if not okPlayer or not player then
        return false, "qbx player object not found", nil
    end
    if not (player.Functions and player.Functions.SetJob) then
        return false, "player.Functions.SetJob is unavailable", nil
    end

    local okSet, setResult = pcall(function()
        return player.Functions.SetJob(tostring(job), tonumber(grade) or 0)
    end)
    if not okSet then
        return false, tostring(setResult), nil
    end
    if setResult == false then
        return false, "SetJob returned false (invalid job/grade)", nil
    end
    return true, "job updated", { source = targetSource, job = tostring(job), grade = tonumber(grade) or 0 }
end

local function executeQbxSetGang(payload)
    local values = payload.values or {}
    local gang = values.gang or values.Gang
    local grade = asNumber(values.grade) or asNumber(values.Grade) or 0
    local targetSource = resolveTargetSource(payload)

    if type(gang) ~= "string" or gang == "" then
        return false, "gang variable is required", nil
    end
    if not targetSource then
        return false, "target source is not resolved (player should be online)", nil
    end

    local okPlayer, player = pcall(function()
        return exports.qbx_core and exports.qbx_core:GetPlayer(targetSource) or nil
    end)
    if not okPlayer or not player then
        return false, "qbx player object not found", nil
    end
    if not (player.Functions and player.Functions.SetGang) then
        return false, "player.Functions.SetGang is unavailable", nil
    end

    local okSet, setResult = pcall(function()
        return player.Functions.SetGang(tostring(gang), tonumber(grade) or 0)
    end)
    if not okSet then
        return false, tostring(setResult), nil
    end
    if setResult == false then
        return false, "SetGang returned false (invalid gang/grade)", nil
    end
    return true, "gang updated", { source = targetSource, gang = tostring(gang), grade = tonumber(grade) or 0 }
end

local function executeDropPlayer(payload)
    local values = payload.values or {}
    local reason = tostring(values.reason or values.message or "Kicked by administrator.")
    local targetSource = resolveTargetSource(payload)
    if not targetSource then
        return false, "target source is not resolved (player should be online)", nil
    end
    if not GetPlayerName(targetSource) then
        return false, "player is offline", nil
    end

    local okDrop, errDrop = pcall(function()
        DropPlayer(targetSource, reason)
    end)
    if not okDrop then
        return false, tostring(errDrop), nil
    end
    return true, "player dropped", { source = targetSource, reason = reason }
end

local function executePayload(payload)
    local template = payload.template or {}
    local actionType = template.action_type
    local args = normalizeArgs(payload.args)
    local values = payload.values or {}

    if actionType == "export" then
        -- Some JSON decoders can deserialize arrays in a way that drops positional unpacking.
        -- Rebuild common ox_inventory calls from named values as a safe fallback.
        if template.resource_name == "ox_inventory" then
            if template.action_name == "Items" then
                if type(values.item) == "string" and values.item ~= "" then
                    args = { values.item }
                elseif not hasPositionalArgs(args) then
                    args = {}
                end
            elseif template.action_name == "CanCarryItem" then
                local target = asNumber(values.targetId) or asNumber(values.target_id) or asNumber(values.source)
                local item = values.item
                local amount = asNumber(values.amount) or 1
                if target and type(item) == "string" and item ~= "" then
                    args = { target, item, amount }
                end
            elseif template.action_name == "AddItem" then
                local target = asNumber(values.targetId) or asNumber(values.target_id) or asNumber(values.source)
                local item = values.item
                local amount = asNumber(values.amount) or 1
                if target and type(item) == "string" and item ~= "" then
                    -- Keep item as string key; this is what ox_inventory export AddItem expects.
                    args = { target, item, amount }
                end
            elseif not hasPositionalArgs(args) then
                args = {}
            end
        end
        return executeExport(template, args)
    end
    if actionType == "server_event" then
        return executeServerEvent(template, args)
    end
    if actionType == "qbx_set_job" then
        return executeQbxSetJob(payload)
    end
    if actionType == "qbx_set_gang" then
        return executeQbxSetGang(payload)
    end
    if actionType == "drop_player" then
        return executeDropPlayer(payload)
    end

    return false, ("unsupported action_type: %s"):format(tostring(actionType)), nil
end

if getBridgeToken() == "" then
    print(("[^1%s^7] WARNING: %s is empty. Bridge requests will be rejected."):format(RESOURCE_NAME, TOKEN_CONVAR))
end

AddEventHandler("playerJoining", function()
    local src = source
    if src then
        refreshOnlinePlayer(src)
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    if src then
        removeOnlinePlayer(src)
    end
end)

AddEventHandler("QBCore:Server:OnPlayerLoaded", function(playerObj)
    local src = nil
    if type(playerObj) == "number" then
        src = playerObj
    elseif type(playerObj) == "table" and playerObj.PlayerData then
        src = playerObj.PlayerData.source or playerObj.source
    end
    if src then
        refreshOnlinePlayer(src)
    end
end)

CreateThread(function()
    if MySQL and MySQL.query and MySQL.query.await then
        pcall(function()
            MySQL.query.await(
                [[
                    CREATE TABLE IF NOT EXISTS web_game_inventory_logs (
                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                        ts DATETIME NOT NULL,
                        action_key VARCHAR(64) NOT NULL,
                        item_name VARCHAR(128) NULL,
                        item_label VARCHAR(256) NULL,
                        item_count INT NOT NULL DEFAULT 1,
                        plate VARCHAR(32) NULL,
                        drop_id VARCHAR(64) NULL,
                        actor_source INT NULL,
                        actor_citizenid VARCHAR(64) NULL,
                        actor_static_id INT NULL,
                        actor_name VARCHAR(128) NULL,
                        target_source INT NULL,
                        target_citizenid VARCHAR(64) NULL,
                        target_static_id INT NULL,
                        target_name VARCHAR(128) NULL,
                        from_type VARCHAR(32) NULL,
                        to_type VARCHAR(32) NULL,
                        from_inventory VARCHAR(128) NULL,
                        to_inventory VARCHAR(128) NULL,
                        payload_json JSON NULL,
                        INDEX idx_ts (ts),
                        INDEX idx_action (action_key),
                        INDEX idx_item_name (item_name),
                        INDEX idx_actor_citizen (actor_citizenid),
                        INDEX idx_target_citizen (target_citizenid)
                    )
                ]]
            )
        end)
    end

    while not inventoryHookRegistered do
        local okHook = pcall(function()
            if exports.ox_inventory and exports.ox_inventory.registerHook then
                exports.ox_inventory:registerHook("swapItems", function(payload)
                    if inventoryHookDebugCount < 5 then
                        print(("[^5%s^7] swapItems hook event action=%s fromType=%s toType=%s"):format(
                            RESOURCE_NAME,
                            tostring(payload and payload.action),
                            tostring(payload and payload.fromType),
                            tostring(payload and payload.toType)
                        ))
                        inventoryHookDebugCount = inventoryHookDebugCount + 1
                    end
                    tryInsertInventoryLog(payload)
                    return true
                end, {})
                inventoryHookRegistered = true
            end
        end)
        if inventoryHookRegistered then
            print(("[^2%s^7] ox_inventory hook registered: swapItems"):format(RESOURCE_NAME))
            break
        end
        if not okHook then
            -- keep retrying: ox_inventory may not be ready yet
        end
        Wait(3000)
    end

    Wait(1000)
    rebuildOnlinePlayers()
    while true do
        Wait(15000)
        rebuildOnlinePlayers()
    end
end)

SetHttpHandler(function(req, res)
    local path = tostring(req.path or "")
    local isExecute = (path == "/south_webbridge/execute" or path == "/execute")
    local isStatus = (path == "/south_webbridge/status" or path == "/status")
    local isOnlineList = (path == "/south_webbridge/online-list" or path == "/online-list")

    if (not isExecute) and (not isStatus) and (not isOnlineList) then
        return jsonResponse(res, 404, { ok = false, error = "not_found" })
    end

    if req.method ~= "POST" then
        return jsonResponse(res, 405, { ok = false, error = "method_not_allowed" })
    end

    local token = req.headers["x-bridge-token"] or req.headers["X-Bridge-Token"] or ""
    local expected = getBridgeToken()
    if expected == "" then
        return jsonResponse(res, 503, { ok = false, error = "bridge_token_not_configured" })
    end
    if token ~= expected then
        return jsonResponse(res, 401, { ok = false, error = "unauthorized" })
    end

    req.setDataHandler(function(body)
        local payload = nil
        local okDecode, decoded = pcall(function()
            return json.decode(body)
        end)
        if okDecode then
            payload = decoded
        end
        if type(payload) ~= "table" then
            return jsonResponse(res, 400, { ok = false, error = "invalid_json" })
        end

        if isStatus then
            local src = resolveTargetSource(payload)
            if src and GetPlayerName(src) then
                return jsonResponse(res, 200, {
                    ok = true,
                    online = true,
                    source = src,
                    player_name = GetPlayerName(src),
                })
            end
            return jsonResponse(res, 200, { ok = true, online = false, source = nil })
        end

        if isOnlineList then
            return jsonResponse(res, 200, { ok = true, items = getOnlinePlayersList() })
        end

        local okExec, message, result = executePayload(payload)
        print(("[^3%s^7] action=%s ok=%s message=%s"):format(
            RESOURCE_NAME,
            tostring((payload.template or {}).action_name),
            tostring(okExec),
            tostring(message)
        ))
        if not okExec then
            local errPayload = {
                ok = false,
                error = "execute_failed",
                message = message,
            }
            if result ~= nil then
                errPayload.result = result
            end
            return jsonResponse(res, 400, errPayload)
        end
        return jsonResponse(res, 200, { ok = true, message = message, result = result })
    end)
end)

print(("[^2%s^7] Loaded. Endpoints: /south_webbridge/execute, /south_webbridge/status, /south_webbridge/online-list"):format(RESOURCE_NAME))
