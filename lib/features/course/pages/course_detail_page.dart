import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../course.dart';
import '../course_dependencies.dart';

/// Màn hình chi tiết khóa học.
///
/// Sau M5, màn hình này không nhận trực tiếp object `Course` nữa.
/// Nó nhận `courseId`, gửi event vào CourseDetailBloc, rồi render theo state.
///
/// Luồng hiện tại:
/// UI -> CourseDetailBloc -> GetCourseDetail/EnrollCourse -> Repository.
class CourseDetailPage extends StatelessWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          createCourseDetailBloc()..add(CourseDetailStarted(courseId)),
      child: const _CourseDetailView(),
    );
  }
}

class _CourseDetailView extends StatelessWidget {
  const _CourseDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseDetailBloc, CourseDetailState>(
      listenWhen: (previous, current) =>
          previous.enrollStatus != current.enrollStatus,
      listener: (context, state) {
        if (state.isEnrollSuccess) {
          final courseTitle = state.course?.title ?? 'khóa học';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã đăng ký "$courseTitle" thành công!')),
          );
        }

        if (state.isEnrollFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.enrollErrorMessage ??
                    'Không thể đăng ký khóa học. Vui lòng thử lại.',
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết khóa học'),
        ),
        body: BlocBuilder<CourseDetailBloc, CourseDetailState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isFailure || state.course == null) {
              return _CourseDetailError(
                message:
                    state.errorMessage ?? 'Không thể tải chi tiết khóa học.',
                onRetry: () {
                  context
                      .read<CourseDetailBloc>()
                      .add(const CourseDetailRetried());
                },
              );
            }

            return _CourseDetailContent(
              course: state.course!,
              state: state,
            );
          },
        ),
      ),
    );
  }
}

class _CourseDetailContent extends StatelessWidget {
  final Course course;
  final CourseDetailState state;

  const _CourseDetailContent({
    required this.course,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh đại diện tạm: chưa có image field hoặc media data thật.
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.play_circle_outline,
                size: 64,
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category + status vẫn được map trực tiếp trong UI.
          Row(
            children: [
              Chip(
                label: Text(course.categoryName),
                padding: EdgeInsets.zero,
                labelStyle: theme.textTheme.labelSmall,
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: course.status),
            ],
          ),
          const SizedBox(height: 8),

          // Tiêu đề khóa học.
          Text(
            course.title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Giảng viên phụ trách khóa học.
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16),
              const SizedBox(width: 4),
              Text(
                course.instructorName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Các chỉ số hiển thị lấy trực tiếp từ entity.
          _StatsRow(course: course),
          const SizedBox(height: 20),

          // Khu vực giá vẫn format trong UI, chưa tách presenter/formatter.
          _PriceSection(course: course),
          const SizedBox(height: 20),

          // Mô tả khóa học.
          Text(
            'Mô tả khóa học',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            course.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // Tags đang hiển thị trực tiếp từ List<String>.
          if (course.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: course.tags
                  .map(
                    (tag) => Chip(
                      label: Text('#$tag'),
                      labelStyle: theme.textTheme.labelSmall,
                      padding: EdgeInsets.zero,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          _EnrollButton(
            course: course,
            state: state,
          ),
        ],
      ),
    );
  }
}

class _EnrollButton extends StatelessWidget {
  final Course course;
  final CourseDetailState state;

  const _EnrollButton({
    required this.course,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isEnrolled = state.isEnrollSuccess;
    final isSubmitting = state.isEnrollSubmitting;
    final canPress = course.canEnroll && !isSubmitting && !isEnrolled;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: canPress
            ? () {
                context
                    .read<CourseDetailBloc>()
                    .add(const CourseEnrollPressed());
              }
            : null,
        child: isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(_enrollLabel(course, isEnrolled)),
      ),
    );
  }

  String _enrollLabel(Course course, bool isEnrolled) {
    if (isEnrolled) return 'Đã đăng ký';

    return switch (course.status) {
      CourseStatus.published => 'Đăng ký ngay',
      CourseStatus.draft => 'Chưa mở đăng ký',
      CourseStatus.archived => 'Không còn hoạt động',
    };
  }
}

class _StatsRow extends StatelessWidget {
  final Course course;

  const _StatsRow({required this.course});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(
          icon: Icons.star_rounded,
          label: course.rating > 0
              ? '${course.rating.toStringAsFixed(1)} (${course.reviewCount})'
              : 'Chưa có đánh giá',
          color: Colors.amber,
        ),
        const SizedBox(width: 16),
        _StatItem(
          icon: Icons.group_outlined,
          label: '${course.enrollmentCount} học viên',
        ),
        const SizedBox(width: 16),
        _StatItem(
          icon: Icons.access_time_rounded,
          label: course.durationFormatted,
        ),
        const SizedBox(width: 16),
        _StatItem(
          icon: Icons.menu_book_outlined,
          label: '${course.lessonCount} bài',
        ),
      ],
    );
  }
}

class _PriceSection extends StatelessWidget {
  final Course course;

  const _PriceSection({required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '${_formatPrice(course.price)}₫',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          if (course.discountPercent > 0) ...[
            Text(
              '${_formatPrice(course.originalPrice)}₫',
              style: theme.textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-${course.discountPercent.toInt()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

class _StatusBadge extends StatelessWidget {
  final CourseStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    // Mapping status sang màu/label vẫn nằm ở presentation.
    // Sau này có thể tách thành mapper hoặc extension nếu lặp lại nhiều nơi.
    final (color, label) = switch (status) {
      CourseStatus.published => (Colors.green, 'Đang mở'),
      CourseStatus.draft => (Colors.orange, 'Bản nháp'),
      CourseStatus.archived => (Colors.grey, 'Lưu trữ'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _StatItem({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Widget nhỏ phục vụ layout, chưa chứa business logic.
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.onSurfaceVariant;

    return Column(
      children: [
        Icon(icon, size: 18, color: c),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: c),
        ),
      ],
    );
  }
}

class _CourseDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CourseDetailError({
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
