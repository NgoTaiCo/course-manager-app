# Architecture Checklist

Use this checklist at the end of each milestone and before recording/reviewing
the module.

## Layer boundaries

- [x] Domain entities do not import Flutter.
- [x] Domain entities do not import data-layer files.
- [x] Domain entities do not contain `fromJson` or `toJson`.
- [x] Repository contracts live in domain.
- [x] Repository implementations live in data.
- [x] Data models and JSON parsing stay in data.
- [x] Mappers convert data models to domain entities.

## Presentation

- [x] Course List UI renders from `CourseListState`.
- [x] Course Detail UI renders from `CourseDetailState`.
- [x] My Learning UI renders from `MyLearningState`.
- [x] Widgets do not call data sources directly.
- [x] Widgets do not call repository implementations directly.
- [x] Course List uses BLoC because it has event/state transitions.
- [x] Course Detail uses BLoC because it has load and enroll flows.
- [x] My Learning uses Cubit because the current flow is command-based and small.

## Error flow

- [x] Mock data sources can throw fake failures.
- [x] Course List has failure UI and retry.
- [x] Course Detail has failure UI and retry.
- [x] Enrollment failure is surfaced through state and SnackBar.
- [x] My Learning has failure UI and retry.

## Current trade-offs

- [ ] There is no shared `Failure` or `Result` type yet.
- [ ] Dependencies are still wired manually in `course_dependencies.dart`.
- [ ] Formatting helpers still live in Widgets.
- [ ] There are no automated tests yet.
- [ ] Mock progress is in-memory only and resets after restart.

These trade-offs are acceptable for A01 because the goal is to teach boundaries
and state design before adding more infrastructure.
