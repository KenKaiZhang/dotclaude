# Python (Django / FastAPI / Flask)

## Type Hints & Style

- `from __future__ import annotations` at top of every file.
- Type hints on all function signatures, including return types. Use `TypeAlias` for complex types.
- Prefer `pathlib.Path` over `os.path`. Use f-strings over `.format()`.
- Follow existing project style (black, ruff, isort configs if present).

## Django

- Fat models, thin views. Business logic lives in model methods or service layer, not views.
- Always use `select_related` / `prefetch_related` to avoid N+1 queries. Check with `django-debug-toolbar`.
- Custom managers for reusable querysets. `objects.active()` over filtering in every view.
- Descriptive migration names: `--name add_status_to_order`, not auto-generated numbers.
- Use `get_object_or_404` in views. Raise `ValidationError` in models/forms.
- Signals only for decoupled side effects. Prefer explicit method calls.

## FastAPI

- Dependency injection for shared logic (auth, DB sessions, pagination).
- Response model on every endpoint: `response_model=UserResponse`. Explicit status codes.
- Use `Depends()` for auth, never trust client-side tokens without server validation.
- Background tasks for non-blocking work. Celery/ARQ for heavy async jobs.
- Pydantic models for request/response. Separate input models from DB models.

## API Design

- RESTful: plural nouns (`/users`, `/orders`), proper HTTP methods, consistent error shape.
- Pagination on all list endpoints. Cursor-based for large datasets, offset for simple cases.
- Version APIs when breaking changes are unavoidable: `/api/v1/`.

## Testing

- pytest with fixtures. Factory pattern (factory_boy) for test data — no raw model creation.
- Test behavior, not implementation. Test the API contract, not internal method calls.
- `@pytest.mark.django_db` for DB tests. Use `tmp_path` for file operations.
- Separate unit tests from integration tests. Fast tests run first.

## Configuration & Security

- Settings split by environment: `base.py`, `dev.py`, `prod.py` (Django) or env-based config.
- Secrets in environment variables, never in code. Use `python-decouple` or `pydantic-settings`.
- Pin all dependencies. Use `uv` or `pip-compile` for reproducible installs.
- CORS configured explicitly. CSRF on all mutation endpoints (Django). Rate limiting on auth endpoints.
