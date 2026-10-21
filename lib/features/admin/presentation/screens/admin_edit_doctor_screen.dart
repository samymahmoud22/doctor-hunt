import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import '../../data/models/admin_doctor_model.dart';
import '../../data/repo/admin_repository.dart';

class AdminEditDoctorScreen extends StatefulWidget {
  final AdminDoctorModel doctor;

  const AdminEditDoctorScreen({super.key, required this.doctor});

  @override
  State<AdminEditDoctorScreen> createState() => _AdminEditDoctorScreenState();
}

class _AdminEditDoctorScreenState extends State<AdminEditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _feeController;
  late String _selectedSpecialty;
  late bool _isActive;
  bool _isLoading = false;

  final List<String> _specialties = [
    'Cardiologist',
    'Orthopedic',
    'Dermatologist',
    'Pediatrician',
    'Dentist',
    'General Physician',
    'Neurologist',
    'Ophthalmologist',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor.name);
    _feeController = TextEditingController(
      text: widget.doctor.consultationFee.toStringAsFixed(2),
    );
    _selectedSpecialty = _specialties.contains(widget.doctor.specialty)
        ? widget.doctor.specialty
        : _specialties.first;
    _isActive = widget.doctor.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final fee = double.tryParse(_feeController.text.replaceAll('\$', '').trim()) ??
        widget.doctor.consultationFee;

    final updated = widget.doctor.copyWith(
      name: _nameController.text.trim(),
      specialty: _selectedSpecialty,
      consultationFee: fee,
      isActive: _isActive,
    );

    await sl<AdminRepository>().updateDoctor(updated);
    if (mounted) {
      context.showSnackBar('Doctor updated successfully');
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Doctor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF333333)),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          DoctorImageHelper.buildDoctorAvatar(
                            doctorName: widget.doctor.name,
                            imageUrl: widget.doctor.imageUrl,
                            radius: 50,
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap photo to change',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'DOCTOR NAME',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF677294),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Doctor Name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter doctor name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'SPECIALTY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF677294),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSpecialty,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF677294)),
                      items: _specialties.map((spec) {
                        return DropdownMenuItem<String>(
                          value: spec,
                          child: Text(
                            spec,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSpecialty = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'CONSULTATION FEE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF677294),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Consultation Fee',
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.attach_money_rounded,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter consultation fee';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F8F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.verified_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor Status',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Active & Available',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF677294),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _isActive,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                CustomButton(
                  text: 'Save Changes',
                  isLoading: _isLoading,
                  onPressed: _saveChanges,
                ),
                const SizedBox(height: 14),

                CustomButton(
                  text: 'Delete Doctor',
                  height: 52,
                  isOutlined: true,
                  backgroundColor: const Color(0xFFFF4D4F),
                  textColor: const Color(0xFFFF4D4F),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Doctor'),
                        content: Text('Are you sure you want to delete ${widget.doctor.name}?'),
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
                      await sl<AdminRepository>().deleteDoctor(widget.doctor.id);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),

                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
