import 'package:flutter/material.dart';
import '../features/course/pages/course_list_page.dart';

/// Entry point của ứng dụng.
///
/// Milestone 0: App chạy được với màn hình Course List tạm.
/// DI chưa có gì — sẽ thêm khi cần (Milestone/Module sau).
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: const CourseListPage(),
    );
  }
}
