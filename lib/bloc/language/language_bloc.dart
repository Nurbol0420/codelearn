import 'package:bloc/bloc.dart';
import 'package:codelearn/bloc/language/language_event.dart';
import 'package:codelearn/bloc/language/language_state.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _languageKey = 'app_language';
  final GetStorage _storage = GetStorage();

  static const Map<String, String> availableLanguages = {
    'en': 'English',
    'kk': 'Қазақша',
  };

  LanguageBloc()
      : super(LanguageState(
          locale: Locale(_loadSavedLanguage()),
        )) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

// НАДО:
static String _loadSavedLanguage() {
  final GetStorage storage = GetStorage();
  return storage.read(_languageKey) ?? 'kk';  // <- казахский по умолчанию
}

  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    await _storage.write(_languageKey, event.languageCode);
    emit(state.copyWith(locale: Locale(event.languageCode)));
  }
}
