# Milestone 6 - My Learning + Progress

Milestone 6 thêm màn hình "Khóa học của tôi" và cập nhật progress local mock.

## Vì sao dùng Cubit?

M6 chọn `MyLearningCubit` thay vì BLoC vì flow hiện tại đơn giản:

- load danh sách khóa học của tôi;
- bấm hoàn thành bài tiếp theo;
- cập nhật progress local;
- render lại danh sách.

Chưa có nhiều loại event phức tạp như Course List hoặc Course Detail, nên Cubit
giúp code ngắn hơn mà vẫn giữ được state rõ ràng.

## My Learning flow

```text
MyLearningPage
    |
    v
MyLearningCubit.loadMyCourses()
    |
    v
GetMyCourses
    |
    v
LearningRepository
    |
    v
MockLearningRepository
    |
    v
MockLearningDataSource
```

## Progress update flow

```text
Complete next lesson button
    |
    v
MyLearningCubit.completeNextLesson(...)
    |
    v
UpdateLessonProgress
    |
    v
LearningRepository.updateLessonProgress
    |
    v
MockLearningDataSource
```

## State

```text
MyLearningStatus.initial
MyLearningStatus.loading
MyLearningStatus.success
MyLearningStatus.empty
MyLearningStatus.failure
```

`MyLearningState` giữ:

- danh sách `MyLearningCourse`;
- course id đang update progress;
- error message nếu có lỗi.

## Local mock progress

`MockLearningDataSource` giữ progress trong memory bằng map local.
Khi bấm hoàn thành bài tiếp theo, data source thêm lesson id mới vào
`completedLessonIds`, sau đó UI render lại progress bar.

Khi restart app, dữ liệu trở về initial state. Đây là chủ ý của A01 để không
kéo local database hoặc backend thật vào milestone này.
