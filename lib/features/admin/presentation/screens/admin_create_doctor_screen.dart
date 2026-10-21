import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/extensions/context_ext.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import '../../data/models/admin_doctor_model.dart';
import '../../data/repo/admin_repository.dart';

class AdminCreateDoctorScreen extends StatefulWidget {
  const AdminCreateDoctorScreen({super.key});

  @override
  State<AdminCreateDoctorScreen> createState() => _AdminCreateDoctorScreenState();
}

class _AdminCreateDoctorScreenState extends State<AdminCreateDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _feeController = TextEditingController();
  String? _selectedSpecialty;
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
  void dispose() {
    _nameController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _createDoctor() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedSpecialty == null) {
      context.showSnackBar('Please select a specialty', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final fee = double.tryParse(_feeController.text.replaceAll('\$', '').trim()) ?? 28.0;

    final newDoctor = AdminDoctorModel(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      specialty: _selectedSpecialty!,
      consultationFee: fee,
      isActive: true,
      rating: 5.0,
      reviewsCount: 1,
    );

    await sl<AdminRepository>().addDoctor(newDoctor);
    if (mounted) {
      context.showSnackBar('Doctor created successfully');
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
          'Create Doctor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
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
                const SizedBox(height: 10),

                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add photo',
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
                  hint: 'e.g. Dr. Ahmed Ali',
                  controller: _nameController,
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
                      hint: const Text(
                        'Select specialty',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                      ),
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
                        setState(() => _selectedSpecialty = val);
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
                  hint: 'e.g. \$28.00',
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter consultation fee';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                CustomButton(
                  text: 'Create Doctor',
                  isLoading: _isLoading,
                  onPressed: _createDoctor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
