# Insights Dashboard Build Prompt 🍱

Use this prompt with `StitchMCP` (e.g., `generate_screen_from_text`) to create the initial UI for the DAB Insights Dashboard.

---

## The Prompt

Design a premium, **glassmorphic** 'Team Insights' dashboard for DAB (Dev Activity Board). DAB aggregates Slack, GitHub, and Phorge events. The dashboard should feature:

1.  **Header**: "Team Insights" with a subtle "Last updated" timestamp and a "Live" status badge.
2.  **Team Pulse Grid**: A real-time grid of team members (avatars) with 'Presence' indicators (Green dot for online, Grey for offline, Orange for idle). Show a small '7-day activity' sparkline next to each person.
3.  **Core Metrics (Cards)**:
    - **Total Velocity**: Number of events in the last 24h with a percentage change.
    - **Most Active Provider**: Which tool (Slack/GitHub/Phorge) is currently buzzing.
    - **Team Health**: A custom score based on task completion vs message volume.
4.  **Activity Velocity Chart**: A multi-series area chart showing activity volume across providers over the last 7 days. Use distinct vibrant colors: GitHub (Emerald), Slack (Amethyst), Phorge (Amber).
5.  **Unified Heat Map**: A monthly contribution calendar (GitHub style) that combines events from ALL connected tools.
6.  **Provider Distribution**: A glassmorphic donut chart showing the split of activity types (e.g., Commits vs Comments vs Task Updates).

**Design Language**:
- **Background**: Deep slate/navy gradients (`#0F172A` to `#1E293B`).
- **Cards**: Translucent white/slate backgrounds with high-sigma background blur (30px) and a subtle 1px white border (0.1 opacity).
- **Shadows**: Soft, multi-layered colored shadows for active cards.
- **Typography**: Inter or similar sans-serif. Bold headers and tabular figures for numbers.
- **Animations**: Staggered entrance animations for charts and grid items.

---

## Instructions for Antigravity

1.  Open the `StitchMCP` tool.
2.  Call `generate_screen_from_text` with the `projectId` (you may need to find it first or create one if this is the first screen).
3.  Use the prompt above as the input.
4.  Once generated, review the code and integrate it into `dab_app/lib/presentation/views/insights/`.
