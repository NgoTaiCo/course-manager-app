import 'package:flutter/material.dart';
import '../course.dart';

/// Màn hình chi tiết khóa học — naive approach.
///
/// Nhận trực tiếp object [Course] qua constructor — không có
/// route argument, không có ID-based navigation. Nếu sau này muốn
/// deep link vào màn hình này từ notification thì cần refactor.
///
/// Sau M2, [Course] đã là domain entity, nhưng màn hình này vẫn dùng entity
/// trực tiếp. Đây là điểm cố ý giữ lại để các milestone sau thảo luận:
/// presentation nên nhận entity, view model, hay state từ BLoC?
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
            _buildStatsRow(theme),
            const SizedBox(height: 20),

            // Khu vực giá vẫn format trong UI, chưa tách presenter/formatter.
            _buildPriceSection(theme),
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
                    .map((tag) => Chip(
                          label: Text('#$tag'),
                          labelStyle: theme.textTheme.labelSmall,
                          padding: EdgeInsets.zero,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Nút đăng ký vẫn xử lý side effect bằng SnackBar ngay trong UI.
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: course.canEnroll
                    ? () {
                        // Logic enroll vẫn viết thẳng vào callback.
                        // M5 sẽ tách thành use case/state rõ ràng hơn.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đã đăng ký "${course.title}" thành công!'),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  switch (course.status) {
                    CourseStatus.published => 'Đăng ký ngay',
                    CourseStatus.draft => 'Chưa mở đăng ký',
                    CourseStatus.archived => 'Không còn hoạt động',
                  },
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

  const _StatItem({required this.icon, required this.label, this.color});

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
