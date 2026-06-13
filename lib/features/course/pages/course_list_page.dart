import 'package:flutter/material.dart';
import '../course.dart';
import '../data/datasources/mock_course_data_source.dart';
import '../data/repositories/mock_course_repository.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

/// Màn hình danh sách khóa học.
///
/// Sau M3, màn hình này không đọc static list trực tiếp nữa.
/// Luồng hiện tại:
/// UI -> GetCourses -> CourseRepository -> MockCourseDataSource.
///
/// Vẫn còn điểm cố ý chưa hoàn thiện:
/// - UI tự tạo dependency, chưa có DI.
/// - UI dùng FutureBuilder, chưa có BLoC event/state.
/// - Logic filter vẫn nằm trong Widget.
///
/// M4 sẽ thay FutureBuilder bằng CourseListBloc để biểu diễn
/// loading/success/empty/failure rõ ràng hơn.
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final GetCourses _getCourses = const GetCourses(
    MockCourseRepository(
      MockCourseDataSource(
        // Đổi thành true để demo lỗi loading/failure trước khi sang BLoC.
        shouldFail: false,
      ),
    ),
  );

  // Filter state nằm thẳng trong Widget
  CourseStatus? _selectedStatus; // null = Tất cả
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _getCourses();
  }

  List<Course> _filterCourses(List<Course> courses) {
    // Logic lọc viết thẳng trong Widget
    if (_selectedStatus == null) return courses;
    return courses.where((c) => c.status == _selectedStatus).toList();
  }

  void _reloadCourses() {
    setState(() {
      _coursesFuture = _getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Thêm search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildCourseList()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      (null, 'Tất cả'),
      (CourseStatus.published, 'Đang mở'),
      (CourseStatus.draft, 'Bản nháp'),
      (CourseStatus.archived, 'Lưu trữ'),
    ];

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: filters.map((filter) {
          final (value, label) = filter;
          final isSelected = _selectedStatus == value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedStatus = value),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCourseList() {
    return FutureBuilder<List<Course>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _CourseListError(
            message: 'Không thể tải danh sách khóa học.',
            onRetry: _reloadCourses,
          );
        }

        final courses = _filterCourses(snapshot.data ?? const []);

        if (courses.isEmpty) {
          return const Center(
            child: Text('Không có khóa học nào.'),
          );
        }

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
                  builder: (_) => CourseDetailPage(course: course),
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
