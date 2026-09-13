---
trigger: manual
---

# DAB Rule: Planning via @plan

This rule governs the behavior of the agent when the user invokes the `@plan` keyword followed by a Linear issue ID (e.g., `@plan DAB-40`).

## 🎯 Objective
To perform deep research, context gathering, and architectural design for a specific task without jumping into implementation.

## 🛠️ Trigger & Workflow

When `@plan [ISSUE_ID]` is detected:

1.  **Retrieve Task Context**:
    *   Use `get_issue` from the `linear-mcp-server` to fetch the title, description, and status of the specified issue.
    *   If the issue contains links to other issues or documents, fetch those as well if they seem relevant.

2.  **Codebase Research**:
    *   Search the codebase for existing patterns, entities, and logic related to the task.
    *   Consult `doc/` to understand the architectural implications.
    *   Check for relevant Knowledge Items (KIs) or past conversation logs if applicable.

3.  **Create Implementation Plan**:
    *   Generate a detailed `implementation_plan.md` artifact following the project's standard template.
    *   Ensure the plan includes:
        *   Proposed changes grouped by component.
        *   Files to be modified, created, or deleted.
        *   Clear verification steps (unit tests, manual testing).
        *   Open questions or design trade-offs.

4.  **Stop and Wait**:
    *   **CRITICAL**: Do not proceed to implementation after creating the plan.
    *   Set `request_feedback: true` in the artifact metadata.
    *   Summarize the plan briefly for the user and ask for their approval or comments.

## 🚫 Constraints
*   Never use code modification tools (`write_to_file`, `replace_file_content`, etc.) during the `@plan` phase, except for creating/updating artifacts.
*   The goal is purely informational and strategic.
