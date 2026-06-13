import 'package:flutter/material.dart';
import '../course.dart';

/// Màn hình chi tiết khóa học — naive approach.
///
/// Nhận trực tiếp object [Course] qua constructor — không có
/// route argument, không có ID-based navigation. Nếu sau này muốn
/// deep link vào màn hình này từ notification thì cần refactor.
class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết khóa học'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
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

            // Category + Status
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

            // Title
            Text(
              course.title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Instructor
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

            // Stats row
            _buildStatsRow(theme),
            const SizedBox(height: 20),

            // Price section
            _buildPriceSection(theme),
            const SizedBox(height: 20),

            // Description
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

            // Tags
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
                    .map((tag) => Chip(
                          label: Text('#$tag'),
                          labelStyle: theme.textTheme.labelSmall,
                          padding: EdgeInsets.zero,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Enroll button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: course.status == 'published'
                    ? () {
                        // logic enroll viết thẳng vào callback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đã đăng ký "${course.title}" thành công!'),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  course.status == 'published'
                      ? 'Đăng ký ngay'
                      : course.status == 'draft'
                          ? 'Chưa mở đăng ký'
                          : 'Không còn hoạt động',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
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

  Widget _buildPriceSection(ThemeData theme) {
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
                    color: Colors.white, fontWeight: FontWeight.bold),
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
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (status == 'published') {
      color = Colors.green;
      label = 'Đang mở';
    } else if (status == 'draft') {
      color = Colors.orange;
      label = 'Bản nháp';
    } else {
      color = Colors.grey;
      label = 'Lưu trữ';
    }

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

  const _StatItem({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
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
