def license_tail(v: str | None) -> str | None:
    if not v:
        return None
    v = str(v).strip()
    return v.split(":", 1)[1] if ":" in v else v
