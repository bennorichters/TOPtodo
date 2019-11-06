import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsNoSearchListData extends SettingsState {
  @override
  List<Object> get props => [];
}
