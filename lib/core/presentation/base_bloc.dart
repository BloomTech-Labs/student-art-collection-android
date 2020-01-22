import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

abstract class BaseBloc<EventType, StateType>
    extends Bloc<EventType, StateType> {
  @override
  StateType get initialState => null;

  @override
  Stream<StateType> mapEventToState(EventType event);
}
