import 'package:flutter_project/features/authentication/domain/providers/login_provider.dart';
import 'package:flutter_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_project/features/authentication/presentation/providers/auth_state.dart';
import 'package:flutter_project/services/user_cache_service/domain/providers/user_cache_provider.dart';
import 'package:flutter_project/services/user_cache_service/domain/repositories/user_cache_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/shared/domain/models/user/user_model.dart';
import 'package:flutter_project/shared/exceptions/http_exception.dart';

final authStateNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final AuthenticationRepository authenticationRepository = ref.watch(authRepositoryProvider);
    final UserRepository userRepository = ref.watch(userLocalRepositoryProvider);
    return AuthNotifier(
      authRepository: authenticationRepository,
      userRepository: userRepository,
    );
  },
);

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthenticationRepository authRepository;
  final UserRepository userRepository;

  AuthNotifier({
    required this.authRepository,
    required this.userRepository,
  }) : super(const AuthState.initial());

  Future<void> loginUser(String username, String password) async {
    state = const AuthState.loading();
    final response = await authRepository.loginUser(
      user: User(username: username, password: password),
    );

    state = await response.fold(
      (failure) => AuthState.failure(failure),
      (user) async {
        final hasSavedUser = await userRepository.saveUser(user: user);
        if (hasSavedUser) {
          return const AuthState.success();
        }
        return AuthState.failure(CacheFailureException());
      },
    );
  }
}
