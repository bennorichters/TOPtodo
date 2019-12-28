import 'package:equatable/equatable.dart';

abstract class InitEvent extends Equatable {
  const InitEvent();
}

class RequestInitData extends InitEvent {
  const RequestInitData();

  @override
  List<Object> get props => [];
}
