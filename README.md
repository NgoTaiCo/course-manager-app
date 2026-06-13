# Course Manager App

> Ngôn ngữ: Tiếng Việt | [English version](README.en.md)

Course Manager App là project mẫu cho module **A01 - Flutter Application Architecture: Clean Architecture, Design Patterns & BLoC State Design**.

Repo này không chỉ để xem UI Flutter. Mục tiêu chính là giúp người học quan sát một app Flutter đi từ cách làm naive sang cách tổ chức production hơn: tách trách nhiệm, rõ boundary giữa presentation/domain/data, dùng BLoC cho state transition, dùng repository/use case để giảm phụ thuộc giữa UI và data source.

## Trạng thái hiện tại

Repo hiện đang ở giai đoạn đầu của khóa:

- App chạy được với màn hình danh sách khóa học.
- Dữ liệu đang là mock data local, chưa có backend thật.
- UI đang truy cập dữ liệu trực tiếp để người học thấy vấn đề của cách làm naive.
- Chưa áp dụng đầy đủ Clean Architecture, BLoC, repository, use case hoặc DI.

Điều này là có chủ ý. Các milestone sau sẽ refactor từng bước để người học thấy rõ vì sao cần architecture, không chỉ copy sẵn một template hoàn chỉnh.

## Ai nên dùng repo này?

Repo phù hợp với:

- Người đã biết Dart và Flutter cơ bản.
- Người muốn học cách tổ chức Flutter app có cấu trúc hơn.
- Junior/Middle Flutter developer muốn hiểu Clean Architecture vừa đủ.
- Người học BLoC nhưng muốn hiểu cả luồng data, boundary và dependency direction.
- Người dùng AI coding assistant nhưng muốn có tiêu chuẩn để review/refactor code.

Repo không dành cho người mới học Flutter từ số 0.

## Phiên bản

| Thành phần | Phiên bản |
|---|---:|
| App version | `1.0.0+1` |
| Flutter | `3.44.2` |
| Dart SDK constraint | `>=3.4.4 <4.0.0` |

```json
{
  "flutter": "3.44.2"
}
```

Nếu bạn dùng FVM, hãy ưu tiên chạy mọi lệnh Flutter qua `fvm flutter ...` để tránh lệch version giữa máy học viên, máy giảng viên và CI.

## Cài đặt và chạy app

### 1. Clone repo

```bash
git clone https://github.com/NgoTaiCo/course-manager-app.git
cd course-manager-app
```

### 2. Cài Flutter đúng version bằng FVM

```bash
fvm install
```

Sau đó kiểm tra:

```bash
fvm flutter --version
```

Flutter nên là `3.44.2`.

### 3. Cài package

```bash
fvm flutter pub get
```

### 4. Chạy app

```bash
fvm flutter run
```

Nếu bạn không dùng FVM, hãy đảm bảo Flutter global trên máy đang là `3.44.2`, rồi chạy:

```bash
flutter pub get
flutter run
```

## Package chính

Các package trong repo hiện tại:

- `flutter_bloc`: dùng cho các milestone BLoC sau.
- `equatable`: hỗ trợ so sánh state/model.
- `get_it`: dependency injection đơn giản.
- `freezed`: optional cho immutable/union state nếu cần.
- `json_serializable`: optional cho DTO/model ở data layer nếu cần.

Không nên thêm package mới chỉ vì tiện. Trong khóa A01, mỗi package nên phục vụ một điểm học rõ ràng.

## Cấu trúc repo hiện tại

```text
lib/
  main.dart
  app/
    app.dart
  features/
    course/
      course.dart
      course_data.dart
      data/
        datasources/
          mock_course_data_source.dart
        mappers/
          course_mapper.dart
          enrollment_mapper.dart
          user_progress_mapper.dart
        models/
          course_model.dart
          enrollment_model.dart
          user_progress_model.dart
        repositories/
          mock_course_repository.dart
          mock_enrollment_repository.dart
          mock_learning_repository.dart
      domain/
        entities/
          course.dart
          lesson.dart
          enrollment.dart
          user_progress.dart
        repositories/
          course_repository.dart
          enrollment_repository.dart
          learning_repository.dart
        usecases/
          enroll_course.dart
          get_course_detail.dart
          get_courses.dart
          get_my_courses.dart
          update_lesson_progress.dart
      presentation/
        bloc/
          course_list_bloc.dart
          course_list_event.dart
          course_list_state.dart
          course_detail_bloc.dart
          course_detail_event.dart
          course_detail_state.dart
        cubit/
          my_learning_cubit.dart
          my_learning_state.dart
      pages/
        course_list_page.dart
        course_detail_page.dart
        my_learning_page.dart
      widgets/
        course_card.dart
```

Ý nghĩa hiện tại:

- `course.dart`: barrel export cho domain API của feature course.
- `course_data.dart`: mock data local ở dạng `CourseModel`.
- `data/models/course_model.dart`: model dữ liệu thô của data layer.
- `data/models/enrollment_model.dart`: model dữ liệu thô cho enrollment.
- `data/models/user_progress_model.dart`: model dữ liệu thô cho progress.
- `data/datasources/mock_course_data_source.dart`: mock data source có fake delay/fake error.
- `data/datasources/mock_enrollment_data_source.dart`: mock data source cho enroll có fake failure.
- `data/datasources/mock_learning_data_source.dart`: mock data source lưu progress local in-memory.
- `data/mappers/course_mapper.dart`: mapper từ `CourseModel` parse từ JSON-like map sang domain `Course`.
- `data/mappers/enrollment_mapper.dart`: mapper từ `EnrollmentModel` sang domain `Enrollment`.
- `data/mappers/user_progress_mapper.dart`: mapper từ `UserProgressModel` sang domain `UserProgress`.
- `data/repositories/mock_course_repository.dart`: repository implementation trả về domain entity.
- `data/repositories/mock_enrollment_repository.dart`: repository implementation cho enrollment flow.
- `data/repositories/mock_learning_repository.dart`: repository implementation cho My Learning/progress.
- `domain/entities/`: domain entities không import Flutter hoặc data package.
- `domain/repositories/course_repository.dart`: repository contract.
- `domain/repositories/enrollment_repository.dart`: repository contract cho enroll.
- `domain/repositories/learning_repository.dart`: repository contract cho My Learning/progress.
- `domain/usecases/get_courses.dart`: use case đầu tiên.
- `domain/usecases/get_course_detail.dart`: use case lấy detail theo id.
- `domain/usecases/enroll_course.dart`: use case đăng ký khóa học.
- `domain/usecases/get_my_courses.dart`: use case lấy khóa học của tôi.
- `domain/usecases/update_lesson_progress.dart`: use case cập nhật progress bài học.
- `presentation/bloc/`: CourseListBloc và CourseDetailBloc với event/state tương ứng.
- `presentation/cubit/`: MyLearningCubit cho flow progress đơn giản.
- `course_list_page.dart`: màn hình list render theo BLoC state, không gọi data source trực tiếp.
- `course_detail_page.dart`: màn hình detail load theo course id và enroll qua BLoC.
- `my_learning_page.dart`: màn hình khóa học của tôi và cập nhật progress local.
- `course_card.dart`: widget hiển thị course.
- `docs/architecture-checklist.md`: checklist review boundary, state, error flow và naming.
- `docs/adr/0001-feature-first-clean-architecture.md`: ADR ngắn cho quyết định kiến trúc.
- `docs/architecture/m2-domain-modeling.md`: sơ đồ entity/use case cho milestone 2.
- `docs/architecture/m3-data-mock.md`: sơ đồ data source/mapper/repository cho milestone 3.
- `docs/architecture/m4-course-list-bloc.md`: sơ đồ event/state cho milestone 4.
- `docs/architecture/m5-course-detail-enrollment.md`: sơ đồ detail/enrollment flow cho milestone 5.
- `docs/architecture/m6-my-learning-progress.md`: sơ đồ My Learning/progress cho milestone 6.
- `docs/architecture/m7-refactor-review.md`: tổng kết review/refactor cho milestone 7.

Các milestone sau có thể mở rộng sang cấu trúc feature-first Clean Architecture:

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

## Cách học bằng tag

Repo dùng tag Git để đánh dấu từng milestone/module. Người học có thể checkout tag để xem code tại đúng thời điểm trong khóa.

Các tag hiện có:

| Tag | Ý nghĩa | Trạng thái |
|---|---|---|
| `m0-setup` | Setup project, app chạy được | Có sẵn |
| `m1-naive-course-list` | Naive Course List để demo vấn đề | Có sẵn |
| `m2-domain-modeling` | Domain entities, repository contract, `GetCourses` use case | Có sẵn |
| `m3-data-mock` | Mock data source, repository implementation, mapper | Có sẵn |
| `m4-course-list-bloc` | CourseListBloc, event/state, UI render theo state | Có sẵn |
| `m5-course-detail-enrollment` | Course detail BLoC, `GetCourseDetail`, `EnrollCourse` | Có sẵn |
| `m6-my-learning-progress` | My Learning screen, `GetMyCourses`, `UpdateLessonProgress` | Có sẵn |
| `m7-refactor-review` | Architecture checklist, boundary review, ADR | Có sẵn |

Các tag dự kiến cho những module tiếp theo:

| Tag | Mục tiêu |
|---|---|
| `m8-ai-workflow` | AI-assisted review/refactor workflow |

Lưu ý: `m0-setup` đánh dấu project Flutter chạy được ban đầu. `m1-naive-course-list` đánh dấu phiên bản naive có static course list, course card và navigation sang detail để làm chất liệu refactor. `m2-domain-modeling` bắt đầu tách domain layer. `m3-data-mock` thêm data layer mock. `m4-course-list-bloc` đưa Course List sang event/state BLoC. `m5-course-detail-enrollment` đưa Course Detail và enroll flow sang BLoC/use case. `m6-my-learning-progress` thêm My Learning và progress local mock bằng Cubit. `m7-refactor-review` bổ sung checklist review, dọn tài liệu cấu trúc và ADR.

## Checkout một tag để học

Xem danh sách tag:

```bash
git tag --list
```

Checkout trực tiếp một tag:

```bash
git checkout m1-naive-course-list
```

Cách này đưa repo vào detached HEAD. Nếu muốn vừa học vừa sửa code, nên tạo branch học riêng từ tag:

```bash
git checkout -b learn/m1-naive-course-list m1-naive-course-list
```

Quay lại branch chính:

```bash
git checkout main
```

## Quy tắc học/refactor trong repo này

Khi làm bài hoặc refactor, ưu tiên các câu hỏi sau:

- Widget có đang gọi data source trực tiếp không?
- Logic nghiệp vụ có nằm trong UI không?
- Domain có import Flutter hoặc package data không?
- Entity có bị trộn với DTO/fromJson/toJson không?
- BLoC có phụ thuộc use case hay phụ thuộc implementation cụ thể?
- Có thể đổi mock data sang API mà không sửa nhiều UI không?
- Loading, empty và error state có được biểu diễn rõ không?

Mục tiêu không phải là nhét Clean Architecture vào mọi file, mà là dùng architecture để giảm chi phí thay đổi khi app lớn lên.

## Phạm vi không làm trong A01

Để khóa học không bị loãng, repo này chưa tập trung vào:

- backend thật;
- authentication thật;
- Dio/Retrofit nâng cao;
- local database phức tạp;
- push notification;
- payment;
- realtime socket;
- CI/CD chuyên sâu;
- performance profiling chuyên sâu.

Các phần đó phù hợp hơn cho những khóa sau.

## Ghi chú cho người xem/người học

- Hãy đọc tag theo thứ tự thay vì chỉ xem `main`.
- Khi thấy code naive, đừng vội sửa ngay; hãy ghi lại vấn đề trước.
- Mỗi refactor nên trả lời được: "vì sao thay đổi này làm code dễ mở rộng hoặc dễ test hơn?"
- Nếu dùng AI để sinh code, hãy yêu cầu AI giải thích trade-off và review boundary, không chỉ yêu cầu viết thêm file.
- Mock data là đủ cho A01. Backend thật sẽ làm bài học lệch khỏi trọng tâm architecture.
