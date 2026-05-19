import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/subject_model.dart';
import 'login_screen.dart';
import 'detail_screen.dart';
import 'courses_screen.dart';

class DashboardScreen extends StatelessWidget {
  final UserModel user;

  const DashboardScreen({super.key, required this.user});

  List<SubjectModel> get _subjects => [
        SubjectModel(
          name: 'Mobile Application Development',
          description:
              'Focuses on designing and developing mobile applications using modern frameworks and tools. '
              'Covers UI design, app architecture, and deployment for real-world mobile platforms.',
          classDay: 'Saturday',
          schedule: 'Slot 4–6 (10:30 – 12:30)',
          instructor: 'Ms. Roshana Mughal (VF)',
          location: 'CyS-Lab',
          imageUrl: 'mobile_dev',
        ),
        SubjectModel(
          name: 'Software Re-Engineering',
          description:
              'Explores techniques for analyzing, improving, and transforming existing software systems. '
              'Emphasizes reverse engineering, code refactoring, and system modernization.',
          classDay: 'Saturday',
          schedule: 'Slot 2–4 (08:30 – 10:30)',
          instructor: 'Mr. Conrad D\'Silva / Ms. Naureen Anwar (VF)',
          location: 'SF-239',
          imageUrl: 'software_re',
        ),
        SubjectModel(
          name: 'Management Information Systems (MIS)',
          description:
              'Introduces the role of information systems in supporting business operations and decision-making. '
              'Covers data management, enterprise systems, and strategic use of IT in organizations.',
          classDay: 'Saturday',
          schedule: 'Slot 7–9 (13:10 – 15:10)',
          instructor: 'Mr. Muhammad Ahmed Qaiser (VF)',
          location: 'SF-240',
          imageUrl: 'mis',
        ),
        SubjectModel(
          name: 'UI/UX Design & Development',
          description:
              'Focuses on designing intuitive and user-friendly interfaces for digital products. '
              'Covers user research, prototyping, usability testing, and front-end implementation.',
          classDay: 'Wednesday',
          schedule: 'Slot 8–9',
          instructor: 'Dr. Raazia Sosan Waseem',
          location: 'adv-AI Lab',
          imageUrl: 'uiux',
        ),
        SubjectModel(
          name: 'FYP-II (AutoTestGen+)',
          description:
              'AutoTestGen+ is an AI-powered assistant that automates test case generation, requirement extraction, '
              'and documentation across the SDLC. It enhances software quality and productivity through intelligent '
              'automation and real-time insights.',
          classDay: 'Wednesday',
          schedule: 'Slot 10–11 (14:30 – 15:50)',
          instructor: 'Mam Soohan Abbasi',
          location: 'SF-224',
          imageUrl: 'fyp',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.indigo,
                      child: Text(
                        user.fullName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── API Courses Banner ──────────────────────────────────────────
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CoursesScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3949AB), Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cloud_download, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'API Courses (CRUD)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Fetch, Add, Edit & Delete via JSONPlaceholder',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'My Subjects',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Subject List
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.withOpacity(0.1),
                        child: Icon(
                          _getSubjectIcon(subject.imageUrl),
                          color: Colors.indigo,
                        ),
                      ),
                      title: Text(
                        subject.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${subject.classDay} • ${subject.schedule}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(subject: subject),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String imageUrl) {
    switch (imageUrl) {
      case 'mobile_dev':
        return Icons.phone_android;
      case 'software_re':
        return Icons.settings_suggest;
      case 'mis':
        return Icons.analytics;
      case 'uiux':
        return Icons.design_services;
      case 'fyp':
        return Icons.smart_toy;
      default:
        return Icons.book;
    }
  }
}