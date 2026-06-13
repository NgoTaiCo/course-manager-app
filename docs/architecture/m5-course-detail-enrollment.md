# Milestone 5 - Course Detail + Enrollment

Milestone 5 đưa màn hình Course Detail và hành động enroll sang BLoC/use case.

## Detail flow

```text
CourseListPage
    |
    v
CourseDetailPage(courseId)
    |
    v
CourseDetailStarted
    |
    v
CourseDetailBloc
    |
    v
GetCourseDetail
    |
    v
CourseRepository.getCourseById
```

Màn hình detail không nhận trực tiếp object `Course` từ list nữa. Nó nhận
`courseId`, sau đó tự load dữ liệu qua BLoC.

## Enrollment flow

```text
Enroll button
    |
    v
CourseEnrollPressed
    |
    v
CourseDetailBloc
    |
    v
EnrollCourse
    |
    v
EnrollmentRepository
    |
    v
MockEnrollmentRepository
    |
    v
MockEnrollmentDataSource
```

## State chính

```text
CourseDetailStatus.initial
CourseDetailStatus.loading
CourseDetailStatus.success
CourseDetailStatus.failure

CourseEnrollStatus.idle
CourseEnrollStatus.submitting
CourseEnrollStatus.success
CourseEnrollStatus.failure
```

## Fake failure

`MockEnrollmentDataSource` có `shouldFail`.

```dart
const MockEnrollmentDataSource(
  shouldFail: true,
)
```

Dùng flag này để demo nút enroll chuyển sang failure và UI hiển thị message lỗi.

## Quy tắc boundary

- Course Detail UI không gọi data source trực tiếp.
- Course Detail UI không gọi repository trực tiếp.
- Detail load đi qua `GetCourseDetail`.
- Enroll đi qua `EnrollCourse`.
- Repository implementation và data source vẫn nằm ở data layer.
