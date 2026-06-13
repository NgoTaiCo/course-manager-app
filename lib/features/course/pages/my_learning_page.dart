import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../course.dart';
import '../course_dependencies.dart';
import 'course_detail_page.dart';

/// Màn hình "Khóa học của tôi".
///
/// M6 dùng Cubit để quản lý load danh sách khóa học đang học và cập nhật
/// progress local mock. Cubit phù hợp vì flow hiện tại là command đơn giản,
/// chưa cần nhiều event riêng như CourseListBloc/CourseDetailBloc.
class MyLearningPage extends StatelessWidget {
  const MyLearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => createMyLearningCubit()..loadMyCourses(),
      child: const _MyLearningView(),
    );
  }
}

class _MyLearningView extends StatelessWidget {
  const _MyLearningView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyLearningCubit, MyLearningState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khóa học của tôi'),
        ),
        body: BlocBuilder<MyLearningCubit, MyLearningState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isFailure) {
              return _MyLearningError(
                message:
                    state.errorMessage ?? 'Không thể tải khóa học của tôi.',
                onRetry: () => context.read<MyLearningCubit>().loadMyCourses(),
              );
            }

            if (state.isEmpty) {
              return const Center(
                child: Text('Bạn chưa đăng ký khóa học nào.'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = state.courses[index];
                return _MyLearningCard(
                  item: item,
                  isUpdating: state.updatingCourseId == item.course.id,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _MyLearningCard extends StatelessWidget {
  final MyLearningCourse item;
  final bool isUpdating;

  const _MyLearningCard({
    required this.item,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final course = item.course;
    final progress = item.progress;
    final percent = (progress.progressRatio * 100).round();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailPage(courseId: course.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                course.instructorName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progress.progressRatio),
              const SizedBox(height: 8),
              Text(
                '$percent% hoàn thành • ${progress.completedLessonCount}/${progress.totalLessonCount} bài',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: progress.isCompleted || isUpdating
                      ? null
                      : () {
                          context
                              .read<MyLearningCubit>()
                              .completeNextLesson(item);
                        },
                  child: isUpdating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          progress.isCompleted
                              ? 'Đã hoàn thành khóa học'
                              : 'Hoàn thành bài tiếp theo',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyLearningError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MyLearningError({
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
