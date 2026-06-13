import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/course.dart';
import '../../domain/usecases/get_courses.dart';
import 'course_list_event.dart';
import 'course_list_state.dart';

/// BLoC quản lý màn hình danh sách khóa học.
///
/// Trách nhiệm:
/// - nhận event từ UI;
/// - gọi use case;
/// - phát ra state loading/success/empty/failure;
/// - giữ logic filter theo trạng thái khóa học.
///
/// BLoC không biết data source là mock, API hay database.
class CourseListBloc extends Bloc<CourseListEvent, CourseListState> {
  final GetCourses _getCourses;

  CourseListBloc({
    required GetCourses getCourses,
  })  : _getCourses = getCourses,
        super(const CourseListState.initial()) {
    on<CourseListStarted>(_onStarted);
    on<CourseListRetried>(_onRetried);
    on<CourseListStatusFilterChanged>(_onStatusFilterChanged);
  }

  Future<void> _onStarted(
    CourseListStarted event,
    Emitter<CourseListState> emit,
  ) async {
    await _loadCourses(emit);
  }

  Future<void> _onRetried(
    CourseListRetried event,
    Emitter<CourseListState> emit,
  ) async {
    await _loadCourses(emit);
  }

  void _onStatusFilterChanged(
    CourseListStatusFilterChanged event,
    Emitter<CourseListState> emit,
  ) {
    _emitCourses(
      emit: emit,
      courses: state.courses,
      selectedStatus: event.status,
    );
  }

  Future<void> _loadCourses(Emitter<CourseListState> emit) async {
    emit(
      CourseListState.loading(
        selectedStatus: state.selectedStatus,
        courses: state.courses,
      ),
    );

    try {
      final courses = await _getCourses();
      _emitCourses(
        emit: emit,
        courses: courses,
        selectedStatus: state.selectedStatus,
      );
    } catch (_) {
      emit(
        CourseListState.failure(
          message: 'Không thể tải danh sách khóa học.',
          selectedStatus: state.selectedStatus,
          courses: state.courses,
        ),
      );
    }
  }

  void _emitCourses({
    required Emitter<CourseListState> emit,
    required List<Course> courses,
    required CourseStatus? selectedStatus,
  }) {
    final visibleCourses = selectedStatus == null
        ? courses
        : courses.where((course) => course.status == selectedStatus).toList();

    if (visibleCourses.isEmpty) {
      emit(
        CourseListState.empty(
          courses: courses,
          selectedStatus: selectedStatus,
        ),
      );
      return;
    }

    emit(
      CourseListState.success(
        courses: courses,
        selectedStatus: selectedStatus,
      ),
    );
  }
}
