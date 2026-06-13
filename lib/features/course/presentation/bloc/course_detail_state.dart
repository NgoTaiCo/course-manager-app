import 'package:equatable/equatable.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';

/// Trạng thái tải dữ liệu của màn hình Course Detail.
enum CourseDetailStatus {
  initial,
  loading,
  success,
  failure,
}

/// Trạng thái riêng của hành động enroll.
enum CourseEnrollStatus {
  idle,
  submitting,
  success,
  failure,
}

/// State của CourseDetailBloc.
class CourseDetailState extends Equatable {
  final CourseDetailStatus detailStatus;
  final CourseEnrollStatus enrollStatus;
  final String? courseId;
  final Course? course;
  final Enrollment? enrollment;
  final String? errorMessage;
  final String? enrollErrorMessage;

  const CourseDetailState({
    required this.detailStatus,
    required this.enrollStatus,
    required this.courseId,
    required this.course,
    required this.enrollment,
    required this.errorMessage,
    required this.enrollErrorMessage,
  });

  const CourseDetailState.initial()
      : detailStatus = CourseDetailStatus.initial,
        enrollStatus = CourseEnrollStatus.idle,
        courseId = null,
        course = null,
        enrollment = null,
        errorMessage = null,
        enrollErrorMessage = null;

  CourseDetailState copyWith({
    CourseDetailStatus? detailStatus,
    CourseEnrollStatus? enrollStatus,
    String? courseId,
    Course? course,
    Enrollment? enrollment,
    String? errorMessage,
    String? enrollErrorMessage,
    bool clearErrorMessage = false,
    bool clearEnrollErrorMessage = false,
  }) {
    return CourseDetailState(
      detailStatus: detailStatus ?? this.detailStatus,
      enrollStatus: enrollStatus ?? this.enrollStatus,
      courseId: courseId ?? this.courseId,
      course: course ?? this.course,
      enrollment: enrollment ?? this.enrollment,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      enrollErrorMessage: clearEnrollErrorMessage
          ? null
          : enrollErrorMessage ?? this.enrollErrorMessage,
    );
  }

  bool get isInitial => detailStatus == CourseDetailStatus.initial;

  bool get isLoading => detailStatus == CourseDetailStatus.loading;

  bool get isSuccess => detailStatus == CourseDetailStatus.success;

  bool get isFailure => detailStatus == CourseDetailStatus.failure;

  bool get isEnrollSubmitting => enrollStatus == CourseEnrollStatus.submitting;

  bool get isEnrollSuccess => enrollStatus == CourseEnrollStatus.success;

  bool get isEnrollFailure => enrollStatus == CourseEnrollStatus.failure;

  @override
  List<Object?> get props => [
        detailStatus,
        enrollStatus,
        courseId,
        course,
        enrollment,
        errorMessage,
        enrollErrorMessage,
      ];
}
