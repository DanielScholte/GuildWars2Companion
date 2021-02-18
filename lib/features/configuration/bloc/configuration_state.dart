part of 'configuration_bloc.dart';

@immutable
abstract class ConfigurationState {}

class LoadedConfiguration extends ConfigurationState {
  final Configuration configuration;

  LoadedConfiguration({
    @required this.configuration,
  });
}
