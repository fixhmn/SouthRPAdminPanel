import os
import re
from typing import Dict, TypedDict

_ENTRY_START_RE = re.compile(r"\[\s*'([^']+)'\s*\]\s*=\s*\{")
_LABEL_RE = re.compile(r"label\s*=\s*'([^']*)'")
_GRADE_RE = re.compile(r"\[\s*(\d+)\s*\]\s*=\s*\{[^{}]*?name\s*=\s*'([^']*)'", re.S)


class GradeMeta(TypedDict):
    grade: int
    name: str


class GroupMeta(TypedDict, total=False):
    label: str
    grades: list[GradeMeta]


_cache: dict[str, Dict[str, GroupMeta]] = {"jobs": {}, "gangs": {}}
_cache_path: dict[str, str] = {"jobs": "", "gangs": ""}
_cache_mtime: dict[str, float] = {"jobs": -1.0, "gangs": -1.0}


def _candidate_paths(kind: str) -> list[str]:
    if kind == "jobs":
        env_path = os.getenv("JOBS_LUA_PATH", "").strip()
        local_default = os.path.join(os.path.dirname(__file__), "jobs.lua")
    else:
        env_path = os.getenv("GANGS_LUA_PATH", "").strip()
        local_default = os.path.join(os.path.dirname(__file__), "gangs.lua")
    return [p for p in [env_path, local_default] if p]


def _resolve_lua_file(kind: str) -> str | None:
    for path in _candidate_paths(kind):
        if os.path.isfile(path):
            return path
    return None


def _parse_entry_block(entry_key: str, block: str) -> GroupMeta:
    label_match = _LABEL_RE.search(block)
    label = label_match.group(1).strip() if label_match else entry_key

    grades: list[GradeMeta] = []
    seen: set[int] = set()
    for m in _GRADE_RE.finditer(block):
        try:
            grade_num = int(m.group(1))
        except Exception:
            continue
        if grade_num in seen:
            continue
        seen.add(grade_num)
        grade_name = m.group(2).strip() or str(grade_num)
        grades.append({"grade": grade_num, "name": grade_name})

    grades.sort(key=lambda x: x["grade"])
    return {"label": label, "grades": grades}


def _parse_group_lua(raw: str) -> Dict[str, GroupMeta]:
    out: dict[str, GroupMeta] = {}

    in_entry = False
    current_key = ""
    current_lines: list[str] = []
    brace_level = 0

    for line in raw.splitlines():
        if not in_entry:
            m = _ENTRY_START_RE.search(line)
            if not m:
                continue
            in_entry = True
            current_key = m.group(1)
            current_lines = [line]
            brace_level = line.count("{") - line.count("}")
            if brace_level <= 0:
                out[current_key] = _parse_entry_block(current_key, line)
                in_entry = False
            continue

        current_lines.append(line)
        brace_level += line.count("{") - line.count("}")
        if brace_level <= 0:
            out[current_key] = _parse_entry_block(current_key, "\n".join(current_lines))
            in_entry = False

    return out


def _get_catalog(kind: str) -> Dict[str, GroupMeta]:
    path = _resolve_lua_file(kind)
    if not path:
        return {}

    try:
        mtime = os.path.getmtime(path)
    except OSError:
        return {}

    if _cache[kind] and _cache_path[kind] == path and _cache_mtime[kind] == mtime:
        return _cache[kind]

    try:
        with open(path, "r", encoding="utf-8") as f:
            raw = f.read()
    except OSError:
        return {}

    parsed = _parse_group_lua(raw)
    _cache[kind] = parsed
    _cache_path[kind] = path
    _cache_mtime[kind] = mtime
    return parsed


def get_jobs_catalog() -> Dict[str, GroupMeta]:
    return _get_catalog("jobs")


def get_gangs_catalog() -> Dict[str, GroupMeta]:
    return _get_catalog("gangs")
