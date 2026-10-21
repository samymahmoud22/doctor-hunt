import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import '../controllers/admin_doctors_cubit.dart';
import '../controllers/admin_doctors_state.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_doctor_card.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => _AdminDoctorsScreenState();
}

class _AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminDoctorsCubit>()..loadDoctors(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: BlocBuilder<AdminDoctorsCubit, AdminDoctorsState>(
            builder: (context, state) {
              final cubit = context.read<AdminDoctorsCubit>();

              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Doctors',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.notifications_outlined,
                                              color: Color(0xFF677294),
                                            ),
                                            onPressed: () {},
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 12,
                                            child: Container(
                                              width: 7,
                                              height: 7,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFFF4D4F),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 4),
                                      CircleAvatar(
                                        radius: 17,
                                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                                        child: ClipOval(
                                          child: Image.asset(
                                            ImageAssets.userAvatar,
                                            width: 34,
                                            height: 34,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Text(
                                              'A',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  AdminStatCard(
                                    title: 'Active Doctors',
                                    count: '${state.activeDoctorsCount}',
                                  ),
                                  const SizedBox(width: 12),
                                  AdminStatCard(
                                    title: 'Total Doctors',
                                    count: '${state.totalDoctorsCount}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) => cubit.setSearchQuery(val),
                                  decoration: InputDecoration(
                                    hintText: 'Search doctors...',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 14,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF9E9E9E),
                                      size: 20,
                                    ),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear, size: 18),
                                            onPressed: () {
                                              _searchController.clear();
                                              cubit.setSearchQuery('');
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: state.specialties.map((spec) {
                                    final isSelected = state.selectedSpecialty == spec;
                                    final count = spec == 'All'
                                        ? state.allDoctors.length
                                        : state.allDoctors
                                            .where((d) => d.specialty == spec)
                                            .length;
                                    final label = '$spec ($count)';

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: InkWell(
                                        onTap: () => cubit.setSelectedSpecialty(spec),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : const Color(0xFFE5E7EB),
                                            ),
                                          ),
                                          child: Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0xFF677294),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (state.filteredDoctors.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(context, cubit),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final doctor = state.filteredDoctors[index];
                                return AdminDoctorCard(
                                  doctor: doctor,
                                  onTap: () async {
                                    final updated = await context.push<bool>(
                                      '/admin/doctor-details?doctorId=${doctor.id}',
                                    );
                                    if (updated == true) {
                                      cubit.loadDoctors();
                                    }
                                  },
                                );
                              },
                              childCount: state.filteredDoctors.length,
                            ),
                          ),
                        ),
                    ],
                  ),

                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomButton(
                        text: 'Add Doctor',
                        icon: Icons.add,
                        width: 140,
                        height: 48,
                        borderRadius: BorderRadius.circular(30),
                        onPressed: () async {
                          final created = await context.push<bool>('/admin/create-doctor');
                          if (created == true) {
                            cubit.loadDoctors();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AdminDoctorsCubit cubit) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFE7F8F2),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.medical_services_outlined,
                    color: AppColors.primary,
                    size: 46,
                  ),
                  Positioned(
                    bottom: 22,
                    right: 22,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Doctors Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'There are currently no doctors registered on Doctor Hunt. Add your first doctor to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSub,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Add Doctor',
              icon: Icons.add,
              width: 150,
              height: 44,
              borderRadius: BorderRadius.circular(24),
              onPressed: () async {
                final created = await context.push<bool>('/admin/create-doctor');
                if (created == true) {
                  cubit.loadDoctors();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
