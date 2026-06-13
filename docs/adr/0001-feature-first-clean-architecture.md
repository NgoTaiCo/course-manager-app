# ADR 0001 - Use Feature-First Clean Architecture

## Status

Accepted

## Context

Course Manager App is a teaching project for A01. The project needs to show how
a Flutter app grows from a naive implementation into a more maintainable
architecture without becoming a heavy template too early.

The main risks are:

- UI calling mock data or data sources directly.
- Domain entities depending on JSON/API details.
- BLoC receiving implementation details instead of use cases.
- Students copying folders without understanding why boundaries exist.

## Decision

Use a feature-first structure for `features/course`:

```text
features/
  course/
    data/
    domain/
    presentation/
    pages/
    widgets/
```

Domain owns entities, repository contracts, and use cases.
Data owns models, mappers, data sources, and repository implementations.
Presentation owns BLoC/Cubit state management.
Pages and widgets render UI and dispatch BLoC/Cubit actions.

## Consequences

Positive:

- UI can change without changing data parsing.
- Mock data can later be replaced by API/database implementation.
- Domain remains easy to explain and test.
- Each milestone can introduce one boundary at a time.

Trade-offs:

- More files than the naive version.
- Manual dependency wiring is still visible.
- Shared error/result abstractions are intentionally postponed.

For A01 this is acceptable because the project is a teaching artifact, not a
production template.
