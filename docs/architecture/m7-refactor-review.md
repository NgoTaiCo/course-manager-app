# Milestone 7 - Refactor & Architecture Review

Milestone 7 pauses feature work and reviews the architecture built from M2 to
M6.

## Review summary

```text
UI
  -> BLoC/Cubit
  -> Use case
  -> Repository contract
  -> Repository implementation
  -> Data source
  -> Data model / mapper
  -> Domain entity
```

## Boundary review

- Domain entities are independent from Flutter and data packages.
- Data models own JSON/map parsing.
- Mappers convert data models to domain entities.
- Repository contracts are in domain.
- Repository implementations are in data.
- Course List and Course Detail use BLoC.
- My Learning uses Cubit with a documented reason.

## Naming review

- `CourseModel`, `EnrollmentModel`, and `UserProgressModel` are data-layer models.
- `Course`, `Enrollment`, `UserProgress`, and `MyLearningCourse` are domain entities.
- `Mock*DataSource` classes simulate external data sources.
- `Mock*Repository` classes implement domain contracts for teaching/demo.
- `*Bloc` is used when event/state transitions are explicit.
- `*Cubit` is used for simpler command-based state.

## Error-flow review

Current error handling is intentionally simple:

- data sources throw mock exceptions;
- repositories do not normalize failures yet;
- BLoC/Cubit catches errors and emits failure states/messages.

This is enough for A01. A later module can introduce a shared `Failure` or
`Result<T>` abstraction if needed.

## Documents added in M7

- `docs/architecture-checklist.md`
- `docs/adr/0001-feature-first-clean-architecture.md`

## Remaining work for later modules

- Add tests for use cases, mappers, BLoC, and Cubit.
- Replace manual dependency wiring with `get_it` if the course needs DI.
- Move repeated UI formatting helpers out of Widgets if duplication grows.
- Add shared error/result types when error handling becomes a teaching focus.
