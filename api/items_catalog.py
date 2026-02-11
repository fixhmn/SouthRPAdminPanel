import os
import re
from typing import Dict, TypedDict

_ITEM_START_RE = re.compile(r"\[\s*'([^']+)'\s*\]\s*=\s*\{")
_LABEL_RE = re.compile(r"label\s*=\s*'([^']*)'")
_IMAGE_RE = re.compile(r"image\s*=\s*'([^']*)'")


class ItemMeta(TypedDict, total=False):
    label: str
    image: str


_cache: dict[str, ItemMeta] = {}
_cache_path = ""
_cache_mtime = -1.0


def _candidate_paths() -> list[str]:
    env_path = os.getenv("ITEMS_LUA_PATH", "").strip()
    local_default = os.path.join(os.path.dirname(__file__), "items.lua")
    return [p for p in [env_path, local_default] if p]


def _resolve_items_file() -> str | None:
    for path in _candidate_paths():
        if os.path.isfile(path):
            return path
    return None


def _parse_items_lua(raw: str) -> Dict[str, ItemMeta]:
    items: dict[str, ItemMeta] = {}

    in_item = False
    current_item = ""
    current_label = ""
    current_image = ""
    brace_level = 0

    for line in raw.splitlines():
        if not in_item:
            m = _ITEM_START_RE.search(line)
            if not m:
                continue
            in_item = True
            current_item = m.group(1)
            current_label = ""
            current_image = ""
            brace_level = line.count("{") - line.count("}")
            label_match = _LABEL_RE.search(line)
            if label_match:
                current_label = label_match.group(1).strip()
            image_match = _IMAGE_RE.search(line)
            if image_match:
                current_image = image_match.group(1).strip()
            if brace_level <= 0:
                items[current_item] = {
                    "label": current_label or current_item,
                    "image": current_image,
                }
                in_item = False
            continue

        label_match = _LABEL_RE.search(line)
        if label_match and not current_label:
            current_label = label_match.group(1).strip()
        image_match = _IMAGE_RE.search(line)
        if image_match and not current_image:
            current_image = image_match.group(1).strip()

        brace_level += line.count("{") - line.count("}")
        if brace_level <= 0:
            items[current_item] = {
                "label": current_label or current_item,
                "image": current_image,
            }
            in_item = False

    return items


def get_items_catalog() -> Dict[str, ItemMeta]:
    global _cache, _cache_path, _cache_mtime

    path = _resolve_items_file()
    if not path:
        return {}

    try:
        mtime = os.path.getmtime(path)
    except OSError:
        return {}

    if _cache and _cache_path == path and _cache_mtime == mtime:
        return _cache

    try:
        with open(path, "r", encoding="utf-8") as f:
            raw = f.read()
    except OSError:
        return {}

    parsed = _parse_items_lua(raw)
    _cache = parsed
    _cache_path = path
    _cache_mtime = mtime
    return _cache


def resolve_item_label(item_name: str | None) -> str | None:
    if not item_name:
        return None
    meta = get_items_catalog().get(item_name)
    if not meta:
        return None
    return meta.get("label")


def resolve_item_image(item_name: str | None) -> str | None:
    if not item_name:
        return None
    meta = get_items_catalog().get(item_name)
    if not meta:
        return None
    return meta.get("image")
