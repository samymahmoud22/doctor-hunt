import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ADMIN PORTAL',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'System Overview',
                        style: context.bold24TextMain.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, color: AppColors.textMain),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Grid of Stat Cards ---
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
                children: const [
                  _StatCard(
                    title: 'Total Doctors',
                    value: '48',
                    change: '+4 this month',
                    icon: Icons.people_outline_rounded,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'Active Patients',
                    value: '1,240',
                    change: '+12% growth',
                    icon: Icons.personal_injury_outlined,
                    color: Color(0xFF10B981),
                  ),
                  _StatCard(
                    title: 'Appointments Today',
                    value: '38',
                    change: '8 pending',
                    icon: Icons.calendar_today_rounded,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: 'Total Revenue',
                    value: '\$14,820',
                    change: '+18% vs last mo',
                    icon: Icons.payments_outlined,
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- Quick Actions Header ---
              Text(
                'Quick Actions',
                style: context.bold18TextMain,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  _QuickActionButton(
                    icon: Icons.person_add_outlined,
                    label: 'Add Doctor',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _QuickActionButton(
                    icon: Icons.edit_calendar_outlined,
                    label: 'Schedules',
                    color: Colors.indigo,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _QuickActionButton(
                    icon: Icons.analytics_outlined,
                    label: 'Reports',
                    color: Colors.teal,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _QuickActionButton(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    color: Colors.blueGrey,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- Doctor Approval Requests ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Approvals',
                    style: context.bold18TextMain,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('View All', style: context.medium14Primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _PendingDoctorCard(
                name: 'Dr. Robert Chen',
                specialty: 'Dermatology',
                hospital: 'City Medical Clinic',
                date: 'Applied 2 hrs ago',
              ),
              const SizedBox(height: 12),
              const _PendingDoctorCard(
                name: 'Dr. Clara Vance',
                specialty: 'Orthopedics',
                hospital: 'General Hospital',
                date: 'Applied 5 hrs ago',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Text(
            change,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingDoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String hospital;
  final String date;

  const _PendingDoctorCard({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigo.withValues(alpha: 0.1),
                child: const Icon(Icons.person_outline, color: Colors.indigo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      '$specialty • $hospital',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSub),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 11, color: AppColors.textSub),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
