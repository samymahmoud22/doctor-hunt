import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/themes/app_text_styles.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';
import 'package:doctor_hunt/core/utils/debouncer.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
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
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  @override
  void dispose() {
    _debouncer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminDoctorsCubit>()..loadDoctors(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocConsumer<AdminDoctorsCubit, AdminDoctorsState>(
            listener: (context, state) {
              if (state.errorMessage != null && state.allDoctors.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.danger,
                    content: Text(state.errorMessage!),
                  ),
                );
              }
            },
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
                                  Text(
                                    t.admin.doctors,
                                    style: AppTextStyles.h2,
                                  ),
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.notifications_outlined,
                                              color: AppColors.subtext,
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
                                                color: AppColors.danger,
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
                                            errorBuilder: (context, error, stackTrace) => Text(
                                              'A',
                                              style: AppTextStyles.labelBold.withPrimary,
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
                                    title: t.admin.activeDoctors,
                                    count: '${state.activeDoctorsCount}',
                                  ),
                                  const SizedBox(width: 12),
                                  AdminStatCard(
                                    title: t.admin.totalDoctors,
                                    count: '${state.totalDoctorsCount}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              CustomTextField(
                                controller: _searchController,
                                hint: t.admin.searchDoctor,
                                hintStyle: AppTextStyles.bodyMedium.withPlaceholder,
                                prefixIcon: Icons.search_rounded,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (val) {
                                  _debouncer.cancel();
                                  cubit.setSearchQuery(val);
                                },
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          _debouncer.cancel();
                                          _searchController.clear();
                                          cubit.setSearchQuery('');
                                          setState(() {});
                                        },
                                      )
                                    : null,
                                onChanged: (val) {
                                  setState(() {});
                                  _debouncer.run(() => cubit.setSearchQuery(val));
                                },
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.cardBorder),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.cardBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primary),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
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
                                                  : AppColors.cardBorder,
                                            ),
                                          ),
                                          child: Text(
                                            label,
                                            style: AppTextStyles.labelBold.copyWith(
                                              fontSize: 13,
                                              color: isSelected
                                                  ? AppColors.white
                                                  : AppColors.subtext,
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

                      if (state.errorMessage != null && state.allDoctors.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildErrorState(context, cubit, state.errorMessage!),
                        )
                      else if (state.filteredDoctors.isEmpty)
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
                        text: t.admin.addDoctor,
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

  Widget _buildErrorState(BuildContext context, AdminDoctorsCubit cubit, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.danger,
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load doctors',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtextMedium.copyWith(color: AppColors.danger),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Retry',
              icon: Icons.refresh_rounded,
              width: 140,
              height: 42,
              borderRadius: BorderRadius.circular(24),
              onPressed: () => cubit.loadDoctors(),
            ),
          ],
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
                color: AppColors.primaryLight,
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
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.admin.noDoctorsFound,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              t.admin.noDoctorsDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtextMedium.copyWith(height: 1.4),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: t.admin.addDoctor,
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
