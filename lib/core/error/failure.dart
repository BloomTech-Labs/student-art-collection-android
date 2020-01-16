import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/error/failure.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);
}

// General Failures
class ServerFailure extends Failure {
  @override
  List<Object> get props => null;
}

class CacheFailure extends Failure {
  final String message;

  CacheFailure({this.message});
  @override
  List<Object> get props => null;
}

class FirebaseFailure extends Failure {
  final String message;

  FirebaseFailure(this.message);

  @override
  List<Object> get props => [message];
}

class NetworkFailure<T> extends Failure {
  final T cacheData;

  NetworkFailure([this.cacheData]);

  @override
  List<Object> get props => [cacheData];
}

class UserInputFailure extends Failure {
  final String message;

  UserInputFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ArtworkInputFailure extends Failure {
  final String message;

  ArtworkInputFailure({this.message});

  @override
  List<Object> get props => [
        message,
      ];
}
