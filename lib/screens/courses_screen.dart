import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';

/// Full CRUD screen for courses fetched from JSONPlaceholder API.
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch courses when the screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseController>().fetchCourses();
    });
  }

  // ── Add / Edit Dialog ──────────────────────────────────────────────────────
  void _showCourseDialog({CourseModel? course}) {
    final titleController =
        TextEditingController(text: course?.title ?? '');
    final bodyController =
        TextEditingController(text: course?.body ?? '');
    final formKey = GlobalKey<FormState>();
    final isEditing = course != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isEditing ? Icons.edit_note : Icons.add_circle_outline,
              color: Colors.indigo,
            ),
            const SizedBox(width: 8),
            Text(
              isEditing ? 'Edit Course' : 'Add New Course',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Course Title',
                    hintText: 'Enter course title',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: 1,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: bodyController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter course description',
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Description is required'
                          : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: Icon(isEditing ? Icons.save : Icons.add),
            label: Text(isEditing ? 'Save Changes' : 'Add Course'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);

              final controller = context.read<CourseController>();
              bool success;

              if (isEditing) {
                success = await controller.updateCourse(
                  id: course.id,
                  title: titleController.text.trim(),
                  body: bodyController.text.trim(),
                );
              } else {
                success = await controller.addCourse(
                  title: titleController.text.trim(),
                  body: bodyController.text.trim(),
                );
              }

              if (mounted) {
                _showSnackBar(
                  success
                      ? (isEditing
                          ? 'Course updated successfully!'
                          : 'Course added successfully!')
                      : (controller.errorMessage ?? 'Something went wrong'),
                  success ? Colors.green : Colors.red,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ── Delete Confirmation ────────────────────────────────────────────────────
  void _confirmDelete(CourseModel course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Course'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete\n"${course.title}"?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete'),
            onPressed: () async {
              Navigator.pop(ctx);
              final success =
                  await context.read<CourseController>().deleteCourse(course.id);
              if (mounted) {
                _showSnackBar(
                  success
                      ? 'Course deleted successfully!'
                      : (context.read<CourseController>().errorMessage ??
                          'Delete failed'),
                  success ? Colors.green : Colors.red,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          'Courses (API)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => context.read<CourseController>().fetchCourses(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCourseDialog(),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
      ),
      body: Consumer<CourseController>(
        builder: (context, controller, _) {
          // ── Loading ────────────────────────────────────────────────────────
          if (controller.isLoading && controller.courses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.indigo),
                  SizedBox(height: 16),
                  Text(
                    'Fetching courses from API...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // ── Error ──────────────────────────────────────────────────────────
          if (controller.errorMessage != null && controller.courses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to Load Courses',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchCourses(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── Course List ────────────────────────────────────────────────────
          return RefreshIndicator(
            color: Colors.indigo,
            onRefresh: () => controller.fetchCourses(),
            child: Column(
              children: [
                // API info banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  color: Colors.indigo.withOpacity(0.08),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_done,
                          color: Colors.indigo, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Data from JSONPlaceholder API  •  ${controller.courses.length} courses loaded',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.indigo),
                        ),
                      ),
                      if (controller.isLoading)
                        const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.indigo),
                        ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: controller.courses.length,
                    itemBuilder: (context, index) {
                      final course = controller.courses[index];
                      return _CourseCard(
                        course: course,
                        onEdit: () => _showCourseDialog(course: course),
                        onDelete: () => _confirmDelete(course),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Course Card Widget ─────────────────────────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CourseCard({
    required this.course,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${course.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Title
                Expanded(
                  child: Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              course.body,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
