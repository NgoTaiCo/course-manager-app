import 'package:equatable/equatable.dart';

/// Event của màn hình Course Detail.
sealed class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event khi màn hình detail được mở theo course id.
class CourseDetailStarted extends CourseDetailEvent {
  final String courseId;

  const CourseDetailStarted(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

/// Event khi người dùng bấm thử lại sau lỗi tải detail.
class CourseDetailRetried extends CourseDetailEvent {
  const CourseDetailRetried();
}

/// Event khi người dùng bấm đăng ký khóa học.
class CourseEnrollPressed extends CourseDetailEvent {
  const CourseEnrollPressed();
}
