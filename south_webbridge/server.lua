local RESOURCE_NAME = GetCurrentResourceName()
local TOKEN_CONVAR = "south_webbridge_token"

local function getBridgeToken()
    return tostring(GetConvar(TOKEN_CONVAR, ""))
end

local function jsonResponse(res, status, payload)
    res.writeHead(status, { ["Content-Type"] = "application/json; charset=utf-8" })
    res.send(json.encode(payload))
end

local function normalizeArgs(args)
    if type(args) ~= "table" then
        return {}
    end
    return args
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

    local staticId = payload.player and payload.player.static_id or nil
    if staticId ~= nil and tostring(staticId) ~= "" then
        local okStatic, srcByStatic = pcall(function()
            return exports["south_staticid"] and exports["south_staticid"]:getPlayerIdFromStatic(tonumber(staticId))
        end)
        if okStatic and srcByStatic and GetPlayerName(srcByStatic) then
            return srcByStatic
        end
    end

    local citizenid = payload.player and payload.player.citizenid or nil
    if type(citizenid) ~= "string" or citizenid == "" then
        return nil
    end

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

    return nil
end

local function executeExport(template, args)
    if type(template.resource_name) ~= "string" or template.resource_name == "" then
        return false, "resource_name is required for export", nil
    end
    if type(template.action_name) ~= "string" or template.action_name == "" then
        return false, "action_name is required for export", nil
    end

    local ok, result = pcall(function()
        return exports[template.resource_name][template.action_name](table.unpack(args))
    end)
    if not ok then
        return false, tostring(result), nil
    end
    return true, "export executed", result
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

    local okSet, errSet = pcall(function()
        player.Functions.SetJob(tostring(job), tonumber(grade) or 0)
    end)
    if not okSet then
        return false, tostring(errSet), nil
    end
    return true, "job updated", { source = targetSource, job = tostring(job), grade = tonumber(grade) or 0 }
end

local function executePayload(payload)
    local template = payload.template or {}
    local actionType = template.action_type
    local args = normalizeArgs(payload.args)

    if actionType == "export" then
        return executeExport(template, args)
    end
    if actionType == "server_event" then
        return executeServerEvent(template, args)
    end
    if actionType == "qbx_set_job" then
        return executeQbxSetJob(payload)
    end

    return false, ("unsupported action_type: %s"):format(tostring(actionType)), nil
end

if getBridgeToken() == "" then
    print(("[^1%s^7] WARNING: %s is empty. Bridge requests will be rejected."):format(RESOURCE_NAME, TOKEN_CONVAR))
end

SetHttpHandler(function(req, res)
    if req.path ~= "/south_webbridge/execute" and req.path ~= "/south_webbridge/status" then
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

        if req.path == "/south_webbridge/status" then
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

        local okExec, message, result = executePayload(payload)
        if not okExec then
            return jsonResponse(res, 400, { ok = false, error = "execute_failed", message = message })
        end
        return jsonResponse(res, 200, { ok = true, message = message, result = result })
    end)
end)

print(("[^2%s^7] Loaded. Endpoints: /south_webbridge/execute, /south_webbridge/status"):format(RESOURCE_NAME))
