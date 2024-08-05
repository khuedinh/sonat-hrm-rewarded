import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

const String kThemeModeKey = 'theme_mode';
const String kThemeColorKey = 'theme_color';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<InitialThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool(kThemeModeKey);
      final color = prefs.getInt(kThemeColorKey);
      emit(ThemeState(
          isDarkMode: isDarkMode ?? false,
          color: color != null ? Color(color) : Colors.orange,
          colorHistory: []));
    });

    on<ToggleThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool(kThemeModeKey) ?? false;
      emit(state.copyWith(isDarkMode: !isDarkMode));
      await prefs.setBool(kThemeModeKey, !isDarkMode);
    });

    on<ChangeColorEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      emit(state.copyWith(color: event.newColor));
      await prefs.setInt(kThemeColorKey, event.newColor.value);
    });
  }
}
