import 'package:flutter_project/features/authentication/data/datasources/auth_datasource.dart';
import 'package:flutter_project/features/authentication/data/datasources/remote_auth_datasource.dart';
import 'package:flutter_project/features/authentication/data/repositories/atuhentication_repository_impl.dart';
import 'package:flutter_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_project/shared/data/remote/remote.dart';
import 'package:flutter_project/shared/domain/providers/dio_network_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authdataSourceProvider = Provider.family<LoginUserDataSource, NetworkService>(
  (_, networkService) => LoginUserRemoteDataSource(networkService),
);

final authRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) {
    final NetworkService networkService = ref.watch(netwokServiceProvider);
    final LoginUserDataSource dataSource = ref.watch(authdataSourceProvider(networkService));
    return AuthenticationRepositoryImpl(dataSource);
  },
);
