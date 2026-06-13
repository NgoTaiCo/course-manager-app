import 'package:flutter/material.dart';
import '../course.dart';

/// Widget hiển thị một khóa học dạng card — naive approach.
///
/// Logic hiển thị status đang nằm trực tiếp trong Widget bằng if/else,
/// dùng String thay vì enum → dễ lỗi nếu typo.
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
              // Status + Category
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

              // Title
              Text(
                course.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Instructor
              Text(
                course.instructorName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),

              // Meta: rating, duration, level
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

              // Price
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

  String _levelLabel(String level) {
    if (level == 'beginner') return 'Cơ bản';
    if (level == 'intermediate') return 'Trung cấp';
    if (level == 'advanced') return 'Nâng cao';
    return level;
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    // Naive: so sánh String thủ công — dễ lỗi nếu typo
    final Color color;
    final String label;

    if (status == 'published') {
      color = Colors.green;
      label = 'Đang mở';
    } else if (status == 'draft') {
      color = Colors.orange;
      label = 'Bản nháp';
    } else if (status == 'archived') {
      color = Colors.grey;
      label = 'Lưu trữ';
    } else {
      color = Colors.grey;
      label = status;
    }

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
