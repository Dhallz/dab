# Prompter

> [!TIP]
> **New Agent Initialization (Copy & Paste)**: 
> "You have a shared prompt library at: `/Users/dhallz/git/dab/artifacts/prompter.md`. Whenever I give you an alias in brackets like `[DAB_SYNC]`, use your `view_file` tool to read that file, find the corresponding instructions, and execute them. **Immediately execute `[DAB_SYNC]` upon receiving this initialization.**"

---

> [!IMPORTANT]
> **To any Agent reading this file**: 
> This document contains reusable prompt templates indexed by **Aliases** (e.g., `[ALIAS_NAME]`). 
> When a user provides an alias, locate the corresponding section in this file and follow the **Full Prompt** instructions exactly.

---

### [DAB_SYNC]
**Full Prompt**:
1. **Locate Project**: Identify the 'DAB' project in Linear and confirm its ID.
2. **Deep Document Dive**: Read all Project Documents, focusing on Architecture, Tech Stack, and PRDs.
3. **State Analysis**: Review the current Milestone and active Cycle to understand immediate goals.
4. **Active Issues**: Analyze the latest 'In Progress' and 'Todo' issues to grasp the current development roadmap.
5. **Resource Search**: Look for 'Coding Standards' or 'External Documentation' links.
6. **Validation**: Provide a summary of your understanding (stack, mission, priorities) before proceeding.

---

### [COMMIT_READY]
**Full Prompt**:
1. **Identify Tickets**: Scan Linear for tickets marked as 'Ready to Push' or equivalent status.
2. **Audit Local Changes**: Run `git status` and `git diff` to identify uncommitted files.
3. **Map Files to Tickets**: Verify which local changes correspond to the identified 'Ready to Push' tickets.
4. **Stage Changes**: Stage only the files relevant to the specific ticket being processed (atomic commits).
5. **Draft Commit Message**:
   - **Title**: Create a concise, imperative title (e.g., `feat(auth): add social login support`).
   - **Description**: Provide a bulleted list of changes and reference the Linear ticket ID.
6. **Commit**: Execute the commit with the drafted message.
7. **Status Update**: Confirm the commit hash and updated Linear status to the user.
