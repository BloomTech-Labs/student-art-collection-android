import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/buy_art/data/repository/artwork_repository_impl.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_artwork_by_id.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/data/repository/firebase_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school_on_return.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/logout_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';

import 'features/buy_art/data/data_source/artwork_local_data_source.dart';
import 'features/buy_art/data/data_source/artwork_remote_data_source.dart';
import 'features/buy_art/domain/repository/artwork_repository.dart';
import 'features/buy_art/domain/usecase/get_all_artwork.dart';
import 'features/list_art/data/data_source/school_remote_data_source.dart';
import 'features/list_art/domain/repository/school_auth_repository.dart';

final sl = GetIt.instance;

Future init() async {
  /** Feature: Buy Art */

  // Bloc
  sl.registerLazySingleton(() => GalleryBloc(
    artworkRepository: sl()
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetAllArtwork(sl()));
  sl.registerLazySingleton(() => GetArtworkByID(sl()));

  // Repository
  sl.registerLazySingleton<ArtworkRepository>(() => ArtworkRepositoryImpl(
      remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<ArtworkRemoteDataSource>(
          () => GraphQLArtworkRemoteDataSource(
        client: sl(),
      ));

  sl.registerLazySingleton<ArtworkLocalDataSource>(
          () => ArtworkLocalDataSourceImpl());

  /** Feature: List Art */

  // Bloc
  sl.registerLazySingleton(() => SchoolAuthBloc(
        converter: sl(),
        loginSchool: sl(),
        registerNewSchool: sl(),
        loginSchoolOnReturn: sl(),
        logoutSchool: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginSchool(sl()));
  sl.registerLazySingleton(() => RegisterNewSchool(sl()));
  sl.registerLazySingleton(() => LoginSchoolOnReturn(sl()));
  sl.registerLazySingleton(() => LogoutSchool(sl()));

  // Repository
  sl.registerLazySingleton<SchoolAuthRepository>(() => FirebaseAuthRepository(
      remoteDataSource: sl(), networkInfo: sl(), firebaseAuth: sl()));

  // Data Sources
  sl.registerLazySingleton<SchoolRemoteDataSource>(
      () => GraphQLSchoolRemoteDataSource(
            client: sl(),
          ));

  sl.registerLazySingleton(() => FirebaseAuth.instance);

  /** Feature: Core */

  // Util
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton<GraphQLClient>(() =>
      GraphQLClient(cache: InMemoryCache(), link: HttpLink(uri: BASE_URL)));
}