import '../../domain/entities/enrollment.dart';
import '../models/enrollment_model.dart';

/// Mapper chuyển enrollment model từ data layer sang domain entity.
extension EnrollmentModelMapper on EnrollmentModel {
  Enrollment toDomain() {
    return Enrollment(
      id: id,
      courseId: courseId,
      userId: userId,
      enrolledAt: DateTime.tryParse(enrolledAt) ?? DateTime.now(),
      status: _mapStatus(status),
      completedAt: completedAt == null ? null : DateTime.tryParse(completedAt!),
    );
  }

  EnrollmentStatus _mapStatus(String value) {
    return switch (value) {
      'active' => EnrollmentStatus.active,
      'completed' => EnrollmentStatus.completed,
      'cancelled' => EnrollmentStatus.cancelled,
      _ => EnrollmentStatus.active,
    };
  }
}
