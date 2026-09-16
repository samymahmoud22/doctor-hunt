import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  static const int totalPages = 3;

  OnboardingCubit() : super(const OnboardingState());

  void onPageChanged(int index) {
    emit(state.copyWith(
      currentPage: index,
      isLastPage: index == totalPages - 1,
    ));
  }

  void nextPage(Function() navigateToChooseRole) {
    if (state.isLastPage) {
      navigateToChooseRole();
    } else {
      onPageChanged(state.currentPage + 1);
    }
  }
}
