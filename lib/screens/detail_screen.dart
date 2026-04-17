// lib/screens/detail_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../enums/app_enums.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final subject = args['subject'] as Subject;
    final color = args['color'] as Color;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar / Banner ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            backgroundColor: color,
            foregroundColor: Colors.white,
            actions: [
              Consumer<AuthController>(
                builder: (context, auth, _) {
                  final isBookmarked = auth.bookmarkedCourses.contains(subject.code);
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isBookmarked ? Colors.redAccent : Colors.white,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      auth.toggleBookmark(subject.code);
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient banner
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.9),
                          color.withBlue(
                              (color.blue + 60).clamp(0, 255).toInt()),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Pattern overlay
                  CustomPaint(painter: _BannerPatternPainter(color: color)),
                  // Course Info
                  SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _iconForSubject(subject),
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              subject.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  subject.code,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${subject.credits} Credit Hours',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body Content ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Option 4: Live Countdown Timer ───────────────────
                  _LiveCountdownTimer(color: color, subject: subject),
                  const SizedBox(height: 24),

                  // ── Interactive Navigation Tabs ──────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTab('Overview', 0, color),
                      _buildTab('Assignments', 1, color),
                      _buildTab('Schedule', 2, color),
                      _buildTab('Instructor', 3, color),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Dynamic Body Based on Selected Tab ────────────────
                  if (_selectedIndex == 0) ...[
                    _SectionCard(
                      icon: Icons.info_outline_rounded,
                      title: 'ABOUT',
                      color: color,
                      child: Text(
                        subject.description,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.6, color: Colors.grey.shade500),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _AnalyticsRings(color: color),
                    const SizedBox(height: 24),
                    _SectionCard(
                      icon: Icons.bar_chart_rounded,
                      title: 'COURSE PROGRESS',
                      color: color,
                      child: Column(
                        children: [
                          _buildProgressRow('Week 6 of 15', '40%', 0.4, color),
                          const SizedBox(height: 16),
                          _buildProgressRow('Lectures completed', '18 / 45', 0.4, color),
                          const SizedBox(height: 16),
                          _buildProgressRow('Labs submitted', '5 / 12', 0.41, color),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_selectedIndex == 1) ...[
                    _SectionCard(
                      icon: Icons.assignment_rounded,
                      title: 'ASSIGNMENTS',
                      color: color,
                      child: Column(
                        children: _fetchAssignmentsForSubject(subject).asMap().entries.map((entry) {
                          final idx = entry.key;
                          final data = entry.value;
                          final title = data['title'] as String;
                          final due = data['due'] as DateTime;
                          return Column(
                            children: [
                              _buildAssignmentRow(title, due, color),
                              if (idx != 2) const Divider(height: 16),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_selectedIndex == 2) ...[
                    _SectionCard(
                      icon: Icons.calendar_month_rounded,
                      title: 'SCHEDULE DETAILS',
                      color: color,
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.access_time_rounded,
                            label: 'Class Timings',
                            value: subject.schedule,
                            color: color,
                          ),
                          const Divider(height: 24),
                          _InfoRow(
                            icon: Icons.room_rounded,
                            label: 'Room',
                            value: subject.room,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_selectedIndex == 3) ...[
                    _SectionCard(
                      icon: Icons.person_rounded,
                      title: 'INSTRUCTOR',
                      color: color,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: color.withOpacity(0.2),
                            child: Icon(Icons.person, color: color, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.instructor,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subject.email,
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                          ),
                        ),
                        Icon(Icons.mail_outline_rounded, color: color.withOpacity(0.6)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildTab(String label, int index, Color color) {
    final active = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent, // Ensures the entire bounding box is tappable
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? color : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 3,
              width: active ? 40 : 0,
              decoration: BoxDecoration(
                color: active ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String title, String trailing, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
            Text(trailing, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.1),
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  Widget _buildAssignmentRow(String title, DateTime dueDate, Color color) {
    final isCompleted = DateTime.now().isAfter(dueDate);
    final monthShort = const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][dueDate.month - 1];
    final subtitle = 'Due: $monthShort ${dueDate.day}';

    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
          color: isCompleted ? Colors.green : Colors.orangeAccent,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _iconForSubject(Subject s) {
    switch (s) {
      case Subject.mobileAppDevelopment:
        return Icons.phone_android_rounded;
      case Subject.softwareReengineering:
        return Icons.settings_suggest_rounded;
      case Subject.mis:
        return Icons.bar_chart_rounded;
      case Subject.uiUxDesign:
        return Icons.design_services_rounded;
      case Subject.fypII:
        return Icons.rocket_launch_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  List<Map<String, dynamic>> _fetchAssignmentsForSubject(Subject s) {
    // Generate functional dates relative to CPU time for live UI testing behaviors
    final past = DateTime.now().subtract(const Duration(days: 3));
    final future1 = DateTime.now().add(const Duration(days: 2));
    final future2 = DateTime.now().add(const Duration(days: 7));

    switch (s) {
      case Subject.mobileAppDevelopment:
        return [
          {'title': 'Flutter Layouts Lab', 'due': past},
          {'title': 'State Management Quiz', 'due': future1},
          {'title': 'Final API Integration', 'due': future2},
        ];
      case Subject.softwareReengineering:
        return [
          {'title': 'Abstract Syntax Tree Lab', 'due': past},
          {'title': 'Pattern Analysis Report', 'due': future1},
          {'title': 'Refactoring Algorithm Exam', 'due': future2},
        ];
      case Subject.mis:
        return [
          {'title': 'Enterprise Resource Planning DB', 'due': past},
          {'title': 'Big Data Case Analysis', 'due': future1},
          {'title': 'Database Security Defense Lab', 'due': future2},
        ];
      case Subject.uiUxDesign:
        return [
          {'title': 'Figma Base Prototypes', 'due': past},
          {'title': 'Usability Testing Feedback Report', 'due': future1},
          {'title': 'Design System Delivery Mockups', 'due': future2},
        ];
      case Subject.fypII:
        return [
          {'title': 'Thesis First Draft', 'due': past},
          {'title': 'Backend Data Deployment', 'due': future1},
          {'title': 'Final Project Defense Presentation', 'due': future2},
        ];
    }
  }
}

// ── Section Card ───────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ── Info Row ───────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Banner Pattern Painter ─────────────────────────────────────────────────────
class _BannerPatternPainter extends CustomPainter {
  final Color color;
  const _BannerPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(size.width * (i * 0.2), size.height * 0.3),
        40.0 + i * 12,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Live Ticking Countdown Timer ─────────────────────────────────────────────
class _LiveCountdownTimer extends StatefulWidget {
  final Color color;
  final Subject subject;
  const _LiveCountdownTimer({required this.color, required this.subject});

  @override
  State<_LiveCountdownTimer> createState() => _LiveCountdownTimerState();
}

class _LiveCountdownTimerState extends State<_LiveCountdownTimer> {
  late Timer _timer;
  Duration _timeLeft = const Duration();
  late DateTime _targetTime;

  @override
  void initState() {
    super.initState();
    _targetTime = _parseScheduleTime(widget.subject.schedule);
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeLeft();
    });
  }

  DateTime _parseScheduleTime(String schedule) {
    final timeRegex = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)');
    final timeMatch = timeRegex.firstMatch(schedule);
    
    if (timeMatch != null) {
      int hour = int.parse(timeMatch.group(1)!);
      int minute = int.parse(timeMatch.group(2)!);
      String period = timeMatch.group(3)!;

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final now = DateTime.now();
      var target = DateTime(now.year, now.month, now.day, hour, minute);

      // --- Advanced Day Offset Algorithm ---
      // Identify strictly which exact days the class natively occurs. 
      final Map<String, int> dayMap = {'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4, 'Fri': 5, 'Sat': 6, 'Sun': 7};
      List<int> classDays = [];
      dayMap.forEach((dayStr, dayInt) {
        if (schedule.contains(dayStr)) {
          classDays.add(dayInt);
        }
      });

      if (classDays.isNotEmpty) {
        classDays.sort();
        int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
        int targetWeekday = -1;

        // Parse absolute chronological distance checking target offset vectors
        for (int day in classDays) {
          if (day > currentWeekday || (day == currentWeekday && now.isBefore(target))) {
            targetWeekday = day;
            break;
          }
        }
        
        // Wrap back to beginning vector indices if end of array reached natively
        if (targetWeekday == -1) {
          targetWeekday = classDays.first;
        }

        // Apply strict Day Offset transformation delta calculus
        int offsetDays = targetWeekday - currentWeekday;
        if (offsetDays < 0 || (offsetDays == 0 && now.isAfter(target))) {
          offsetDays += 7; // Push differential strictly explicitly 7 days forward 
        }

        target = DateTime(now.year, now.month, now.day + offsetDays, hour, minute);
      } else {
        // Safe 24H differential fallback vector
        if (now.isAfter(target)) {
          target = target.add(const Duration(days: 1));
        }
      }
      return target;
    }
    
    final fallbackNow = DateTime.now();
    return DateTime(fallbackNow.year, fallbackNow.month, fallbackNow.day + 1, 9, 0);
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    // Safety check fallback logic bounds
    if (now.isAfter(_targetTime)) {
      _targetTime = _parseScheduleTime(widget.subject.schedule);
    }

    setState(() {
      _timeLeft = _targetTime.difference(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final showDays = days > 0;
    
    final displayHours = (showDays ? _timeLeft.inHours.remainder(24) : _timeLeft.inHours).toString().padLeft(2, '0');
    final minutes = (_timeLeft.inMinutes.remainder(60)).toString().padLeft(2, '0');
    final seconds = (_timeLeft.inSeconds.remainder(60)).toString().padLeft(2, '0');
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, color: widget.color, size: 20),
              const SizedBox(width: 8),
              Text(
                'Next Class Starts In',
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (showDays) ...[
                _timeBox(days.toString().padLeft(2, '0'), 'DAY', theme),
                Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.color)),
              ],
              _timeBox(displayHours, 'HRS', theme),
              Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.color)),
              _timeBox(minutes, 'MIN', theme),
              if (!showDays) ...[
                Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.color)),
                _timeBox(seconds, 'SEC', theme),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String value, String label, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.outline,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

// ── Analytics Rings ──────────────────────────────────────────────────────────
class _AnalyticsRings extends StatelessWidget {
  final Color color;
  const _AnalyticsRings({required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_rounded, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                'Performance Analytics',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRingItem(context, 'Attendance', 0.85, Colors.purpleAccent, "Target 75%"),
              _buildRingItem(context, 'Grade', 0.92, Colors.greenAccent, "Target 80%"),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRingItem(context, 'Assignments', 0.70, Colors.orangeAccent, "Target 90%"),
              _buildRingItem(context, 'Progress', 0.40, Colors.pinkAccent, "Week 6/15"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRingItem(BuildContext context, String label, double percentage, Color ringColor, String subtitle) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: percentage),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: _RingPainter(progress: value, color: ringColor, bgColor: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                  ),
                  Center(
                    child: Text(
                      '${(value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;

  _RingPainter({required this.progress, required this.color, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = bgColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -pi/2
      progress * 2 * 3.14159,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
