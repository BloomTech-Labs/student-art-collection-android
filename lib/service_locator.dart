import 'dart:convert';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/core/util/secret.dart';
import 'package:student_art_collection/features/buy_art/data/repository/buyer_artwork_repository_impl.dart';
import 'package:student_art_collection/features/buy_art/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/data/repository/firebase_auth_repository.dart';
import 'package:student_art_collection/features/list_art/data/repository/school_artwork_repository_impl.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/delete_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/get_all_school_art.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school_on_return.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/logout_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_school_info.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_image.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_bloc.dart';

import 'core/util/secret_loader.dart';
import 'features/buy_art/data/data_source/buyer_local_data_source.dart';
import 'features/buy_art/data/data_source/buyer_remote_data_source.dart';
import 'features/buy_art/domain/repository/buyer_artwork_repository.dart';
import 'features/buy_art/domain/usecase/get_all_artwork.dart';
import 'features/buy_art/presentation/bloc/artwork_details/artwork_details_bloc.dart';
import 'features/list_art/data/data_source/school_local_data_source.dart';
import 'features/list_art/data/data_source/school_remote_data_source.dart';
import 'features/list_art/domain/repository/school_artwork_repository.dart';
import 'features/list_art/domain/repository/school_auth_repository.dart';

final sl = GetIt.instance;

Future init() async {
  /** Feature: Buy Art */

  // Bloc
  sl.registerFactory(() => GalleryBloc(
        getAllArtwork: sl(),
        inputConverter: sl(),
      ));

  sl.registerFactory(() => ArtworkDetailsBloc(artworkRepository: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetArtwork(sl()));

  // Repository
  sl.registerLazySingleton<BuyerArtworkRepository>(() =>
      BuyerArtworkRepositoryImpl(
          remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<BuyerRemoteDataSource>(
      () => GraphQLBuyerRemoteDataSource(
            client: sl<GraphQLClient>(),
            geolocator: sl<Geolocator>(),
          ));

  sl.registerLazySingleton<BuyerLocalDataSource>(
      () => BuyerLocalDataSourceImpl());

  /** Feature: List Art */

  // Bloc
  sl.registerFactory(() => SchoolAuthBloc(
        converter: sl(),
        loginSchool: sl(),
        registerNewSchool: sl(),
        loginSchoolOnReturn: sl(),
        logoutSchool: sl(),
        sessionManager: sl(),
      ));
  sl.registerFactory(() => SchoolGalleryBloc(
        sessionManager: sl(),
        getAllSchoolArt: sl(),
        logoutSchool: sl(),
      ));

  sl.registerFactory(() => ArtworkUploadBloc(
        sessionManager: sl(),
        uploadArtwork: sl(),
        converter: sl(),
        hostImage: sl(),
        updateArtwork: sl(),
        deleteArtwork: sl(),
      ));

  sl.registerFactory(() => SchoolProfileBloc(
        sessionManager: sl(),
        updateSchoolInfo: sl(),
        inputConverter: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginSchool(sl()));
  sl.registerLazySingleton(() => RegisterNewSchool(sl()));
  sl.registerLazySingleton(() => LoginSchoolOnReturn(sl()));
  sl.registerLazySingleton(() => LogoutSchool(sl()));
  sl.registerLazySingleton(() => UpdateSchoolInfo(sl()));

  sl.registerLazySingleton(() => GetAllSchoolArt(sl()));
  sl.registerLazySingleton(() => UploadArtwork(sl()));
  sl.registerLazySingleton(() => HostImage(sl()));
  sl.registerLazySingleton(() => UpdateArtwork(sl()));
  sl.registerLazySingleton(() => DeleteArtwork(sl()));

  // Repository
  sl.registerLazySingleton<SchoolAuthRepository>(() => FirebaseAuthRepository(
        remoteDataSource: sl(),
        networkInfo: sl(),
        firebaseAuth: sl(),
        localDataSource: sl(),
      ));

  sl.registerLazySingleton<SchoolArtworkRepository>(
      () => SchoolArtworkRepositoryImpl(
            networkInfo: sl(),
            remoteDataSource: sl(),
          ));

  // Data Sources
  sl.registerLazySingleton<SchoolRemoteDataSource>(
      () => GraphQLSchoolRemoteDataSource(
            graphQLClient: sl<GraphQLClient>(),
            cloudinaryClient: sl(),
          ));

  sl.registerLazySingleton<SchoolLocalDataSource>(
      () => SharedPrefsLocalDataSource(
            sharedPrefs: sl(),
          ));

  sl.registerLazySingleton(() => FirebaseAuth.instance);

  /** Feature: Core */

  // Util
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => SessionManager());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // External
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton<GraphQLClient>(() => GraphQLClient(
        cache: InMemoryCache(),
        link: HttpLink(uri: BASE_URL),
      ));

  CloudinarySecret secret =
      await SecretLoader(secretPath: "secrets.json").load();
  final decodedKey = latin1.decode(base64.decode(secret.apiKey));
  final decodedSecret = latin1.decode(base64.decode(secret.apiSecret));
  final decodedName = latin1.decode(base64.decode(secret.cloudName));
  sl.registerLazySingleton(
      () => CloudinaryClient(decodedKey, decodedSecret, decodedName));

  sl.registerLazySingleton(() => Geolocator());
}
