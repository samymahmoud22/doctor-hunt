import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import '../../data/models/admin_doctor_model.dart';
import '../../data/repo/admin_repository.dart';

class AdminDoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const AdminDoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<AdminDoctorDetailsScreen> createState() => _AdminDoctorDetailsScreenState();
}

class _AdminDoctorDetailsScreenState extends State<AdminDoctorDetailsScreen> {
  AdminDoctorModel? _doctor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  Future<void> _loadDoctor() async {
    final repo = sl<AdminRepository>();
    final docs = await repo.getDoctors();
    final match = docs.firstWhere(
      (d) => d.id == widget.doctorId,
      orElse: () => docs.first,
    );
    setState(() {
      _doctor = match;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _doctor == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9FAFB),
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final doctor = _doctor!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Doctor Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF333333)),
            onSelected: (val) async {
              if (val == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Doctor'),
                    content: Text('Are you sure you want to delete ${doctor.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  await sl<AdminRepository>().deleteDoctor(doctor.id);
                  if (context.mounted) Navigator.of(context).pop(true);
                }
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Doctor', style: TextStyle(color: AppColors.danger)),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Center(
                child: Stack(
                  children: [
                    DoctorImageHelper.buildDoctorAvatar(
                      doctorName: doctor.name,
                      imageUrl: doctor.imageUrl,
                      radius: 54,
                    ),
                    if (doctor.isActive)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: doctor.isActive
                      ? const Color(0xFFE7F8F2)
                      : const Color(0xFFFFF1F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: doctor.isActive
                            ? AppColors.primary
                            : const Color(0xFFFF4D4F),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: doctor.isActive
                            ? AppColors.primary
                            : const Color(0xFFFF4D4F),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.medical_services_outlined,
                      label: 'Specialty',
                      value: doctor.specialty,
                    ),
                    const Divider(height: 1, indent: 64, endIndent: 20, color: Color(0xFFF3F4F6)),
                    _buildInfoTile(
                      icon: Icons.star_outline_rounded,
                      label: 'Rating',
                      value: '${doctor.rating} • ${doctor.reviewsCount} reviews',
                    ),
                    const Divider(height: 1, indent: 64, endIndent: 20, color: Color(0xFFF3F4F6)),
                    _buildInfoTile(
                      icon: Icons.attach_money_rounded,
                      label: 'Consultation Fee',
                      value: '\$${doctor.consultationFee.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              CustomButton(
                text: 'Edit Doctor',
                icon: Icons.edit_outlined,
                height: 52,
                onPressed: () async {
                  final updated = await context.push<bool>(
                    '/admin/edit-doctor?doctorId=${doctor.id}',
                    extra: doctor,
                  );
                  if (updated == true) {
                    _loadDoctor();
                  }
                },
              ),
              const SizedBox(height: 14),
              CustomButton(
                text: 'Manage Availability',
                icon: Icons.event_note_outlined,
                isOutlined: true,
                height: 52,
                onPressed: () async {
                  final updated = await context.push<bool>(
                    '/admin/doctor-availability?doctorId=${doctor.id}',
                    extra: doctor,
                  );
                  if (updated == true) {
                    _loadDoctor();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F8F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF677294),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
