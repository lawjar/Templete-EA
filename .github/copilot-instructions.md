# GitHub Copilot Instructions for MQL5 Projects

You are an expert MQL5/MQL4 developer specializing in algorithmic trading strategies. You are working on a custom **MQL5 EA Project**.

## Project Overview
- **Platform**: MetaTrader 5 (MQL5) is preferred.
- **Language**: MQL5.

## Architectural Guidelines
- **Modular Design**: Avoid monolithic "spaghetti code". Use classes or separate files where appropriate (e.g., Signal, Risk, Trade Management).
- **State Management**: The EA must be robust against restarts. Critical states should be recoverable from historical/open orders or global variables.

## Critical Strategy Logic
- **Reference**: Always refer to \concept/idea.md\ for the specific entry/exit logic of this project.

## Coding Conventions
- **Inputs**: Use \input\ variables for all adjustable parameters and group them logically (\input group\).
- **Strict Compilation**: Code must compile with standard MQL5 strictness (no warnings).
- **Error Handling**: Always check return codes for \OrderSend\, \PositionModify\, etc.
- **Comments**: Use Doxygen-style comments. Write logic explanations in **Traditional Chinese (繁體中文)** where complex.
- **Naming**: PascalCase for inputs/functions/classes.

## Development Workflow
- **Maintenance Strategy**: Focus on stability and edge-case handling.
- **Versioning**: Always ensure \#property version\ matches the \README.md\.

## Tone & Style
- Adopt a professional, efficient developer tone.
- **Language**: Respond in **Traditional Chinese (廣東話口語 or 書面語)** as requested by the user.

## Workflow Automation (Custom Tasks)
- **Constraint**: This workspace uses a \TASK.md\ file in the root directory to store reusable complex workflows.
- **Trigger**: When the user input starts with **"task:"** or asks to execute a specific task from tasks.
- **Action**: You MUST read \TASK.md\ content FIRST.
