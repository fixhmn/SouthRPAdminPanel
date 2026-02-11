export const API_BASE = process.env.NEXT_PUBLIC_API_BASE || "http://localhost:8000";

export type AdminMe = {
  id: number;
  login: string;
  role_name: string;
  permissions: string[];
};

type RawAuthMe = {
  id: number;
  login: string;
  role: string;
  permissions: string[];
};

export type ApiError = {
  status: number;
  message: string;
};

export function getToken() {
  if (typeof window === "undefined") return "";
  return localStorage.getItem("admin_token") || "";
}

export function setToken(token: string) {
  if (typeof window === "undefined") return;
  localStorage.setItem("admin_token", token);
}

export function clearToken() {
  if (typeof window === "undefined") return;
  localStorage.removeItem("admin_token");
}

function toApiError(status: number, bodyText: string): ApiError {
  let message = bodyText;
  try {
    const parsed = JSON.parse(bodyText) as { detail?: unknown };
    if (parsed?.detail) {
      message = typeof parsed.detail === "string" ? parsed.detail : JSON.stringify(parsed.detail);
    }
  } catch {
    // fallback
  }
  return { status, message };
}

export async function api<T>(path: string, init: RequestInit = {}): Promise<T> {
  const token = getToken();
  const res = await fetch(`${API_BASE}${path}`, {
    ...init,
    headers: {
      ...(init.headers || {}),
      "Content-Type": "application/json",
      "X-Admin-Token": token,
    },
    cache: "no-store",
  });

  if (!res.ok) {
    const txt = await res.text();
    const err = toApiError(res.status, txt);
    throw new Error(`${err.status}: ${err.message}`);
  }

  return res.json() as Promise<T>;
}

export async function apiVoid(path: string, init: RequestInit = {}): Promise<void> {
  await api<unknown>(path, init);
}

export async function fetchMe(): Promise<AdminMe> {
  const raw = await api<RawAuthMe>("/auth/me");
  return {
    id: raw.id,
    login: raw.login,
    role_name: raw.role,
    permissions: raw.permissions,
  };
}

export function can(me: AdminMe | null, permission: string): boolean {
  if (!me) return false;
  return me.permissions.includes("*") || me.permissions.includes(permission);
}


export function roleLabel(roleName: string): string {
  const map: Record<string, string> = {
    administrator: "administrator",
    moderator: "moderator",
    helper: "helper",
    // legacy fallback mappings
    superadmin: "administrator",
    admin: "moderator",
    viewer: "helper",
  };
  return map[roleName] || roleName;
}

