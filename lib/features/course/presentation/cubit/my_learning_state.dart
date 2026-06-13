import 'package:equatable/equatable.dart';

import '../../domain/entities/my_learning_course.dart';

/// Trạng thái tổng thể của màn hình My Learning.
enum MyLearningStatus {
  initial,
  loading,
  success,
  empty,
  failure,
}

/// State của MyLearningCubit.
class MyLearningState extends Equatable {
  final MyLearningStatus status;
  final List<MyLearningCourse> courses;
  final String? updatingCourseId;
  final String? errorMessage;

  const MyLearningState({
    required this.status,
    required this.courses,
    required this.updatingCourseId,
    required this.errorMessage,
  });

  const MyLearningState.initial()
      : status = MyLearningStatus.initial,
        courses = const [],
        updatingCourseId = null,
        errorMessage = null;

  MyLearningState copyWith({
    MyLearningStatus? status,
    List<MyLearningCourse>? courses,
    String? updatingCourseId,
    String? errorMessage,
    bool clearUpdatingCourseId = false,
    bool clearErrorMessage = false,
  }) {
    return MyLearningState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      updatingCourseId: clearUpdatingCourseId
          ? null
          : updatingCourseId ?? this.updatingCourseId,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  bool get isInitial => status == MyLearningStatus.initial;

  bool get isLoading => status == MyLearningStatus.loading;

  bool get isSuccess => status == MyLearningStatus.success;

  bool get isEmpty => status == MyLearningStatus.empty;

  bool get isFailure => status == MyLearningStatus.failure;

  @override
  List<Object?> get props => [
        status,
        courses,
        updatingCourseId,
        errorMessage,
      ];
}
