// lib/enums/app_enums.dart

enum Gender {
  male('Male'),
  female('Female'),
  other('Other'),
  preferNotToSay('Prefer not to say');

  final String label;
  const Gender(this.label);
}

enum AuthState {
  idle,
  loading,
  success,
  error,
}

enum Subject {
  mobileAppDevelopment(
    name: 'Mobile App Development',
    code: 'CS-401',
    description:
        'This course covers the fundamentals and advanced concepts of mobile application development using Flutter and Dart. Students will learn UI design patterns, state management, API integration, and deployment strategies for both Android and iOS platforms.',
    schedule: 'Mon / Wed / Fri  —  9:00 AM – 10:30 AM',
    room: 'CYS Lab',
    instructor: 'Mam Rooshana Mughal',
    email: 'rooshana.mughal@gmail.com',
    credits: 3,
  ),
  softwareReengineering(
    name: 'Software Re-engineering',
    code: 'CS-402',
    description:
        'An in-depth study of techniques for restructuring, modernising, and optimising legacy software systems. Topics include reverse engineering, refactoring strategies, design patterns, code metrics, and migration methodologies for enterprise applications.',
    schedule: 'Tue / Thu  —  11:00 AM – 12:30 PM',
    room: 'Room 201 – Block A',
    instructor: 'Sir Conrad \'D Silva/ Mam Noureen Anwar',
    email: 'sw.reengineering@gmail.com',
    credits: 3,
  ),
  mis(
    name: 'Management Information Systems',
    code: 'CS-403',
    description:
        'Explores the role of information systems in supporting business processes and managerial decision-making. Covers database design, ERP systems, business intelligence, data analytics, and the strategic use of technology in organisations.',
    schedule: 'Mon / Wed  —  2:00 PM – 3:30 PM',
    room: 'SF-240',
    instructor: 'Ahmed Qaiser',
    email: 'ahmed.qaiser@gmail.com',
    credits: 3,
  ),
  uiUxDesign(
    name: 'UI/UX Design and Development',
    code: 'CS-404',
    description:
        'Focuses on fundamental principles of user interface and user experience design. Students will learn wireframing, prototyping, usability testing, and modern design frameworks to create intuitive and engaging digital solutions.',
    schedule: 'Tue / Thu  —  9:00 AM – 10:30 AM',
    room: 'ADV-Ai Lab',
    instructor: 'Mam Raazia Sosan',
    email: 'raazia.sosan@gmail.com',
    credits: 3,
  ),
  fypII(
    name: 'Final Year Project II (FYP-II)',
    code: 'CS-499',
    description:
        'The culminating phase of the degree program where prior research and designs are transformed into a fully functioning, polished, and tested production-ready software system.',
    schedule: 'Fri  —  2:00 PM – 5:00 PM',
    room: 'Project Lab – Block D',
    instructor: 'Dr. Kamran Khan',
    email: 'kamran.khan@gmail.com',
    credits: 6,
  );

  final String name;
  final String code;
  final String description;
  final String schedule;
  final String room;
  final String instructor;
  final String email;
  final int credits;

  const Subject({
    required this.name,
    required this.code,
    required this.description,
    required this.schedule,
    required this.room,
    required this.instructor,
    required this.email,
    required this.credits,
  });
}
