import 'package:equatable/equatable.dart';

abstract class InitEvent extends Equatable {
  const InitEvent();
}

class AppStarted extends InitEvent {
  const AppStarted();

  @override
  List<Object> get props => [];
}
