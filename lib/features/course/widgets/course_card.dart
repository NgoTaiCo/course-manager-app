import 'package:flutter/material.dart';
import '../course.dart';

/// Widget hiển thị một khóa học dạng card — naive approach.
///
/// Logic hiển thị status vẫn đang nằm trực tiếp trong Widget.
/// M2 đã có enum/domain entity, nhưng presentation mapping sẽ còn refactor tiếp.
///
/// Điểm cần quan sát:
/// - Card nhận trực tiếp [Course].
/// - Format giá và label level vẫn nằm trong Widget.
/// - Khi nhiều màn hình cần format giống nhau, code này sẽ bắt đầu lặp.
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trạng thái + danh mục: UI tự quyết định cách hiển thị status.
              Row(
                children: [
                  _StatusChip(status: course.status),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      course.categoryName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Tiêu đề khóa học.
              Text(
                course.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Tên giảng viên.
              Text(
                course.instructorName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),

              // Metadata cơ bản: rating, thời lượng, level.
              Row(
                children: [
                  if (course.rating > 0) ...[
                    const Icon(Icons.star_rounded,
                        size: 14, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      course.rating.toStringAsFixed(1),
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(width: 12),
                  ],
                  const Icon(Icons.access_time_rounded,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 2),
                  Text(
                    course.durationFormatted,
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.signal_cellular_alt_rounded,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 2),
                  Text(
                    _levelLabel(course.level),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Giá và giảm giá vẫn format trực tiếp trong Widget.
              Row(
                children: [
                  Text(
                    '${_formatPrice(course.price)}₫',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (course.discountPercent > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${_formatPrice(course.originalPrice)}₫',
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '-${course.discountPercent.toInt()}%',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _levelLabel(CourseLevel level) {
    // Ánh xạ enum sang label tiếng Việt đang nằm ở presentation.
    // Nếu nhiều nơi cần dùng, nên tách để tránh lặp.
    return switch (level) {
      CourseLevel.beginner => 'Cơ bản',
      CourseLevel.intermediate => 'Trung cấp',
      CourseLevel.advanced => 'Nâng cao',
    };
  }

  String _formatPrice(double price) {
    // Bộ định dạng tạm cho M2. Sau này có thể tách thành helper/presenter.
    return price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

class _StatusChip extends StatelessWidget {
  final CourseStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    // Logic presentation: map trạng thái domain sang màu và label hiển thị.
    // Milestone sau có thể đưa logic này ra mapper nếu bị lặp.
    final (color, label) = switch (status) {
      CourseStatus.published => (Colors.green, 'Đang mở'),
      CourseStatus.draft => (Colors.orange, 'Bản nháp'),
      CourseStatus.archived => (Colors.grey, 'Lưu trữ'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
