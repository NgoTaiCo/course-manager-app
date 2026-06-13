# Course Manager App

> Language: English | [Tiếng Việt](README.md)

Course Manager App is the sample project for **A01 - Flutter Application Architecture: Clean Architecture, Design Patterns & BLoC State Design**.

This repository is not only a Flutter UI demo. Its main purpose is to help learners see how a Flutter app can evolve from a naive implementation into a more production-oriented structure: clear responsibilities, boundaries between presentation/domain/data, BLoC-driven state transitions, and repository/use case abstractions that reduce coupling between UI and data sources.

## Current status

The repository is currently at the early stage of the course:

- The app runs with a course list screen.
- Data is local mock data; there is no real backend.
- The UI still accesses data directly so learners can see the problems of a naive approach.
- Full Clean Architecture, BLoC, repository, use case, and DI are not fully applied yet.

This is intentional. Later milestones should refactor the project step by step so learners understand why the architecture is useful instead of copying a finished template.

## Who should use this repo?

This repo is useful for:

- Learners who already know basic Dart and Flutter.
- Developers who want to organize Flutter apps more deliberately.
- Junior/Middle Flutter developers learning pragmatic Clean Architecture.
- Learners studying BLoC together with data flow, boundaries, and dependency direction.
- Developers using AI coding assistants who still want standards for reviewing and refactoring code.

This repo is not designed for someone learning Flutter from zero.

## Versions

| Item | Version |
|---|---:|
| App version | `1.0.0+1` |
| Flutter | `3.44.2` |
| Dart SDK constraint | `>=3.4.4 <4.0.0` |

The Flutter version is pinned in `.fvmrc`:

```json
{
  "flutter": "3.44.2"
}
```

If you use FVM, prefer running Flutter commands through `fvm flutter ...` so the learner machine, instructor machine, and CI use the same Flutter version.

## Install and run

### 1. Clone the repo

```bash
git clone https://github.com/NgoTaiCo/course-manager-app.git
cd course-manager-app
```

### 2. Install the correct Flutter version with FVM

```bash
fvm install
```

Then verify:

```bash
fvm flutter --version
```

Flutter should be `3.44.2`.

### 3. Install packages

```bash
fvm flutter pub get
```

### 4. Run the app

```bash
fvm flutter run
```

If you do not use FVM, make sure your global Flutter installation is `3.44.2`, then run:

```bash
flutter pub get
flutter run
```

## Main packages

Packages currently used in the repo:

- `flutter_bloc`: used in later BLoC milestones.
- `equatable`: helps compare states/models.
- `get_it`: simple dependency injection.
- `freezed`: optional support for immutable/union states.
- `json_serializable`: optional support for DTO/model serialization in the data layer.

Do not add packages only for convenience. In A01, each package should support a clear learning goal.

## Current structure

```text
lib/
  main.dart
  app/
    app.dart
  features/
    course/
      course.dart
      course_data.dart
      pages/
        course_list_page.dart
        course_detail_page.dart
      widgets/
        course_card.dart
```

Current meaning:

- `course.dart`: simplified model, not yet separated into entity/DTO.
- `course_data.dart`: local mock data.
- `course_list_page.dart`: naive list screen with filter logic still inside the Widget.
- `course_detail_page.dart`: detail screen using the current model directly.
- `course_card.dart`: UI widget for displaying a course.

Later milestones can evolve this into a feature-first Clean Architecture structure:

```text
lib/
  app/
  core/
  features/
    course/
      domain/
      data/
      presentation/
```

## Learning with tags

The repository uses Git tags to mark each module/milestone. Learners can checkout a tag to inspect the code at the exact point in the course.

Available tags:

| Tag | Meaning | Status |
|---|---|---|
| `m0-setup` | Project setup, runnable app | Available |
| `m1-naive-course-list` | Naive Course List used to demonstrate problems | Available |

Planned tags for later modules:

| Tag | Goal |
|---|---|
| `m2-domain-modeling` | Separate domain entity and repository contract |
| `m3-data-mock` | Mock data source, repository implementation, mapper |
| `m4-course-list-bloc` | CourseListBloc, event/state, UI rendering from state |
| `m5-course-detail-enrollment` | Detail flow and enrollment use case |
| `m6-my-learning-progress` | My Learning and progress flow |
| `m7-refactor-review` | Refactor, boundary review, production checklist |
| `m8-ai-workflow` | AI-assisted review/refactor workflow |

Note: `m0-setup` and `m1-naive-course-list` currently point to the same first clean commit. From later modules onward, each tag should point to its own milestone commit.

## Checkout a tag for learning

List tags:

```bash
git tag --list
```

Checkout a tag directly:

```bash
git checkout m1-naive-course-list
```

This puts the repo in detached HEAD mode. If you want to study and edit code, create a learning branch from the tag:

```bash
git checkout -b learn/m1-naive-course-list m1-naive-course-list
```

Return to the main branch:

```bash
git checkout main
```

## Learning/refactoring rules

When doing exercises or refactoring, use these questions:

- Is a Widget calling a data source directly?
- Is business logic living in the UI?
- Does the domain layer import Flutter or data-layer packages?
- Is an entity mixed with DTO/fromJson/toJson concerns?
- Does BLoC depend on a use case or on a concrete implementation?
- Can mock data be replaced by an API without changing much UI?
- Are loading, empty, and error states represented clearly?

The goal is not to force Clean Architecture into every file. The goal is to use architecture to reduce the cost of change as the app grows.

## Out of scope for A01

To keep the course focused, this repo does not go deep into:

- real backend integration;
- real authentication;
- advanced Dio/Retrofit usage;
- complex local database work;
- push notifications;
- payments;
- realtime sockets;
- advanced CI/CD;
- deep performance profiling.

Those topics fit better in later courses.

## Notes for viewers/learners

- Read tags in order instead of only looking at `main`.
- When you see naive code, do not rush to fix it; write down the problem first.
- Every refactor should answer: "Why does this change make the code easier to extend or test?"
- If you use AI to generate code, ask it to explain trade-offs and review boundaries, not just create more files.
- Mock data is enough for A01. A real backend would pull attention away from the architecture lesson.
