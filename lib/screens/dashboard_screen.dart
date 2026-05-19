import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/subject_model.dart';
import 'login_screen.dart';
import 'detail_screen.dart';
import 'courses_screen.dart';

// ── Syncora Design Tokens ─────────────────────────────────────────────────────
const _purple1  = Color(0xFF6C63FF);
const _purple2  = Color(0xFF3D2C8D);
const _purple3  = Color(0xFF4A00E0);
const _bgDark   = Color(0xFF0F0C29);
const _bgMid    = Color(0xFF1A1340);
const _cardBg   = Color(0xFF231B54);
const _accentCyan = Color(0xFF43E8D8);
const _accentPink = Color(0xFFFF6584);

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
          instructor: "Mr. Conrad D'Silva / Ms. Naureen Anwar (VF)",
          location: 'SF-239',
          imageUrl: 'software_re',
        ),
        SubjectModel(
          name: 'Management Information Systems (MIS)',
          description:
              'Introduces the role of information systems in supporting business operations and decision-making. '
              'Covers data management, enterprise systems, and strategic use of IT.',
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
              'AutoTestGen+ is an AI-powered assistant that automates test case generation, '
              'requirement extraction, and documentation across the SDLC.',
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
      backgroundColor: _bgDark,
      body: CustomScrollView(
        slivers: [
          // ── Gradient App Bar ───────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _purple2,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(
                onTap: () => _confirmLogout(context),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_purple3, _purple2, _bgDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [_purple1, Color(0xFF8E2DE2)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _purple1.withOpacity(0.5),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  user.fullName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, ${user.fullName.split(' ').first}! 👋',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _accentCyan.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: _accentCyan.withOpacity(0.35)),
                          ),
                          child: const Text(
                            '5 Enrolled Subjects',
                            style: TextStyle(
                              color: _accentCyan,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body Content ────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── API Courses Banner ──────────────────────────────────────
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CoursesScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: _purple1.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.cloud_sync_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'API Courses (CRUD)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Fetch, Add, Edit & Delete via JSONPlaceholder',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.white60, size: 16),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── My Subjects heading ─────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_purple1, _accentCyan],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'My Subjects',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Subject Cards ───────────────────────────────────────────
                ..._subjects.asMap().entries.map((e) =>
                    _SubjectCard(
                      subject: e.value,
                      index: e.key,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailScreen(subject: e.value)),
                      ),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: _accentPink.withOpacity(0.2),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _accentPink.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded,
                    color: _accentPink, size: 32),
              ),
              const SizedBox(height: 14),
              const Text('Log Out',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white54,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Log Out',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Subject Card ──────────────────────────────────────────────────────────────
class _SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final int index;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subject,
    required this.index,
    required this.onTap,
  });

  static const _gradients = [
    [Color(0xFF6C63FF), Color(0xFF3D2C8D)],
    [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
    [Color(0xFF43E8D8), Color(0xFF4A00E0)],
    [Color(0xFFFF6584), Color(0xFF6C63FF)],
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
  ];

  static const _icons = {
    'mobile_dev': Icons.phone_android_rounded,
    'software_re': Icons.settings_suggest_rounded,
    'mis': Icons.analytics_rounded,
    'uiux': Icons.design_services_rounded,
    'fyp': Icons.smart_toy_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final gradient = _gradients[index % _gradients.length];
    final icon = _icons[subject.imageUrl] ?? Icons.book_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          title: Text(
            subject.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${subject.classDay}  •  ${subject.schedule}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: gradient[0].withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: gradient[0]),
          ),
        ),
      ),
    );
  }
}