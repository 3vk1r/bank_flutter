import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Курс валют и новости'**
  String get appTitle;

  /// No description provided for @currency.
  ///
  /// In ru, this message translates to:
  /// **'Курс валют'**
  String get currency;

  /// No description provided for @news.
  ///
  /// In ru, this message translates to:
  /// **'Новости'**
  String get news;

  /// No description provided for @profile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profile;

  /// No description provided for @user.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get user;

  /// No description provided for @theme.
  ///
  /// In ru, this message translates to:
  /// **'Тема приложения'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get systemTheme;

  /// No description provided for @chooseTheme.
  ///
  /// In ru, this message translates to:
  /// **'Выберите тему'**
  String get chooseTheme;

  /// No description provided for @dataSource.
  ///
  /// In ru, this message translates to:
  /// **'Источник данных'**
  String get dataSource;

  /// No description provided for @internet.
  ///
  /// In ru, this message translates to:
  /// **'Интернет'**
  String get internet;

  /// No description provided for @localCache.
  ///
  /// In ru, this message translates to:
  /// **'Локальный кэш'**
  String get localCache;

  /// No description provided for @remoteDataDescription.
  ///
  /// In ru, this message translates to:
  /// **'Получать актуальные данные с сервера'**
  String get remoteDataDescription;

  /// No description provided for @localDataDescription.
  ///
  /// In ru, this message translates to:
  /// **'Использовать сохранённые данные'**
  String get localDataDescription;

  /// No description provided for @clearCache.
  ///
  /// In ru, this message translates to:
  /// **'Очистить кэш'**
  String get clearCache;

  /// No description provided for @clearCacheDescription.
  ///
  /// In ru, this message translates to:
  /// **'Удалить сохранённые курсы валют и новости'**
  String get clearCacheDescription;

  /// No description provided for @cacheCleared.
  ///
  /// In ru, this message translates to:
  /// **'Кэш очищен'**
  String get cacheCleared;

  /// No description provided for @logout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get logout;

  /// No description provided for @logoutSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Вы вышли из аккаунта'**
  String get logoutSuccess;

  /// Номинал валюты с правильной формой слова
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =1{Номинал: 1 единица} few{Номинал: {count} единицы} many{Номинал: {count} единиц} other{Номинал: {count} единицы}}'**
  String nominal(int count);

  /// No description provided for @refresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get refresh;

  /// No description provided for @searchNews.
  ///
  /// In ru, this message translates to:
  /// **'Поиск новостей'**
  String get searchNews;

  /// No description provided for @searchCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Поиск валюты'**
  String get searchCurrency;

  /// No description provided for @clear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get clear;

  /// No description provided for @invalidLink.
  ///
  /// In ru, this message translates to:
  /// **'Некорректная ссылка'**
  String get invalidLink;

  /// No description provided for @openLinkError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть ссылку'**
  String get openLinkError;

  /// No description provided for @loading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @noSavedNews.
  ///
  /// In ru, this message translates to:
  /// **'Нет сохранённых новостей'**
  String get noSavedNews;

  /// No description provided for @newsNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Новости не найдены'**
  String get newsNotFound;

  /// No description provided for @open.
  ///
  /// In ru, this message translates to:
  /// **'Открыть'**
  String get open;

  /// No description provided for @noSavedData.
  ///
  /// In ru, this message translates to:
  /// **'Нет сохранённых данных'**
  String get noSavedData;

  /// No description provided for @currencyDataError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось получить данные о курсах валют'**
  String get currencyDataError;

  /// No description provided for @currencyLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить курсы валют'**
  String get currencyLoadError;

  /// No description provided for @dataLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка при загрузке данных'**
  String get dataLoadError;

  /// No description provided for @currencyNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Валюта не найдена'**
  String get currencyNotFound;

  /// No description provided for @localNewsCacheEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Локальный кэш новостей пуст'**
  String get localNewsCacheEmpty;

  /// No description provided for @newsDataError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось получить новости'**
  String get newsDataError;

  /// No description provided for @newsLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить новости'**
  String get newsLoadError;

  /// No description provided for @newsLoadingError.
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка при загрузке новостей'**
  String get newsLoadingError;

  /// No description provided for @loginSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Вход выполнен'**
  String get loginSuccess;

  /// No description provided for @welcome.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать'**
  String get welcome;

  /// No description provided for @loginDescription.
  ///
  /// In ru, this message translates to:
  /// **'Для продолжения выполните вход в приложение'**
  String get loginDescription;

  /// No description provided for @login.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get login;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
