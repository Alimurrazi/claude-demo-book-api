# claude-code-demo

A small companion project built to accompany an ongoing series of articles about Claude Code, published on [dev.to](https://dev.to/alimurrazi).

The goal is to show these concepts working against a real, if minimal, codebase — a simple book API — rather than just describing them in the abstract. Each article in the series builds on the same project, adding a new layer.

## What's in here

- A small Node.js/Express REST API (`GET /get-books`) used as the running example
- `.claude/skills/api-conventions/` — a skill defining the project's endpoint conventions (response shape, validation, naming, rate limiting)
- `.claude/agents/code-reviewer.md` — a subagent that reviews endpoint code against the skill above
- `CLAUDE.md` — project-level rules Claude Code always loads

Later articles in the series add to this same project (hooks, then MCP), rather than starting from scratch each time.

## Article series

1. [Agents and Skills in Claude Code: A Beginner's Guide](https://dev.to/alimurrazi/agents-and-skills-in-claude-code-a-beginners-guide-24hk)
2. [Permissions & Tool Allowlisting in Claude Code: A Beginner's Guide](https://dev.to/alimurrazi/permissions-tool-allowlisting-in-claude-code-a-beginners-guide-592i)
3. [Hooks in Claude Code: A Beginner's Guide](https://dev.to/alimurrazi/hooks-in-claude-code-a-beginners-guide-5bae)
4. MCP in Claude Code — *coming soon*

## Running it

```bash
npm install
npm start
```

Then try:

```bash
curl http://localhost:3000/get-books
```

## Why this exists

Most explanations of Claude Code features are conceptual, which makes it hard to tell what's a hard guarantee versus a likely behavior. This repo exists so each article can point at real config files, real output, and (where relevant) real screenshots of the feature in action, instead of hypothetical examples.
