part of 'theme_bloc.dart';

@sealed
class ThemeState {
  const ThemeState(
      {required this.isDarkMode,
      required this.color,
      required this.colorHistory});

  final bool isDarkMode;
  final Color color;
  final List<Color>? colorHistory;

  ThemeState copyWith({
    bool? isDarkMode,
    Color? color,
    List<Color>? colorHistory,
  }) {
    return ThemeState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        color: color ?? this.color,
        colorHistory: colorHistory ?? this.colorHistory);
  }

  List<Object?> get props => [isDarkMode, color, colorHistory];
}

class ThemeInitial extends ThemeState {
  ThemeInitial(
      {super.isDarkMode = false,
      super.color = Colors.orange,
      super.colorHistory = const []});
}
