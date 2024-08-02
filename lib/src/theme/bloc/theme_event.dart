part of 'theme_bloc.dart';

@sealed
abstract class ThemeEvent {
  const ThemeEvent();

  List<Object?> get props => [];
}

class InitialThemeEvent extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class ChangeColorEvent extends ThemeEvent {
  final Color newColor;

  const ChangeColorEvent(this.newColor);
}

class ChangeColorHistoryEvent extends ThemeEvent {
  final List<Color> newColorHistory;

  const ChangeColorHistoryEvent(this.newColorHistory);
}
