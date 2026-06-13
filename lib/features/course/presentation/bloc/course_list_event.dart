import 'package:equatable/equatable.dart';

import '../../domain/entities/course.dart';

/// Event mô tả ý định của người dùng hoặc lifecycle của màn hình Course List.
///
/// M4 dùng event để thay thế việc UI tự gọi Future/use case.
sealed class CourseListEvent extends Equatable {
  const CourseListEvent();

  @override
  List<Object?> get props => [];
}

/// Event đầu tiên khi màn hình mở lên.
class CourseListStarted extends CourseListEvent {
  const CourseListStarted();
}

/// Event khi người dùng bấm thử lại sau lỗi tải dữ liệu.
class CourseListRetried extends CourseListEvent {
  const CourseListRetried();
}

/// Event khi người dùng chọn filter theo trạng thái khóa học.
class CourseListStatusFilterChanged extends CourseListEvent {
  final CourseStatus? status;

  const CourseListStatusFilterChanged(this.status);

  @override
  List<Object?> get props => [status];
}
