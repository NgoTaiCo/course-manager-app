import '../../domain/entities/user_progress.dart';
import '../models/user_progress_model.dart';

/// Mapper chuyển progress model từ data layer sang domain entity.
extension UserProgressModelMapper on UserProgressModel {
  UserProgress toDomain() {
    return UserProgress(
      userId: userId,
      courseId: courseId,
      completedLessonIds: completedLessonIds,
      totalLessonCount: totalLessonCount,
      lastLessonId: lastLessonId,
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}
