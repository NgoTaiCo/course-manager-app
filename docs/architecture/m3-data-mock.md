# Milestone 3 - Data Mock

Milestone 3 thêm data layer mock cho feature course.

Mục tiêu của bước này là chứng minh repository trả về domain entity,
trong khi data source vẫn có thể dùng model dữ liệu thô giống API hoặc
local database.

## Data flow

```text
CourseListPage
    |
    v
GetCourses
    |
    v
CourseRepository
    |
    v
MockCourseRepository
    |
    v
MockCourseDataSource
    |
    v
CourseModel
    |
    v
CourseModelMapper.toDomain()
    |
    v
Course
```

## Thành phần mới

```text
data/
  datasources/
    mock_course_data_source.dart
  mappers/
    course_mapper.dart
  models/
    course_model.dart
  repositories/
    mock_course_repository.dart
```

## Quy tắc boundary

- `CourseModel` nằm ở data layer, có thể dùng String giống dữ liệu ngoài.
- `Course` nằm ở domain layer, dùng enum và business rule ổn định hơn.
- Mapper chịu trách nhiệm chuyển từ data model sang domain entity.
- Repository implementation nằm ở data layer và implement domain contract.
- UI không đọc static list trực tiếp nữa.

## Fake delay và fake error

`MockCourseDataSource` có hai cấu hình:

```dart
const MockCourseDataSource(
  delay: Duration(milliseconds: 700),
  shouldFail: false,
)
```

Đổi `shouldFail` thành `true` để demo lỗi tải dữ liệu.
Phần này giúp chuẩn bị cho M4, nơi CourseListBloc sẽ biểu diễn
loading/success/empty/failure rõ ràng hơn.
