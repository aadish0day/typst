# Admin Module — Rules & Reference

> **Authoritative Reference for AI Agents**
> Location: [`/home/aadish/Documents/typst/FactStamp/Rules/Admin-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Admin-rules.md)
> Source of truth: `/home/aadish/Documents/Github/FactStamp` (React 18 + Vite + Firebase codebase)

---

## 1. Purpose

Documents the FactStamp **Admin Command Center** — the staff-only moderation console at `/admin`. Use this file when writing dissertation content (e.g. Chapter 4 "Basic Modules", Chapter 4.4 "Security Issues", or a dedicated Module submission) that describes administrative functionality, so the write-up matches the actual implementation instead of a generic description.

## 2. Scope

`/admin` is an **unlisted route** — it is intentionally excluded from the public `Navbar`/`Footer` layout (`App.tsx` renders it standalone, outside the normal page chrome) and is reached only by typing the URL directly. It gives a verified administrator moderation and database-integrity controls over the entire platform: users, claims, incident reports, and system-wide tools.

## 3. Access Control & Authentication Flow

| File | Role |
|---|---|
| [`src/components/AdminRoute.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/AdminRoute.tsx) | Route guard wrapping `<Admin />` in `App.tsx` (`<Route path="/admin" element={<AdminRoute><Admin /></AdminRoute>} />`). Renders a username/password login gate until clearance is verified. |
| [`src/services/firebaseService.ts`](file:///home/aadish/Documents/Github/FactStamp/src/services/firebaseService.ts) (`authenticateAdmin`) | Signs in against Firebase Auth, then reads the user's Firestore profile and throws `Access denied` unless `isAdmin === true`. |
| [`src/lib/security.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/security.ts) | Client-side hardening used by the admin gate: `checkLoginRateLimit`, `recordFailedLogin`, `resetLoginAttempts` (5 attempts → 15-minute lockout), and `formatLockoutRemaining`. |
| [`firestore.rules`](file:///home/aadish/Documents/Github/FactStamp/firestore.rules) | Server-side source of truth. `isAdmin()` helper checks `users/{uid}.isAdmin == true`; every admin-only write path (`allow update/delete`) gates on `isAdmin() || isSeedUser()`. |
| [`scripts/create-admin.mjs`](file:///home/aadish/Documents/Github/FactStamp/scripts/create-admin.mjs) | CLI provisioning script — creates a Firebase Auth user and writes a Firestore `users/{uid}` profile with `isAdmin: true`. |

**Security model — critical fact for write-ups:**
- Clearance is **not** just a `sessionStorage` flag. `AdminRoute` stores `fs_admin_session_unlocked` in `sessionStorage` for UX persistence, but on every render it re-derives `hasVerifiedAdminRole = user?.isAdmin === true` from the live Firestore-backed `useAuth()` snapshot. If the flag is present but the profile lacks `isAdmin`, the session key is discarded and the user is bounced back to the login gate — this specifically defeats a DevTools `sessionStorage.setItem(...)` bypass attempt.
- `isAdmin` can only be flipped server-side by an existing admin (`firestore.rules` restricts writes to that field); a normal user cannot self-promote.
- The console has a "Lock Console" button that clears `fs_admin_session_unlocked` and reloads, forcing re-authentication.

## 4. UI Structure — `src/pages/Admin.tsx`

Single-page console with 5 tabs (`AdminTab` union type: `'overview' | 'users' | 'claims' | 'reports' | 'tools'`):

1. **System Overview** — KPI cards (registered verifiers, total claims, verifications logged, incident queue size) plus Recharts visualizations: claims-by-category bar chart, verdict-consensus pie chart, and a verifier reputation-tier breakdown (Novice/Trusted/Expert/Elite).
2. **Verifier Directory (Users)** — searchable/filterable table of all `User` records. Per-row actions: edit reputation score, toggle `isAdmin` (promote/revoke), delete account.
3. **Claims Moderation** — searchable/filterable table of all `Claim` records. Per-row actions: toggle expedited-review flag (`adminFlagged`), override verdict/confidence/status, edit claim text & category, inspect/delete individual verifications, hard-delete the claim.
4. **Incident Queue (Reports)** — moderation ticket queue (`ModerationReport`) filterable by status (`pending | investigating | resolved | dismissed`) and severity (`low | medium | high`); supports creating, resolving, and dismissing reports.
5. **Audit & Tools** — immutable audit log viewer (`AdminAuditLog`), plus system tools: broadcast a notification to all users, force-run consensus expiry on overdue claims, export a full JSON database backup (claims + users + reports + audit logs).

Every mutating action funnels through a local `addAuditLog()` helper that writes to both Firestore (`addAuditLogToFirestore`) and local state, so every admin action is independently auditable.

## 5. Data Model (from `src/lib/types.ts`)

| Type | Key Fields | Purpose |
|---|---|---|
| `User.isAdmin?` | `boolean` | Single source of truth for staff clearance (also read server-side by `firestore.rules`). |
| `Claim.adminFlagged?` / `adminFlaggedAt?` | `boolean` / `string` | Marks a claim for expedited verifier review. |
| `ModerationReport` | `targetType`, `targetId`, `reason`, `severity`, `status`, `actionTaken`, `resolvedBy` | Incident/report ticket for claims, users, or verifications. |
| `AdminAuditLog` | `timestamp`, `adminId`, `adminName`, `action`, `targetType`, `targetId`, `details` | Immutable trail of every administrative action. |

## 6. Backend Service Functions (`src/services/firebaseService.ts`)

- `authenticateAdmin(usernameOrEmail, password)` — admin login (see §3).
- `adminUpdateUserDoc(uid, updates)` / `adminDeleteUser` — user moderation.
- `adminOverrideClaim(claimId, updates)` / hard-delete claim — claim moderation.
- `adminDeleteVerification(claimId, verificationId)` — remove an illegitimate verification.
- `createModerationReport`, `updateReportInFirestore`, `subscribeReportsRealtime` — incident queue (realtime Firestore listener).
- `addAuditLogToFirestore`, `subscribeAuditLogsRealtime` — audit trail (realtime Firestore listener).

## 7. Rules for AI Agents

1. **Never describe `/admin` as publicly linked navigation** — it is deliberately unlisted; state this explicitly when writing UI/UX or security sections.
2. **Always cite the dual-layer authorization** (client-side `AdminRoute` re-check + server-side `firestore.rules` `isAdmin()`) when writing Chapter 4.4 "Security Issues" or Chapter 4.2.2 "Data Integrity and Constraints" — this is the project's actual anti-bypass mechanism, not a generic "role-based access control" claim.
3. **When documenting the 5 tabs**, keep the exact names used in the UI (System Overview, Verifier Directory, Claims Moderation, Incident Queue, Audit & Tools) so screenshots and prose stay consistent.
4. **Cross-reference [`Module-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Module-rules.md)** for how the Admin console relates to the 7 core system modules (it is a cross-cutting moderation layer over Modules 1, 4, and 5, plus its own Module 8 security/notification subsystem).
5. **Do not invent admin features** (e.g. billing, multi-tenant orgs) that aren't in `Admin.tsx` — the console is scoped to the 5 tabs listed in §4.
