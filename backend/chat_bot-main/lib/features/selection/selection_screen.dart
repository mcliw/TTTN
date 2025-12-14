import 'package:flutter/material.dart';
import 'package:smart_home/shared/widgets/custom_app_bar.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tra cứu thông tin học vụ',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuItem(
              context,
              icon: Icons.calendar_today,
              title: 'Lịch học',
              color: Colors.blue,
              onTap: () => _navigateToSchedule(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.assignment,
              title: 'Lịch thi',
              color: Colors.orange,
              onTap: () => _navigateToExamSchedule(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.grade,
              title: 'Tra cứu điểm',
              color: Colors.green,
              onTap: () => _navigateToGrades(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.notifications,
              title: 'Thông báo',
              color: Colors.red,
              onTap: () => _navigateToNotifications(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.book,
              title: 'Chi tiết môn học',
              color: Colors.purple,
              onTap: () => _navigateToCourseDetails(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSchedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScheduleScreen()),
    );
  }

  void _navigateToExamSchedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExamScheduleScreen()),
    );
  }

  void _navigateToGrades(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GradesScreen()),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  void _navigateToCourseDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CourseDetailsScreen()),
    );
  }
}

// Screen Lịch học
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = [
      {
        'day': 'Thứ 2',
        'subject': 'Lập trình Flutter',
        'time': '07:00 - 09:30',
        'room': 'A101'
      },
      {
        'day': 'Thứ 3',
        'subject': 'Cơ sở dữ liệu',
        'time': '13:00 - 15:30',
        'room': 'B205'
      },
      {
        'day': 'Thứ 4',
        'subject': 'Mạng máy tính',
        'time': '09:00 - 11:30',
        'room': 'C302'
      },
      {
        'day': 'Thứ 5',
        'subject': 'Lập trình Flutter',
        'time': '07:00 - 09:30',
        'room': 'A101'
      },
      {
        'day': 'Thứ 6',
        'subject': 'Trí tuệ nhân tạo',
        'time': '13:00 - 15:30',
        'room': 'D404'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch học'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  schedule['day']!.split(' ')[1],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                schedule['subject']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${schedule['time']} - Phòng ${schedule['room']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}

// Screen Lịch thi
class ExamScheduleScreen extends StatelessWidget {
  const ExamScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = [
      {
        'subject': 'Lập trình Flutter',
        'date': '15/12/2025',
        'time': '07:30',
        'room': 'A201',
        'form': 'Viết'
      },
      {
        'subject': 'Cơ sở dữ liệu',
        'date': '18/12/2025',
        'time': '13:30',
        'room': 'B105',
        'form': 'Thi máy'
      },
      {
        'subject': 'Mạng máy tính',
        'date': '20/12/2025',
        'time': '09:00',
        'room': 'C303',
        'form': 'Viết'
      },
      {
        'subject': 'Trí tuệ nhân tạo',
        'date': '22/12/2025',
        'time': '13:30',
        'room': 'D202',
        'form': 'Vấn đáp'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch thi'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam['subject']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('${exam['date']} - ${exam['time']}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('Phòng ${exam['room']}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.edit, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('Hình thức: ${exam['form']}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Screen Tra cứu điểm
class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grades = [
      {
        'subject': 'Lập trình Flutter',
        'credit': 4,
        'midterm': 8.5,
        'final': 9.0,
        'avg': 8.8
      },
      {
        'subject': 'Cơ sở dữ liệu',
        'credit': 3,
        'midterm': 7.0,
        'final': 8.0,
        'avg': 7.6
      },
      {
        'subject': 'Mạng máy tính',
        'credit': 3,
        'midterm': 8.0,
        'final': 7.5,
        'avg': 7.7
      },
      {
        'subject': 'Trí tuệ nhân tạo',
        'credit': 4,
        'midterm': 9.0,
        'final': 8.5,
        'avg': 8.7
      },
      {
        'subject': 'Phát triển Web',
        'credit': 3,
        'midterm': 8.5,
        'final': 9.0,
        'avg': 8.8
      },
    ];

    double totalGPA = 8.32;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu điểm'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.green.shade50,
            child: Column(
              children: [
                const Text(
                  'Điểm trung bình tích lũy',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  totalGPA.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                grade['subject'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'TC: ${grade['credit']}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildGradeItem(
                                'Giữa kỳ', grade['midterm'] as double),
                            _buildGradeItem(
                                'Cuối kỳ', grade['final'] as double),
                            _buildGradeItem(
                                'Trung bình', grade['avg'] as double,
                                isAvg: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String label, double value, {bool isAvg = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isAvg ? 20 : 16,
            fontWeight: isAvg ? FontWeight.bold : FontWeight.normal,
            color: isAvg ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}

// Screen Thông báo
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Thông báo nghỉ học',
        'content': 'Lớp Lập trình Flutter nghỉ học vào ngày 10/12/2025',
        'date': '08/12/2025',
        'type': 'Khoa CNTT'
      },
      {
        'title': 'Lịch thi cuối kỳ',
        'content': 'Đã có lịch thi cuối kỳ học kỳ 1 năm học 2024-2025',
        'date': '05/12/2025',
        'type': 'Phòng Đào tạo'
      },
      {
        'title': 'Đăng ký học phần',
        'content': 'Bắt đầu đăng ký học phần học kỳ 2 từ ngày 15/12/2025',
        'date': '01/12/2025',
        'type': 'Phòng Đào tạo'
      },
      {
        'title': 'Học bổng khuyến khích học tập',
        'content': 'Danh sách sinh viên đạt học bổng học kỳ 1',
        'date': '28/11/2025',
        'type': 'Phòng CTSV'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications, color: Colors.red),
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification['content']!),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        notification['type']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(' • ', style: TextStyle(fontSize: 12)),
                      Text(
                        notification['date']!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

// Screen Chi tiết môn học
class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {
        'name': 'Lập trình Flutter',
        'code': 'IT4788',
        'credits': 4,
        'lecturer': 'TS. Nguyễn Văn A',
        'schedule': 'Thứ 2, 4: 07:00 - 09:30',
        'room': 'A101'
      },
      {
        'name': 'Cơ sở dữ liệu',
        'code': 'IT3080',
        'credits': 3,
        'lecturer': 'PGS.TS. Trần Thị B',
        'schedule': 'Thứ 3: 13:00 - 15:30',
        'room': 'B205'
      },
      {
        'name': 'Mạng máy tính',
        'code': 'IT4060',
        'credits': 3,
        'lecturer': 'TS. Lê Văn C',
        'schedule': 'Thứ 4: 09:00 - 11:30',
        'room': 'C302'
      },
      {
        'name': 'Trí tuệ nhân tạo',
        'code': 'IT4140',
        'credits': 4,
        'lecturer': 'GS.TS. Phạm Thị D',
        'schedule': 'Thứ 6: 13:00 - 15:30',
        'room': 'D404'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết môn học'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          course['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${course['credits']} TC',
                          style: TextStyle(
                            color: Colors.purple.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mã môn: ${course['code']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                      Icons.person, 'Giảng viên', course['lecturer'] as String),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                      Icons.schedule, 'Lịch học', course['schedule'] as String),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                      Icons.room, 'Phòng học', course['room'] as String),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.purple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
