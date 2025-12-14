import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/features/register/cubit/signup_state.dart';
import 'package:smart_home/repository/auth_repository.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;
  SignupCubit({
    required this.authRepository,
  }) : super(SignupState());

  Future<void> register() async {
    try {
      emit(state.copyWith(isLoading: true));
      final params = state.toRegisterParams();
      await authRepository.register(params);
      emit(state.copyWith(isLoading: false, isSignupSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
