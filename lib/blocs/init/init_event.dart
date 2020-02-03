import 'package:equatable/equatable.dart';

/// Base class of all events related to initialization
abstract class InitEvent extends Equatable {
  /// Creates an [InitEvent]
  const InitEvent();
}

/// Event that will trigger loading all data needed for initialization
class RequestInitData extends InitEvent {
  /// Creates a [RequestInitData]
  const RequestInitData();

  @override
  List<Object> get props => [];
}
