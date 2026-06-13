import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../course.dart';
import '../course_dependencies.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

/// Màn hình danh sách khóa học.
///
/// Sau M4, Widget không gọi data source hoặc use case trực tiếp nữa.
/// UI chỉ gửi event vào `CourseListBloc` và render theo `CourseListState`.
///
/// Luồng hiện tại:
/// UI event -> CourseListBloc -> GetCourses -> CourseRepository -> DataSource.
///
/// Điểm còn để dành cho các milestone sau:
/// - Dependency đang được lắp thủ công trong `course_dependencies.dart`.
/// - Search/pagination chưa làm.
/// - Detail/enrollment chưa có BLoC riêng.
class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => createCourseListBloc()..add(const CourseListStarted()),
      child: const _CourseListView(),
    );
  }
}

class _CourseListView extends StatelessWidget {
  const _CourseListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Thêm search ở milestone/bài tập sau.
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          _CourseStatusFilters(),
          Expanded(child: _CourseListBody()),
        ],
      ),
    );
  }
}

class _CourseStatusFilters extends StatelessWidget {
  const _CourseStatusFilters();

  @override
  Widget build(BuildContext context) {
    final filters = [
      (null, 'Tất cả'),
      (CourseStatus.published, 'Đang mở'),
      (CourseStatus.draft, 'Bản nháp'),
      (CourseStatus.archived, 'Lưu trữ'),
    ];

    return BlocBuilder<CourseListBloc, CourseListState>(
      buildWhen: (previous, current) =>
          previous.selectedStatus != current.selectedStatus,
      builder: (context, state) {
        return SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: filters.map((filter) {
              final (value, label) = filter;
              final isSelected = state.selectedStatus == value;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) {
                    context.read<CourseListBloc>().add(
                          CourseListStatusFilterChanged(value),
                        );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _CourseListBody extends StatelessWidget {
  const _CourseListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseListBloc, CourseListState>(
      builder: (context, state) {
        if (state.isInitial || state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFailure) {
          return _CourseListError(
            message: state.errorMessage ?? 'Không thể tải danh sách khóa học.',
            onRetry: () {
              context.read<CourseListBloc>().add(const CourseListRetried());
            },
          );
        }

        if (state.isEmpty) {
          return const Center(
            child: Text('Không có khóa học nào.'),
          );
        }

        final courses = state.visibleCourses;

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: courses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              course: course,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailPage(courseId: course.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CourseListError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CourseListError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 40,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
