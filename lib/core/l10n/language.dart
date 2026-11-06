
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../data/database.dart';

export '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  AppLanguage get lang => Localizations.localeOf(this).languageCode == 'es' ? AppLanguage.es : AppLanguage.en;
}

/// Idiomas de la interfaz. Se eligen segun el telefono; ingles es el predeterminado.
enum AppLanguage { en, es }

AppLanguage resolveLanguage(Iterable<Locale>? locales) {
  for (final l in locales ?? const <Locale>[]) {
    if (l.languageCode == 'es') return AppLanguage.es;
    if (l.languageCode == 'en') return AppLanguage.en;
  }
  return AppLanguage.en;
}

const supportedAppLocales = [Locale('en'), Locale('es')];

Locale? resolveAppLocale(List<Locale>? locales, Iterable<Locale> supported) =>
    Locale(resolveLanguage(locales).name);

/// Idioma actual, actualizado cuando el telefono cambia de idioma.
class AppLanguageNotifier extends Notifier<AppLanguage> with WidgetsBindingObserver {
  @override
  AppLanguage build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    return resolveLanguage(WidgetsBinding.instance.platformDispatcher.locales);
  }

  @override
  void didChangeLocales(List<Locale>? locales) => state = resolveLanguage(locales);
}

final appLanguageProvider =
    NotifierProvider<AppLanguageNotifier, AppLanguage>(AppLanguageNotifier.new);

extension ItemMeaning on Item {
  /// Significado en el idioma de la interfaz (el otro idioma solo si falta).
  String? meaning(AppLanguage lang) =>
      lang == AppLanguage.en ? (meaningEn ?? meaningEs) : (meaningEs ?? meaningEn);
}
