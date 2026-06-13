import 'package:equatable/equatable.dart';

import '../../domain/entities/course.dart';

/// Các trạng thái chính của Course List.
///
/// Dùng enum để học viên nhìn rõ state machine:
/// initial -> loading -> success/empty/failure.
enum CourseListStatus {
  initial,
  loading,
  success,
  empty,
  failure,
}

/// State duy nhất của CourseListBloc.
///
/// M4 chưa dùng freezed để giữ bài học nhỏ. Các milestone sau có thể so sánh
/// cách này với union state nếu muốn dạy sâu hơn.
class CourseListState extends Equatable {
  final CourseListStatus status;
  final List<Course> courses;
  final CourseStatus? selectedStatus;
  final String? errorMessage;

  const CourseListState({
    required this.status,
    required this.courses,
    required this.selectedStatus,
    required this.errorMessage,
  });

  const CourseListState.initial()
      : status = CourseListStatus.initial,
        courses = const [],
        selectedStatus = null,
        errorMessage = null;

  const CourseListState.loading({
    CourseStatus? selectedStatus,
    List<Course> courses = const [],
  }) : this(
          status: CourseListStatus.loading,
          courses: courses,
          selectedStatus: selectedStatus,
          errorMessage: null,
        );

  const CourseListState.success({
    required List<Course> courses,
    required CourseStatus? selectedStatus,
  }) : this(
          status: CourseListStatus.success,
          courses: courses,
          selectedStatus: selectedStatus,
          errorMessage: null,
        );

  const CourseListState.empty({
    required List<Course> courses,
    required CourseStatus? selectedStatus,
  }) : this(
          status: CourseListStatus.empty,
          courses: courses,
          selectedStatus: selectedStatus,
          errorMessage: null,
        );

  const CourseListState.failure({
    required String message,
    required CourseStatus? selectedStatus,
    List<Course> courses = const [],
  }) : this(
          status: CourseListStatus.failure,
          courses: courses,
          selectedStatus: selectedStatus,
          errorMessage: message,
        );

  /// Danh sách sau khi áp dụng filter.
  ///
  /// BLoC giữ logic filter để Widget chỉ render state.
  List<Course> get visibleCourses {
    if (selectedStatus == null) return courses;
    return courses.where((course) => course.status == selectedStatus).toList();
  }

  bool get isInitial => status == CourseListStatus.initial;

  bool get isLoading => status == CourseListStatus.loading;

  bool get isSuccess => status == CourseListStatus.success;

  bool get isEmpty => status == CourseListStatus.empty;

  bool get isFailure => status == CourseListStatus.failure;

  @override
  List<Object?> get props => [
        status,
        courses,
        selectedStatus,
        errorMessage,
      ];
}
