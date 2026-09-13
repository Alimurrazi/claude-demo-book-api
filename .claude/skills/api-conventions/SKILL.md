---
name: api-conventions
description: Use when writing, editing, or reviewing REST API endpoint code (routes, controllers, request handlers) in this repo — covers response format, validation, naming, and rate limiting rules.
---
# API Conventions
- All endpoints return { data, error } shape
- Use zod for validation
- Endpoint names are kebab-case
- Every endpoint must have a rate limiter
