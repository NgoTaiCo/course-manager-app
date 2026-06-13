import 'package:flutter/material.dart';
import '../course.dart';
import '../course_data.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

/// Màn hình danh sách khóa học — naive approach.
///
/// Những vấn đề sẽ thấy rõ khi mở rộng:
/// 1. Logic lọc ([_selectedStatus]) nằm thẳng trong Widget.
/// 2. [allCourses] được truy cập trực tiếp — đổi sang API thì phải sửa
///    file này.
/// 3. Không có loading state, không có error state.
/// 4. Khi thêm search, favorite, pagination — Widget này sẽ phình to.
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  // Filter state nằm thẳng trong Widget
  String? _selectedStatus; // null = Tất cả

  List<Course> get _filteredCourses {
    // Logic lọc viết thẳng trong Widget
    if (_selectedStatus == null) return allCourses;
    return allCourses.where((c) => c.status == _selectedStatus).toList();
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
      ('published', 'Đang mở'),
      ('draft', 'Bản nháp'),
      ('archived', 'Lưu trữ'),
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
    final courses = _filteredCourses;

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
  }
}
