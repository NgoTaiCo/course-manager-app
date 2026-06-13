# Milestone 2 - Domain Modeling

Milestone 2 bắt đầu tách domain layer cho feature course.

Mục tiêu của bước này chưa phải là hoàn thiện toàn bộ Clean Architecture.
Mục tiêu là tạo các kiểu dữ liệu nghiệp vụ ổn định, không phụ thuộc Flutter,
Widget, mock data, API response, JSON hoặc database.

## Entity chính

```text
Course
  - status: CourseStatus
  - level: CourseLevel
  - canEnroll
  - hasDiscount

Lesson
  - courseId
  - contentType: LessonContentType
  - canPreviewWithoutEnrollment

Enrollment
  - courseId
  - userId
  - status: EnrollmentStatus
  - canContinueLearning

UserProgress
  - courseId
  - userId
  - completedLessonIds
  - progressRatio
  - markLessonCompleted(...)
```

## Use case và repository boundary

```text
Presentation
    |
    v
GetCourses use case
    |
    v
CourseRepository interface
    |
    v
Data implementation (Milestone 3)
```

Trong milestone này, `CourseRepository` mới chỉ là contract.
Mock data source và repository implementation được để dành cho `m3-data-mock`.

## Quy tắc boundary

- Domain entity không import Flutter.
- Domain entity không có `fromJson` hoặc `toJson`.
- Repository trong domain là interface, chưa phải implementation.
- `GetCourses` phụ thuộc repository contract, không phụ thuộc static mock data.
- UI hiện vẫn còn dùng entity trực tiếp để giữ bài học vừa đủ nhỏ.
