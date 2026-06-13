# Milestone 4 - Course List BLoC

Milestone 4 chuyển Course List từ `FutureBuilder` sang BLoC.

Mục tiêu là để UI không tự gọi use case hoặc data source nữa. UI chỉ gửi
event và render state.

## Luồng chính

```text
CourseListPage
    |
    v
CourseListStarted event
    |
    v
CourseListBloc
    |
    v
GetCourses
    |
    v
CourseRepository
    |
    v
MockCourseRepository
```

## Event

```text
CourseListStarted
CourseListRetried
CourseListStatusFilterChanged
```

## State

```text
CourseListStatus.initial
CourseListStatus.loading
CourseListStatus.success
CourseListStatus.empty
CourseListStatus.failure
```

`CourseListState` giữ:

- danh sách course gốc;
- trạng thái filter đang chọn;
- error message nếu tải dữ liệu thất bại;
- danh sách `visibleCourses` sau filter.

## Quy tắc boundary

- Widget không gọi data source trực tiếp.
- Widget không gọi repository trực tiếp.
- Widget không giữ logic filter danh sách.
- BLoC gọi use case.
- Use case gọi repository contract.
- Repository implementation và data source vẫn nằm trong data layer.

## Ghi chú về JSON parsing

Từ milestone này, mock data được biểu diễn bằng `List<Map<String, Object?>>`
để giả lập JSON/API response.

`CourseModel.fromJson` parse dữ liệu thô ở data layer. Domain entity `Course`
vẫn không có `fromJson` hoặc `toJson`.
