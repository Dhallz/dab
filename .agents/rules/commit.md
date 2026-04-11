---
trigger: always_on
glob: "**/*"
description: Git commit discipline — per task, issue keys, no AI attribution
---

# Git commit rule

## One commit per task

- After each **discrete, completed task** (or clearly reviewable slice), **create a commit** with that work. Do not accumulate unrelated changes into a single end-of-session commit.
- A task is done when its code is in shape per project rules (analyzer clean, tests updated/run as required, docs or Bruno updated when applicable).

## Tie commits to the active issue

- When work maps to a tracker issue (e.g. Linear **DAB-40**), **every commit subject must include that issue key** so history is searchable and reviewable.

## Subject line (first line)

- Preferred form: `DAB-NN: Short imperative description` (issue id, colon, space, summary).
- Use **imperative mood** (`Add`, `Fix`, `Align`), not past tense or “Adding…”.
- Keep the first line roughly **72 characters** or fewer.

## Body

- For non-trivial changes, add a blank line after the subject, then **what changed and why** in clear, complete sentences—same tone as a good PR description, not raw chat or internal checklists.

## Do not put in commit messages

- Any note that the change was made **by Cursor, Copilot, ChatGPT**, or another AI assistant.
- **Generated-by** / **Co-authored-by** lines (or similar) whose only purpose is to credit a tool.
- Session meta (“fixed lints”, “address review”) unless that is the actual substance of the commit and still written professionally.

## Examples

**Good**

```text
DAB-40: Map bootstrap lock failure to 403 on login

Reject credential exchange when no admins exist and the email is not the
configured bootstrap address. Surfaces BootstrapLockFailure in the auth flow.
```

**Bad**

```text
updates

Co-authored-by: Cursor <noreply@cursor.com>

DAB-40 wip
```
