/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 4
/// Strings: 188 (47 per locale)
///
/// Built on 2026-01-16 at 10:23 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	es(languageCode: 'es', build: _StringsEs.build),
	fr(languageCode: 'fr', build: _StringsFr.build),
	pt(languageCode: 'pt', build: _StringsPt.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get appTitle => 'Otaku Swipe';
	late final _StringsHomeEn home = _StringsHomeEn._(_root);
	late final _StringsLevelSelectEn levelSelect = _StringsLevelSelectEn._(_root);
	late final _StringsQuizEn quiz = _StringsQuizEn._(_root);
	late final _StringsSettingsEn settings = _StringsSettingsEn._(_root);
}

// Path: home
class _StringsHomeEn {
	_StringsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Master Japanese Slang!';
	String get start => 'Start Learning';
}

// Path: levelSelect
class _StringsLevelSelectEn {
	_StringsLevelSelectEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Select Level';
	String get subtitle => 'Choose your slang journey!';
	late final _StringsLevelSelectLevelsEn levels = _StringsLevelSelectLevelsEn._(_root);
}

// Path: quiz
class _StringsQuizEn {
	_StringsQuizEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get question => 'Question';
	String get dontKnow => 'DON\'T KNOW';
	String get iKnowIt => 'I KNOW IT!';
	String get tapToSeeMeaning => 'Tap to see meaning';
	String get reviewMode => 'Review Mode';
	late final _StringsQuizResultEn result = _StringsQuizResultEn._(_root);
	late final _StringsQuizLockedEn locked = _StringsQuizLockedEn._(_root);
}

// Path: settings
class _StringsSettingsEn {
	_StringsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get legal => 'LEGAL';
	String get privacyPolicy => 'Privacy Policy';
	String get termsOfUse => 'Terms of Use';
	String get tokusho => 'Specified Commercial Transactions Act';
	String get services => 'SERVICES';
	String get restore => 'Restore Purchases';
	String get restoreSubtitle => 'Restore your previously purchased levels';
	String get restoreSuccess => 'Restore process completed.';
	String restoreError({required Object error}) => 'Restore failed: ${error}';
	String get appInfo => 'APP INFO';
	String get version => 'Version';
}

// Path: levelSelect.levels
class _StringsLevelSelectLevelsEn {
	_StringsLevelSelectLevelsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsLevelSelectLevelsLevel1En level1 = _StringsLevelSelectLevelsLevel1En._(_root);
	late final _StringsLevelSelectLevelsLevel2En level2 = _StringsLevelSelectLevelsLevel2En._(_root);
	late final _StringsLevelSelectLevelsLevel3En level3 = _StringsLevelSelectLevelsLevel3En._(_root);
	late final _StringsLevelSelectLevelsLevel4En level4 = _StringsLevelSelectLevelsLevel4En._(_root);
	late final _StringsLevelSelectLevelsLevel5En level5 = _StringsLevelSelectLevelsLevel5En._(_root);
	late final _StringsLevelSelectLevelsLevel6En level6 = _StringsLevelSelectLevelsLevel6En._(_root);
}

// Path: quiz.result
class _StringsQuizResultEn {
	_StringsQuizResultEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get perfect => 'Perfect Master!';
	String get awesome => 'Awesome!';
	String get goodJob => 'Good job!';
	String get listTitle => 'Results List';
	String get backToMenu => 'Back to Menu';
	String get replayAll => 'Replay All';
	String reviewButton({required Object count}) => 'Review ${count} Words';
}

// Path: quiz.locked
class _StringsQuizLockedEn {
	_StringsQuizLockedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Paid Content';
	String get desc => 'Unlock Level 6 to see more!';
	String get button => 'Unlock Now';
	String get dialogTitle => 'Unlock Yakuza Level';
	String get dialogDesc => 'Unlock the full 50 words list?';
	String get cancel => 'Cancel';
}

// Path: levelSelect.levels.level1
class _StringsLevelSelectLevelsLevel1En {
	_StringsLevelSelectLevelsLevel1En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Level 1: Survival';
	String get desc => 'Essential words you must know.';
}

// Path: levelSelect.levels.level2
class _StringsLevelSelectLevelsLevel2En {
	_StringsLevelSelectLevelsLevel2En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Level 2: Youth';
	String get desc => 'Trending words among Gen Z.';
}

// Path: levelSelect.levels.level3
class _StringsLevelSelectLevelsLevel3En {
	_StringsLevelSelectLevelsLevel3En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Level 3: Otaku';
	String get desc => 'Anime & Manga culture terms.';
}

// Path: levelSelect.levels.level4
class _StringsLevelSelectLevelsLevel4En {
	_StringsLevelSelectLevelsLevel4En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Level 4: Internet';
	String get desc => 'Net slang & Gaming chat.';
}

// Path: levelSelect.levels.level5
class _StringsLevelSelectLevelsLevel5En {
	_StringsLevelSelectLevelsLevel5En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Level 5: Persona';
	String get desc => 'Ore, Boku, Watashi... Pronouns.';
}

// Path: levelSelect.levels.level6
class _StringsLevelSelectLevelsLevel6En {
	_StringsLevelSelectLevelsLevel6En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Level 6: Yakuza';
	String get desc => 'Dangerous underworld slang.';
}

// Path: <root>
class _StringsEs extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEs.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsEs _root = this; // ignore: unused_field

	// Translations
	@override String get appTitle => 'Otaku Swipe';
	@override late final _StringsHomeEs home = _StringsHomeEs._(_root);
	@override late final _StringsLevelSelectEs levelSelect = _StringsLevelSelectEs._(_root);
	@override late final _StringsQuizEs quiz = _StringsQuizEs._(_root);
	@override late final _StringsSettingsEs settings = _StringsSettingsEs._(_root);
}

// Path: home
class _StringsHomeEs extends _StringsHomeEn {
	_StringsHomeEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¡Domina la Jerga Japonesa!';
	@override String get start => 'Empezar a Aprender';
}

// Path: levelSelect
class _StringsLevelSelectEs extends _StringsLevelSelectEn {
	_StringsLevelSelectEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleccionar Nivel';
	@override String get subtitle => '¡Elige tu camino!';
	@override late final _StringsLevelSelectLevelsEs levels = _StringsLevelSelectLevelsEs._(_root);
}

// Path: quiz
class _StringsQuizEs extends _StringsQuizEn {
	_StringsQuizEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get question => 'Pregunta';
	@override String get dontKnow => 'NO SÉ';
	@override String get iKnowIt => '¡LO SÉ!';
	@override String get tapToSeeMeaning => 'Toca para ver el significado';
	@override String get reviewMode => 'Modo Repaso';
	@override late final _StringsQuizResultEs result = _StringsQuizResultEs._(_root);
	@override late final _StringsQuizLockedEs locked = _StringsQuizLockedEs._(_root);
}

// Path: settings
class _StringsSettingsEs extends _StringsSettingsEn {
	_StringsSettingsEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes';
	@override String get legal => 'LEGAL';
	@override String get privacyPolicy => 'Política de Privacidad';
	@override String get termsOfUse => 'Términos de Uso';
	@override String get tokusho => 'Ley de Transacciones Comerciales';
	@override String get services => 'SERVICIOS';
	@override String get restore => 'Restaurar Compras';
	@override String get restoreSubtitle => 'Restaura tus niveles comprados';
	@override String get restoreSuccess => 'Proceso de restauración completado.';
	@override String restoreError({required Object error}) => 'Error al restaurar: ${error}';
	@override String get appInfo => 'INFO APP';
	@override String get version => 'Versión';
}

// Path: levelSelect.levels
class _StringsLevelSelectLevelsEs extends _StringsLevelSelectLevelsEn {
	_StringsLevelSelectLevelsEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override late final _StringsLevelSelectLevelsLevel1Es level1 = _StringsLevelSelectLevelsLevel1Es._(_root);
	@override late final _StringsLevelSelectLevelsLevel2Es level2 = _StringsLevelSelectLevelsLevel2Es._(_root);
	@override late final _StringsLevelSelectLevelsLevel3Es level3 = _StringsLevelSelectLevelsLevel3Es._(_root);
	@override late final _StringsLevelSelectLevelsLevel4Es level4 = _StringsLevelSelectLevelsLevel4Es._(_root);
	@override late final _StringsLevelSelectLevelsLevel5Es level5 = _StringsLevelSelectLevelsLevel5Es._(_root);
	@override late final _StringsLevelSelectLevelsLevel6Es level6 = _StringsLevelSelectLevelsLevel6Es._(_root);
}

// Path: quiz.result
class _StringsQuizResultEs extends _StringsQuizResultEn {
	_StringsQuizResultEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get perfect => '¡Maestro Perfecto!';
	@override String get awesome => '¡Increíble!';
	@override String get goodJob => '¡Buen trabajo!';
	@override String get listTitle => 'Lista de Resultados';
	@override String get backToMenu => 'Volver al Menú';
	@override String get replayAll => 'Repetir Todo';
	@override String reviewButton({required Object count}) => 'Repasar ${count} Palabras';
}

// Path: quiz.locked
class _StringsQuizLockedEs extends _StringsQuizLockedEn {
	_StringsQuizLockedEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Contenido de Pago';
	@override String get desc => '¡Desbloquea el Nivel 6 para ver más!';
	@override String get button => 'Desbloquear';
	@override String get dialogTitle => 'Desbloquear Nivel Yakuza';
	@override String get dialogDesc => '¿Desbloquear la lista completa de 50 palabras?';
	@override String get cancel => 'Cancelar';
}

// Path: levelSelect.levels.level1
class _StringsLevelSelectLevelsLevel1Es extends _StringsLevelSelectLevelsLevel1En {
	_StringsLevelSelectLevelsLevel1Es._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nivel 1: Supervivencia';
	@override String get desc => 'Palabras esenciales que debes saber.';
}

// Path: levelSelect.levels.level2
class _StringsLevelSelectLevelsLevel2Es extends _StringsLevelSelectLevelsLevel2En {
	_StringsLevelSelectLevelsLevel2Es._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nivel 2: Juventud';
	@override String get desc => 'Palabras de moda entre la Gen Z.';
}

// Path: levelSelect.levels.level3
class _StringsLevelSelectLevelsLevel3Es extends _StringsLevelSelectLevelsLevel3En {
	_StringsLevelSelectLevelsLevel3Es._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nivel 3: Otaku';
	@override String get desc => 'Términos de cultura Anime y Manga.';
}

// Path: levelSelect.levels.level4
class _StringsLevelSelectLevelsLevel4Es extends _StringsLevelSelectLevelsLevel4En {
	_StringsLevelSelectLevelsLevel4Es._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nivel 4: Internet';
	@override String get desc => 'Argot de la red y juegos.';
}

// Path: levelSelect.levels.level5
class _StringsLevelSelectLevelsLevel5Es extends _StringsLevelSelectLevelsLevel5En {
	_StringsLevelSelectLevelsLevel5Es._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nivel 5: Persona';
	@override String get desc => 'Ore, Boku, Watashi... Pronombres.';
}

// Path: levelSelect.levels.level6
class _StringsLevelSelectLevelsLevel6Es extends _StringsLevelSelectLevelsLevel6En {
	_StringsLevelSelectLevelsLevel6Es._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nivel 6: Yakuza';
	@override String get desc => 'Argot peligroso del bajo mundo.';
}

// Path: <root>
class _StringsFr extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsFr.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsFr _root = this; // ignore: unused_field

	// Translations
	@override String get appTitle => 'Otaku Swipe';
	@override late final _StringsHomeFr home = _StringsHomeFr._(_root);
	@override late final _StringsLevelSelectFr levelSelect = _StringsLevelSelectFr._(_root);
	@override late final _StringsQuizFr quiz = _StringsQuizFr._(_root);
	@override late final _StringsSettingsFr settings = _StringsSettingsFr._(_root);
}

// Path: home
class _StringsHomeFr extends _StringsHomeEn {
	_StringsHomeFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Maîtrisez l\'argot japonais !';
	@override String get start => 'Commencer l\'apprentissage';
}

// Path: levelSelect
class _StringsLevelSelectFr extends _StringsLevelSelectEn {
	_StringsLevelSelectFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Choisir le niveau';
	@override String get subtitle => 'Choisissez votre parcours !';
	@override late final _StringsLevelSelectLevelsFr levels = _StringsLevelSelectLevelsFr._(_root);
}

// Path: quiz
class _StringsQuizFr extends _StringsQuizEn {
	_StringsQuizFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get question => 'Question';
	@override String get dontKnow => 'JE NE SAIS PAS';
	@override String get iKnowIt => 'JE SAIS !';
	@override String get tapToSeeMeaning => 'Appuyez pour voir le sens';
	@override String get reviewMode => 'Mode Révision';
	@override late final _StringsQuizResultFr result = _StringsQuizResultFr._(_root);
	@override late final _StringsQuizLockedFr locked = _StringsQuizLockedFr._(_root);
}

// Path: settings
class _StringsSettingsFr extends _StringsSettingsEn {
	_StringsSettingsFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Paramètres';
	@override String get legal => 'LÉGAL';
	@override String get privacyPolicy => 'Politique de confidentialité';
	@override String get termsOfUse => 'Conditions d\'utilisation';
	@override String get tokusho => 'Loi sur les transactions commerciales';
	@override String get services => 'SERVICES';
	@override String get restore => 'Restaurer les achats';
	@override String get restoreSubtitle => 'Restaurer vos niveaux achetés';
	@override String get restoreSuccess => 'Restauration terminée.';
	@override String restoreError({required Object error}) => 'Échec de la restauration : ${error}';
	@override String get appInfo => 'INFO APP';
	@override String get version => 'Version';
}

// Path: levelSelect.levels
class _StringsLevelSelectLevelsFr extends _StringsLevelSelectLevelsEn {
	_StringsLevelSelectLevelsFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override late final _StringsLevelSelectLevelsLevel1Fr level1 = _StringsLevelSelectLevelsLevel1Fr._(_root);
	@override late final _StringsLevelSelectLevelsLevel2Fr level2 = _StringsLevelSelectLevelsLevel2Fr._(_root);
	@override late final _StringsLevelSelectLevelsLevel3Fr level3 = _StringsLevelSelectLevelsLevel3Fr._(_root);
	@override late final _StringsLevelSelectLevelsLevel4Fr level4 = _StringsLevelSelectLevelsLevel4Fr._(_root);
	@override late final _StringsLevelSelectLevelsLevel5Fr level5 = _StringsLevelSelectLevelsLevel5Fr._(_root);
	@override late final _StringsLevelSelectLevelsLevel6Fr level6 = _StringsLevelSelectLevelsLevel6Fr._(_root);
}

// Path: quiz.result
class _StringsQuizResultFr extends _StringsQuizResultEn {
	_StringsQuizResultFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get perfect => 'Maître Parfait !';
	@override String get awesome => 'Génial !';
	@override String get goodJob => 'Bon travail !';
	@override String get listTitle => 'Liste des résultats';
	@override String get backToMenu => 'Retour au menu';
	@override String get replayAll => 'Tout rejouer';
	@override String reviewButton({required Object count}) => 'Revoir ${count} mots';
}

// Path: quiz.locked
class _StringsQuizLockedFr extends _StringsQuizLockedEn {
	_StringsQuizLockedFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Contenu payant';
	@override String get desc => 'Débloquez le niveau 6 pour en voir plus !';
	@override String get button => 'Débloquer';
	@override String get dialogTitle => 'Débloquer le niveau Yakuza';
	@override String get dialogDesc => 'Débloquer la liste complète de 50 mots ?';
	@override String get cancel => 'Annuler';
}

// Path: levelSelect.levels.level1
class _StringsLevelSelectLevelsLevel1Fr extends _StringsLevelSelectLevelsLevel1En {
	_StringsLevelSelectLevelsLevel1Fr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Niveau 1 : Survie';
	@override String get desc => 'Mots essentiels à connaître.';
}

// Path: levelSelect.levels.level2
class _StringsLevelSelectLevelsLevel2Fr extends _StringsLevelSelectLevelsLevel2En {
	_StringsLevelSelectLevelsLevel2Fr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Niveau 2 : Jeunesse';
	@override String get desc => 'Mots tendance chez la Gen Z.';
}

// Path: levelSelect.levels.level3
class _StringsLevelSelectLevelsLevel3Fr extends _StringsLevelSelectLevelsLevel3En {
	_StringsLevelSelectLevelsLevel3Fr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Niveau 3 : Otaku';
	@override String get desc => 'Termes de la culture Anime & Manga.';
}

// Path: levelSelect.levels.level4
class _StringsLevelSelectLevelsLevel4Fr extends _StringsLevelSelectLevelsLevel4En {
	_StringsLevelSelectLevelsLevel4Fr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Niveau 4 : Internet';
	@override String get desc => 'Argot du net & Gaming.';
}

// Path: levelSelect.levels.level5
class _StringsLevelSelectLevelsLevel5Fr extends _StringsLevelSelectLevelsLevel5En {
	_StringsLevelSelectLevelsLevel5Fr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Niveau 5 : Persona';
	@override String get desc => 'Ore, Boku, Watashi... Pronoms.';
}

// Path: levelSelect.levels.level6
class _StringsLevelSelectLevelsLevel6Fr extends _StringsLevelSelectLevelsLevel6En {
	_StringsLevelSelectLevelsLevel6Fr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Niveau 6 : Yakuza';
	@override String get desc => 'Argot dangereux de la pègre.';
}

// Path: <root>
class _StringsPt extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsPt.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.pt,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pt>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsPt _root = this; // ignore: unused_field

	// Translations
	@override String get appTitle => 'Otaku Swipe';
	@override late final _StringsHomePt home = _StringsHomePt._(_root);
	@override late final _StringsLevelSelectPt levelSelect = _StringsLevelSelectPt._(_root);
	@override late final _StringsQuizPt quiz = _StringsQuizPt._(_root);
	@override late final _StringsSettingsPt settings = _StringsSettingsPt._(_root);
}

// Path: home
class _StringsHomePt extends _StringsHomeEn {
	_StringsHomePt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Domine as Gírias Japonesas!';
	@override String get start => 'Começar a Aprender';
}

// Path: levelSelect
class _StringsLevelSelectPt extends _StringsLevelSelectEn {
	_StringsLevelSelectPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Selecione o Nível';
	@override String get subtitle => 'Escolha sua jornada!';
	@override late final _StringsLevelSelectLevelsPt levels = _StringsLevelSelectLevelsPt._(_root);
}

// Path: quiz
class _StringsQuizPt extends _StringsQuizEn {
	_StringsQuizPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get question => 'Pergunta';
	@override String get dontKnow => 'NÃO SEI';
	@override String get iKnowIt => 'EU SEI!';
	@override String get tapToSeeMeaning => 'Toque para ver o significado';
	@override String get reviewMode => 'Modo Revisão';
	@override late final _StringsQuizResultPt result = _StringsQuizResultPt._(_root);
	@override late final _StringsQuizLockedPt locked = _StringsQuizLockedPt._(_root);
}

// Path: settings
class _StringsSettingsPt extends _StringsSettingsEn {
	_StringsSettingsPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configurações';
	@override String get legal => 'LEGAL';
	@override String get privacyPolicy => 'Política de Privacidade';
	@override String get termsOfUse => 'Termos de Uso';
	@override String get tokusho => 'Lei de Transações Comerciais';
	@override String get services => 'SERVIÇOS';
	@override String get restore => 'Restaurar Compras';
	@override String get restoreSubtitle => 'Restaurar seus níveis comprados';
	@override String get restoreSuccess => 'Restauração concluída.';
	@override String restoreError({required Object error}) => 'Falha na restauração: ${error}';
	@override String get appInfo => 'INFO DO APP';
	@override String get version => 'Versão';
}

// Path: levelSelect.levels
class _StringsLevelSelectLevelsPt extends _StringsLevelSelectLevelsEn {
	_StringsLevelSelectLevelsPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override late final _StringsLevelSelectLevelsLevel1Pt level1 = _StringsLevelSelectLevelsLevel1Pt._(_root);
	@override late final _StringsLevelSelectLevelsLevel2Pt level2 = _StringsLevelSelectLevelsLevel2Pt._(_root);
	@override late final _StringsLevelSelectLevelsLevel3Pt level3 = _StringsLevelSelectLevelsLevel3Pt._(_root);
	@override late final _StringsLevelSelectLevelsLevel4Pt level4 = _StringsLevelSelectLevelsLevel4Pt._(_root);
	@override late final _StringsLevelSelectLevelsLevel5Pt level5 = _StringsLevelSelectLevelsLevel5Pt._(_root);
	@override late final _StringsLevelSelectLevelsLevel6Pt level6 = _StringsLevelSelectLevelsLevel6Pt._(_root);
}

// Path: quiz.result
class _StringsQuizResultPt extends _StringsQuizResultEn {
	_StringsQuizResultPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get perfect => 'Mestre Perfeito!';
	@override String get awesome => 'Incrível!';
	@override String get goodJob => 'Bom trabalho!';
	@override String get listTitle => 'Lista de Resultados';
	@override String get backToMenu => 'Voltar ao Menu';
	@override String get replayAll => 'Jogar Tudo de Novo';
	@override String reviewButton({required Object count}) => 'Revisar ${count} palavras';
}

// Path: quiz.locked
class _StringsQuizLockedPt extends _StringsQuizLockedEn {
	_StringsQuizLockedPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Conteúdo Pago';
	@override String get desc => 'Desbloqueie o Nível 6 para ver mais!';
	@override String get button => 'Desbloquear';
	@override String get dialogTitle => 'Desbloquear Nível Yakuza';
	@override String get dialogDesc => 'Desbloquear a lista completa de 50 palavras?';
	@override String get cancel => 'Cancelar';
}

// Path: levelSelect.levels.level1
class _StringsLevelSelectLevelsLevel1Pt extends _StringsLevelSelectLevelsLevel1En {
	_StringsLevelSelectLevelsLevel1Pt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nível 1: Sobrevivência';
	@override String get desc => 'Palavras essenciais para saber.';
}

// Path: levelSelect.levels.level2
class _StringsLevelSelectLevelsLevel2Pt extends _StringsLevelSelectLevelsLevel2En {
	_StringsLevelSelectLevelsLevel2Pt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nível 2: Juventude';
	@override String get desc => 'Palavras da moda na Gen Z.';
}

// Path: levelSelect.levels.level3
class _StringsLevelSelectLevelsLevel3Pt extends _StringsLevelSelectLevelsLevel3En {
	_StringsLevelSelectLevelsLevel3Pt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nível 3: Otaku';
	@override String get desc => 'Termos da cultura Anime & Mangá.';
}

// Path: levelSelect.levels.level4
class _StringsLevelSelectLevelsLevel4Pt extends _StringsLevelSelectLevelsLevel4En {
	_StringsLevelSelectLevelsLevel4Pt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nível 4: Internet';
	@override String get desc => 'Gírias da web e jogos.';
}

// Path: levelSelect.levels.level5
class _StringsLevelSelectLevelsLevel5Pt extends _StringsLevelSelectLevelsLevel5En {
	_StringsLevelSelectLevelsLevel5Pt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nível 5: Persona';
	@override String get desc => 'Ore, Boku, Watashi... Pronomes.';
}

// Path: levelSelect.levels.level6
class _StringsLevelSelectLevelsLevel6Pt extends _StringsLevelSelectLevelsLevel6En {
	_StringsLevelSelectLevelsLevel6Pt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nível 6: Yakuza';
	@override String get desc => 'Gírias perigosas do submundo.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'Otaku Swipe';
			case 'home.title': return 'Master Japanese Slang!';
			case 'home.start': return 'Start Learning';
			case 'levelSelect.title': return 'Select Level';
			case 'levelSelect.subtitle': return 'Choose your slang journey!';
			case 'levelSelect.levels.level1.title': return 'Level 1: Survival';
			case 'levelSelect.levels.level1.desc': return 'Essential words you must know.';
			case 'levelSelect.levels.level2.title': return 'Level 2: Youth';
			case 'levelSelect.levels.level2.desc': return 'Trending words among Gen Z.';
			case 'levelSelect.levels.level3.title': return 'Level 3: Otaku';
			case 'levelSelect.levels.level3.desc': return 'Anime & Manga culture terms.';
			case 'levelSelect.levels.level4.title': return 'Level 4: Internet';
			case 'levelSelect.levels.level4.desc': return 'Net slang & Gaming chat.';
			case 'levelSelect.levels.level5.title': return 'Level 5: Persona';
			case 'levelSelect.levels.level5.desc': return 'Ore, Boku, Watashi... Pronouns.';
			case 'levelSelect.levels.level6.title': return 'Level 6: Yakuza';
			case 'levelSelect.levels.level6.desc': return 'Dangerous underworld slang.';
			case 'quiz.question': return 'Question';
			case 'quiz.dontKnow': return 'DON\'T KNOW';
			case 'quiz.iKnowIt': return 'I KNOW IT!';
			case 'quiz.tapToSeeMeaning': return 'Tap to see meaning';
			case 'quiz.reviewMode': return 'Review Mode';
			case 'quiz.result.perfect': return 'Perfect Master!';
			case 'quiz.result.awesome': return 'Awesome!';
			case 'quiz.result.goodJob': return 'Good job!';
			case 'quiz.result.listTitle': return 'Results List';
			case 'quiz.result.backToMenu': return 'Back to Menu';
			case 'quiz.result.replayAll': return 'Replay All';
			case 'quiz.result.reviewButton': return ({required Object count}) => 'Review ${count} Words';
			case 'quiz.locked.label': return 'Paid Content';
			case 'quiz.locked.desc': return 'Unlock Level 6 to see more!';
			case 'quiz.locked.button': return 'Unlock Now';
			case 'quiz.locked.dialogTitle': return 'Unlock Yakuza Level';
			case 'quiz.locked.dialogDesc': return 'Unlock the full 50 words list?';
			case 'quiz.locked.cancel': return 'Cancel';
			case 'settings.title': return 'Settings';
			case 'settings.legal': return 'LEGAL';
			case 'settings.privacyPolicy': return 'Privacy Policy';
			case 'settings.termsOfUse': return 'Terms of Use';
			case 'settings.tokusho': return 'Specified Commercial Transactions Act';
			case 'settings.services': return 'SERVICES';
			case 'settings.restore': return 'Restore Purchases';
			case 'settings.restoreSubtitle': return 'Restore your previously purchased levels';
			case 'settings.restoreSuccess': return 'Restore process completed.';
			case 'settings.restoreError': return ({required Object error}) => 'Restore failed: ${error}';
			case 'settings.appInfo': return 'APP INFO';
			case 'settings.version': return 'Version';
			default: return null;
		}
	}
}

extension on _StringsEs {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'Otaku Swipe';
			case 'home.title': return '¡Domina la Jerga Japonesa!';
			case 'home.start': return 'Empezar a Aprender';
			case 'levelSelect.title': return 'Seleccionar Nivel';
			case 'levelSelect.subtitle': return '¡Elige tu camino!';
			case 'levelSelect.levels.level1.title': return 'Nivel 1: Supervivencia';
			case 'levelSelect.levels.level1.desc': return 'Palabras esenciales que debes saber.';
			case 'levelSelect.levels.level2.title': return 'Nivel 2: Juventud';
			case 'levelSelect.levels.level2.desc': return 'Palabras de moda entre la Gen Z.';
			case 'levelSelect.levels.level3.title': return 'Nivel 3: Otaku';
			case 'levelSelect.levels.level3.desc': return 'Términos de cultura Anime y Manga.';
			case 'levelSelect.levels.level4.title': return 'Nivel 4: Internet';
			case 'levelSelect.levels.level4.desc': return 'Argot de la red y juegos.';
			case 'levelSelect.levels.level5.title': return 'Nivel 5: Persona';
			case 'levelSelect.levels.level5.desc': return 'Ore, Boku, Watashi... Pronombres.';
			case 'levelSelect.levels.level6.title': return 'Nivel 6: Yakuza';
			case 'levelSelect.levels.level6.desc': return 'Argot peligroso del bajo mundo.';
			case 'quiz.question': return 'Pregunta';
			case 'quiz.dontKnow': return 'NO SÉ';
			case 'quiz.iKnowIt': return '¡LO SÉ!';
			case 'quiz.tapToSeeMeaning': return 'Toca para ver el significado';
			case 'quiz.reviewMode': return 'Modo Repaso';
			case 'quiz.result.perfect': return '¡Maestro Perfecto!';
			case 'quiz.result.awesome': return '¡Increíble!';
			case 'quiz.result.goodJob': return '¡Buen trabajo!';
			case 'quiz.result.listTitle': return 'Lista de Resultados';
			case 'quiz.result.backToMenu': return 'Volver al Menú';
			case 'quiz.result.replayAll': return 'Repetir Todo';
			case 'quiz.result.reviewButton': return ({required Object count}) => 'Repasar ${count} Palabras';
			case 'quiz.locked.label': return 'Contenido de Pago';
			case 'quiz.locked.desc': return '¡Desbloquea el Nivel 6 para ver más!';
			case 'quiz.locked.button': return 'Desbloquear';
			case 'quiz.locked.dialogTitle': return 'Desbloquear Nivel Yakuza';
			case 'quiz.locked.dialogDesc': return '¿Desbloquear la lista completa de 50 palabras?';
			case 'quiz.locked.cancel': return 'Cancelar';
			case 'settings.title': return 'Ajustes';
			case 'settings.legal': return 'LEGAL';
			case 'settings.privacyPolicy': return 'Política de Privacidad';
			case 'settings.termsOfUse': return 'Términos de Uso';
			case 'settings.tokusho': return 'Ley de Transacciones Comerciales';
			case 'settings.services': return 'SERVICIOS';
			case 'settings.restore': return 'Restaurar Compras';
			case 'settings.restoreSubtitle': return 'Restaura tus niveles comprados';
			case 'settings.restoreSuccess': return 'Proceso de restauración completado.';
			case 'settings.restoreError': return ({required Object error}) => 'Error al restaurar: ${error}';
			case 'settings.appInfo': return 'INFO APP';
			case 'settings.version': return 'Versión';
			default: return null;
		}
	}
}

extension on _StringsFr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'Otaku Swipe';
			case 'home.title': return 'Maîtrisez l\'argot japonais !';
			case 'home.start': return 'Commencer l\'apprentissage';
			case 'levelSelect.title': return 'Choisir le niveau';
			case 'levelSelect.subtitle': return 'Choisissez votre parcours !';
			case 'levelSelect.levels.level1.title': return 'Niveau 1 : Survie';
			case 'levelSelect.levels.level1.desc': return 'Mots essentiels à connaître.';
			case 'levelSelect.levels.level2.title': return 'Niveau 2 : Jeunesse';
			case 'levelSelect.levels.level2.desc': return 'Mots tendance chez la Gen Z.';
			case 'levelSelect.levels.level3.title': return 'Niveau 3 : Otaku';
			case 'levelSelect.levels.level3.desc': return 'Termes de la culture Anime & Manga.';
			case 'levelSelect.levels.level4.title': return 'Niveau 4 : Internet';
			case 'levelSelect.levels.level4.desc': return 'Argot du net & Gaming.';
			case 'levelSelect.levels.level5.title': return 'Niveau 5 : Persona';
			case 'levelSelect.levels.level5.desc': return 'Ore, Boku, Watashi... Pronoms.';
			case 'levelSelect.levels.level6.title': return 'Niveau 6 : Yakuza';
			case 'levelSelect.levels.level6.desc': return 'Argot dangereux de la pègre.';
			case 'quiz.question': return 'Question';
			case 'quiz.dontKnow': return 'JE NE SAIS PAS';
			case 'quiz.iKnowIt': return 'JE SAIS !';
			case 'quiz.tapToSeeMeaning': return 'Appuyez pour voir le sens';
			case 'quiz.reviewMode': return 'Mode Révision';
			case 'quiz.result.perfect': return 'Maître Parfait !';
			case 'quiz.result.awesome': return 'Génial !';
			case 'quiz.result.goodJob': return 'Bon travail !';
			case 'quiz.result.listTitle': return 'Liste des résultats';
			case 'quiz.result.backToMenu': return 'Retour au menu';
			case 'quiz.result.replayAll': return 'Tout rejouer';
			case 'quiz.result.reviewButton': return ({required Object count}) => 'Revoir ${count} mots';
			case 'quiz.locked.label': return 'Contenu payant';
			case 'quiz.locked.desc': return 'Débloquez le niveau 6 pour en voir plus !';
			case 'quiz.locked.button': return 'Débloquer';
			case 'quiz.locked.dialogTitle': return 'Débloquer le niveau Yakuza';
			case 'quiz.locked.dialogDesc': return 'Débloquer la liste complète de 50 mots ?';
			case 'quiz.locked.cancel': return 'Annuler';
			case 'settings.title': return 'Paramètres';
			case 'settings.legal': return 'LÉGAL';
			case 'settings.privacyPolicy': return 'Politique de confidentialité';
			case 'settings.termsOfUse': return 'Conditions d\'utilisation';
			case 'settings.tokusho': return 'Loi sur les transactions commerciales';
			case 'settings.services': return 'SERVICES';
			case 'settings.restore': return 'Restaurer les achats';
			case 'settings.restoreSubtitle': return 'Restaurer vos niveaux achetés';
			case 'settings.restoreSuccess': return 'Restauration terminée.';
			case 'settings.restoreError': return ({required Object error}) => 'Échec de la restauration : ${error}';
			case 'settings.appInfo': return 'INFO APP';
			case 'settings.version': return 'Version';
			default: return null;
		}
	}
}

extension on _StringsPt {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'Otaku Swipe';
			case 'home.title': return 'Domine as Gírias Japonesas!';
			case 'home.start': return 'Começar a Aprender';
			case 'levelSelect.title': return 'Selecione o Nível';
			case 'levelSelect.subtitle': return 'Escolha sua jornada!';
			case 'levelSelect.levels.level1.title': return 'Nível 1: Sobrevivência';
			case 'levelSelect.levels.level1.desc': return 'Palavras essenciais para saber.';
			case 'levelSelect.levels.level2.title': return 'Nível 2: Juventude';
			case 'levelSelect.levels.level2.desc': return 'Palavras da moda na Gen Z.';
			case 'levelSelect.levels.level3.title': return 'Nível 3: Otaku';
			case 'levelSelect.levels.level3.desc': return 'Termos da cultura Anime & Mangá.';
			case 'levelSelect.levels.level4.title': return 'Nível 4: Internet';
			case 'levelSelect.levels.level4.desc': return 'Gírias da web e jogos.';
			case 'levelSelect.levels.level5.title': return 'Nível 5: Persona';
			case 'levelSelect.levels.level5.desc': return 'Ore, Boku, Watashi... Pronomes.';
			case 'levelSelect.levels.level6.title': return 'Nível 6: Yakuza';
			case 'levelSelect.levels.level6.desc': return 'Gírias perigosas do submundo.';
			case 'quiz.question': return 'Pergunta';
			case 'quiz.dontKnow': return 'NÃO SEI';
			case 'quiz.iKnowIt': return 'EU SEI!';
			case 'quiz.tapToSeeMeaning': return 'Toque para ver o significado';
			case 'quiz.reviewMode': return 'Modo Revisão';
			case 'quiz.result.perfect': return 'Mestre Perfeito!';
			case 'quiz.result.awesome': return 'Incrível!';
			case 'quiz.result.goodJob': return 'Bom trabalho!';
			case 'quiz.result.listTitle': return 'Lista de Resultados';
			case 'quiz.result.backToMenu': return 'Voltar ao Menu';
			case 'quiz.result.replayAll': return 'Jogar Tudo de Novo';
			case 'quiz.result.reviewButton': return ({required Object count}) => 'Revisar ${count} palavras';
			case 'quiz.locked.label': return 'Conteúdo Pago';
			case 'quiz.locked.desc': return 'Desbloqueie o Nível 6 para ver mais!';
			case 'quiz.locked.button': return 'Desbloquear';
			case 'quiz.locked.dialogTitle': return 'Desbloquear Nível Yakuza';
			case 'quiz.locked.dialogDesc': return 'Desbloquear a lista completa de 50 palavras?';
			case 'quiz.locked.cancel': return 'Cancelar';
			case 'settings.title': return 'Configurações';
			case 'settings.legal': return 'LEGAL';
			case 'settings.privacyPolicy': return 'Política de Privacidade';
			case 'settings.termsOfUse': return 'Termos de Uso';
			case 'settings.tokusho': return 'Lei de Transações Comerciais';
			case 'settings.services': return 'SERVIÇOS';
			case 'settings.restore': return 'Restaurar Compras';
			case 'settings.restoreSubtitle': return 'Restaurar seus níveis comprados';
			case 'settings.restoreSuccess': return 'Restauração concluída.';
			case 'settings.restoreError': return ({required Object error}) => 'Falha na restauração: ${error}';
			case 'settings.appInfo': return 'INFO DO APP';
			case 'settings.version': return 'Versão';
			default: return null;
		}
	}
}
