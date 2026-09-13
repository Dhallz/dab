---
trigger: manual
---

# DAB Rule: Implementation via @code

This rule governs the behavior of the agent when the user invokes the `@code` keyword.

## 🎯 Objective
To transition from the planning phase to the execution phase, implementing the approved design.

## 🛠️ Trigger & Workflow

When `@code` is detected:

1.  **Verify Plan Status**:
    *   Check for an existing `implementation_plan.md` artifact.
    *   Ensure the user has provided approval or that the `@code` command itself implies approval of the latest plan iteration.

2.  **Initialize Task Tracking**:
    *   Create or update a `task.md` artifact listing all atomic steps required for implementation.
    *   Mark the first task as "In Progress" (`[/]`).

3.  **Execute Implementation**:
    *   Follow the approved `implementation_plan.md` step-by-step.
    *   Perform code modifications using the appropriate tools (`replace_file_content`, `multi_replace_file_content`, `write_to_file`).
    *   Run `build_runner` or other necessary generation commands if schemas or data classes change (as per `data-classes.md`).

4.  **Continuous Verification**:
    *   As components are completed, verify them using the tests defined in the plan.
    *   Keep the `task.md` updated as progress is made.

5.  **Final Polish & Walkthrough**:
    *   Once all implementation tasks are finished, run a final analysis/test pass.
    *   Create a `walkthrough.md` artifact summarizing the changes and demonstrating the results (with screenshots/recordings if applicable).

## 🚫 Constraints
*   Do not deviate significantly from the approved plan without consulting the user first.
*   Always maintain documentation sync (as per `doc-maintenance.md`).
