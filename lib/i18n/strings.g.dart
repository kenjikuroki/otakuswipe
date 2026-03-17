/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 5
/// Strings: 355 (71 per locale)
///
/// Built on 2026-02-07 at 10:11 UTC

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
	ja(languageCode: 'ja', build: _StringsJa.build),
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
	late final _StringsPremiumEn premium = _StringsPremiumEn._(_root);
	late final _StringsReviewEn review = _StringsReviewEn._(_root);
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
	String get submit => 'Submit';
	String get tapToSeeMeaning => 'Tap to see meaning';
	String get reviewMode => 'Review Mode';
	late final _StringsQuizResultEn result = _StringsQuizResultEn._(_root);
	late final _StringsQuizLockedEn locked = _StringsQuizLockedEn._(_root);
	late final _StringsQuizModeEn mode = _StringsQuizModeEn._(_root);
}

// Path: premium
class _StringsPremiumEn {
	_StringsPremiumEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsPremiumDialogEn dialog = _StringsPremiumDialogEn._(_root);
	late final _StringsPremiumUpgradeCardEn upgradeCard = _StringsPremiumUpgradeCardEn._(_root);
	late final _StringsPremiumSpecialOfferEn specialOffer = _StringsPremiumSpecialOfferEn._(_root);
}

// Path: review
class _StringsReviewEn {
	_StringsReviewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsReviewModalEn modal = _StringsReviewModalEn._(_root);
	String get button => 'Review Weakness';
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

// Path: quiz.mode
class _StringsQuizModeEn {
	_StringsQuizModeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get shuffle => 'Shuffle';
	String get sequential => 'Sequential';
}

// Path: premium.dialog
class _StringsPremiumDialogEn {
	_StringsPremiumDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Premium Upgrade';
	String get feature1 => 'Unlock Sequential Mode: Solve all questions in order from the first one.';
	String get feature2 => 'Completely Ad-Free: Remove all ads (banners, videos, etc.) from the app.';
	String get feature3 => 'Category-based Review: Focus on your weak spots by filtering by part.';
	String get buy => 'Upgrade Now';
	String get cancel => 'Later';
}

// Path: premium.upgradeCard
class _StringsPremiumUpgradeCardEn {
	_StringsPremiumUpgradeCardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Upgrade to Premium';
	String get subtitle => 'Remove ads and focus!';
	String get buy => 'Buy';
	String get restore => 'Restore purchase';
}

// Path: premium.specialOffer
class _StringsPremiumSpecialOfferEn {
	_StringsPremiumSpecialOfferEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Limited Time Offer';
	String get subtitle => 'Premium Ad-Free';
	String get desc => 'Unlock all features at a special price now!';
	String get priceBefore => '390 JPY';
	String get priceAfter => '190 JPY';
	String get buyNow => 'Buy Now';
	String get later => 'Maybe Later';
}

// Path: review.modal
class _StringsReviewModalEn {
	_StringsReviewModalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Select Category';
	String get allQuestions => 'All Categories';
	String questionCount({required Object count}) => '${count} questions';
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
	@override late final _StringsPremiumEs premium = _StringsPremiumEs._(_root);
	@override late final _StringsReviewEs review = _StringsReviewEs._(_root);
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
	@override String get submit => 'Responder';
	@override String get tapToSeeMeaning => 'Toca para ver el significado';
	@override String get reviewMode => 'Modo Repaso';
	@override late final _StringsQuizResultEs result = _StringsQuizResultEs._(_root);
	@override late final _StringsQuizLockedEs locked = _StringsQuizLockedEs._(_root);
	@override late final _StringsQuizModeEs mode = _StringsQuizModeEs._(_root);
}

// Path: premium
class _StringsPremiumEs extends _StringsPremiumEn {
	_StringsPremiumEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override late final _StringsPremiumDialogEs dialog = _StringsPremiumDialogEs._(_root);
	@override late final _StringsPremiumUpgradeCardEs upgradeCard = _StringsPremiumUpgradeCardEs._(_root);
	@override late final _StringsPremiumSpecialOfferEs specialOffer = _StringsPremiumSpecialOfferEs._(_root);
}

// Path: review
class _StringsReviewEs extends _StringsReviewEn {
	_StringsReviewEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override late final _StringsReviewModalEs modal = _StringsReviewModalEs._(_root);
	@override String get button => 'Repasar Debilidades';
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

// Path: quiz.mode
class _StringsQuizModeEs extends _StringsQuizModeEn {
	_StringsQuizModeEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get shuffle => 'Aleatorio';
	@override String get sequential => 'En orden';
}

// Path: premium.dialog
class _StringsPremiumDialogEs extends _StringsPremiumDialogEn {
	_StringsPremiumDialogEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mejora Premium';
	@override String get feature1 => 'Desbloquear Modo Secuencial: Resuelve todas las preguntas en orden desde la primera.';
	@override String get feature2 => 'Sin Anuncios: Elimina todos los anuncios (banners, videos, etc.) de la aplicación.';
	@override String get feature3 => 'Repaso por Categoría: Enfócate en tus debilidades filtrando por parte.';
	@override String get buy => 'Mejorar Ahora';
	@override String get cancel => 'Más tarde';
}

// Path: premium.upgradeCard
class _StringsPremiumUpgradeCardEs extends _StringsPremiumUpgradeCardEn {
	_StringsPremiumUpgradeCardEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mejora a Premium';
	@override String get subtitle => '¡Elimina anuncios y enfócate!';
	@override String get buy => 'Comprar';
	@override String get restore => 'Restaurar compra';
}

// Path: premium.specialOffer
class _StringsPremiumSpecialOfferEs extends _StringsPremiumSpecialOfferEn {
	_StringsPremiumSpecialOfferEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Oferta por Tiempo Limitado';
	@override String get subtitle => 'Premium Sin Anuncios';
	@override String get desc => '¡Desbloquea todas las funciones a un precio especial ahora!';
	@override String get priceBefore => '390 JPY';
	@override String get priceAfter => '190 JPY';
	@override String get buyNow => 'Comprar Ahora';
	@override String get later => 'Tal vez luego';
}

// Path: review.modal
class _StringsReviewModalEs extends _StringsReviewModalEn {
	_StringsReviewModalEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleccionar Categoría';
	@override String get allQuestions => 'Todas las Categorías';
	@override String questionCount({required Object count}) => '${count} preguntas';
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
	@override late final _StringsPremiumFr premium = _StringsPremiumFr._(_root);
	@override late final _StringsReviewFr review = _StringsReviewFr._(_root);
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
	@override String get submit => 'Valider';
	@override String get tapToSeeMeaning => 'Appuyez pour voir le sens';
	@override String get reviewMode => 'Mode Révision';
	@override late final _StringsQuizResultFr result = _StringsQuizResultFr._(_root);
	@override late final _StringsQuizLockedFr locked = _StringsQuizLockedFr._(_root);
	@override late final _StringsQuizModeFr mode = _StringsQuizModeFr._(_root);
}

// Path: premium
class _StringsPremiumFr extends _StringsPremiumEn {
	_StringsPremiumFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override late final _StringsPremiumDialogFr dialog = _StringsPremiumDialogFr._(_root);
	@override late final _StringsPremiumUpgradeCardFr upgradeCard = _StringsPremiumUpgradeCardFr._(_root);
	@override late final _StringsPremiumSpecialOfferFr specialOffer = _StringsPremiumSpecialOfferFr._(_root);
}

// Path: review
class _StringsReviewFr extends _StringsReviewEn {
	_StringsReviewFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override late final _StringsReviewModalFr modal = _StringsReviewModalFr._(_root);
	@override String get button => 'Réviser les faiblesses';
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

// Path: quiz.mode
class _StringsQuizModeFr extends _StringsQuizModeEn {
	_StringsQuizModeFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get shuffle => 'Aléatoire';
	@override String get sequential => 'Dans l\'ordre';
}

// Path: premium.dialog
class _StringsPremiumDialogFr extends _StringsPremiumDialogEn {
	_StringsPremiumDialogFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mise à niveau Premium';
	@override String get feature1 => 'Débloquer le mode séquentiel : résolvez toutes les questions dans l\'ordre en commençant par la première.';
	@override String get feature2 => 'Complètement sans publicité : supprimez toutes les publicités (bannières, vidéos, etc.) de l\'application.';
	@override String get feature3 => 'Révision par catégorie : concentrez-vous sur vos points faibles en filtrant par partie.';
	@override String get buy => 'Passer au Premium';
	@override String get cancel => 'Plus tard';
}

// Path: premium.upgradeCard
class _StringsPremiumUpgradeCardFr extends _StringsPremiumUpgradeCardEn {
	_StringsPremiumUpgradeCardFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Passer au Premium';
	@override String get subtitle => 'Supprimez les pubs et concentrez-vous !';
	@override String get buy => 'Acheter';
	@override String get restore => 'Restaurer l\'achat';
}

// Path: premium.specialOffer
class _StringsPremiumSpecialOfferFr extends _StringsPremiumSpecialOfferEn {
	_StringsPremiumSpecialOfferFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Offre à Durée Limitée';
	@override String get subtitle => 'Premium Sans Publicité';
	@override String get desc => 'Débloquez toutes les fonctionnalités à un prix spécial maintenant !';
	@override String get priceBefore => '390 JPY';
	@override String get priceAfter => '190 JPY';
	@override String get buyNow => 'Acheter Maintenant';
	@override String get later => 'Plus tard';
}

// Path: review.modal
class _StringsReviewModalFr extends _StringsReviewModalEn {
	_StringsReviewModalFr._(_StringsFr root) : this._root = root, super._(root);

	@override final _StringsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sélectionner la catégorie';
	@override String get allQuestions => 'Toutes les catégories';
	@override String questionCount({required Object count}) => '${count} questions';
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
class _StringsJa extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsJa.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsJa _root = this; // ignore: unused_field

	// Translations
	@override String get appTitle => 'オタク・スワイプ';
	@override late final _StringsHomeJa home = _StringsHomeJa._(_root);
	@override late final _StringsLevelSelectJa levelSelect = _StringsLevelSelectJa._(_root);
	@override late final _StringsQuizJa quiz = _StringsQuizJa._(_root);
	@override late final _StringsPremiumJa premium = _StringsPremiumJa._(_root);
	@override late final _StringsReviewJa review = _StringsReviewJa._(_root);
	@override late final _StringsSettingsJa settings = _StringsSettingsJa._(_root);
}

// Path: home
class _StringsHomeJa extends _StringsHomeEn {
	_StringsHomeJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '日本語のスラングを極めよう！';
	@override String get start => '学習を始める';
}

// Path: levelSelect
class _StringsLevelSelectJa extends _StringsLevelSelectEn {
	_StringsLevelSelectJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'レベル選択';
	@override String get subtitle => 'スラングの旅に出かけよう！';
	@override late final _StringsLevelSelectLevelsJa levels = _StringsLevelSelectLevelsJa._(_root);
}

// Path: quiz
class _StringsQuizJa extends _StringsQuizEn {
	_StringsQuizJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get question => '問題';
	@override String get dontKnow => 'わからない';
	@override String get iKnowIt => '知ってる！';
	@override String get submit => '送信';
	@override String get tapToSeeMeaning => 'タップで意味を表示';
	@override String get reviewMode => '復習モード';
	@override late final _StringsQuizResultJa result = _StringsQuizResultJa._(_root);
	@override late final _StringsQuizLockedJa locked = _StringsQuizLockedJa._(_root);
	@override late final _StringsQuizModeJa mode = _StringsQuizModeJa._(_root);
}

// Path: premium
class _StringsPremiumJa extends _StringsPremiumEn {
	_StringsPremiumJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override late final _StringsPremiumDialogJa dialog = _StringsPremiumDialogJa._(_root);
	@override late final _StringsPremiumUpgradeCardJa upgradeCard = _StringsPremiumUpgradeCardJa._(_root);
	@override late final _StringsPremiumSpecialOfferJa specialOffer = _StringsPremiumSpecialOfferJa._(_root);
}

// Path: review
class _StringsReviewJa extends _StringsReviewEn {
	_StringsReviewJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override late final _StringsReviewModalJa modal = _StringsReviewModalJa._(_root);
	@override String get button => '弱点復習';
}

// Path: settings
class _StringsSettingsJa extends _StringsSettingsEn {
	_StringsSettingsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定';
	@override String get legal => '規約・法務';
	@override String get privacyPolicy => 'プライバシーポリシー';
	@override String get termsOfUse => '利用規約';
	@override String get tokusho => '特定商取引法に基づく表記';
	@override String get services => 'サービス';
	@override String get restore => '購入の復元';
	@override String get restoreSubtitle => '購入済みのレベルを復元します';
	@override String get restoreSuccess => '復元処理が完了しました。';
	@override String restoreError({required Object error}) => '復元に失敗しました: ${error}';
	@override String get appInfo => 'アプリ情報';
	@override String get version => 'バージョン';
}

// Path: levelSelect.levels
class _StringsLevelSelectLevelsJa extends _StringsLevelSelectLevelsEn {
	_StringsLevelSelectLevelsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override late final _StringsLevelSelectLevelsLevel1Ja level1 = _StringsLevelSelectLevelsLevel1Ja._(_root);
	@override late final _StringsLevelSelectLevelsLevel2Ja level2 = _StringsLevelSelectLevelsLevel2Ja._(_root);
	@override late final _StringsLevelSelectLevelsLevel3Ja level3 = _StringsLevelSelectLevelsLevel3Ja._(_root);
	@override late final _StringsLevelSelectLevelsLevel4Ja level4 = _StringsLevelSelectLevelsLevel4Ja._(_root);
	@override late final _StringsLevelSelectLevelsLevel5Ja level5 = _StringsLevelSelectLevelsLevel5Ja._(_root);
	@override late final _StringsLevelSelectLevelsLevel6Ja level6 = _StringsLevelSelectLevelsLevel6Ja._(_root);
}

// Path: quiz.result
class _StringsQuizResultJa extends _StringsQuizResultEn {
	_StringsQuizResultJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get perfect => 'パーフェクト！';
	@override String get awesome => 'すごい！';
	@override String get goodJob => 'よくできました！';
	@override String get listTitle => '結果リスト';
	@override String get backToMenu => 'メニューへ戻る';
	@override String get replayAll => 'すべて解き直す';
	@override String reviewButton({required Object count}) => '${count}単語を復習する';
}

// Path: quiz.locked
class _StringsQuizLockedJa extends _StringsQuizLockedEn {
	_StringsQuizLockedJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get label => '有料コンテンツ';
	@override String get desc => 'レベル6をアンロックして続きを見よう！';
	@override String get button => 'アンロックする';
	@override String get dialogTitle => 'ヤクザレベルをアンロック';
	@override String get dialogDesc => '全50単語をアンロックしますか？';
	@override String get cancel => 'キャンセル';
}

// Path: quiz.mode
class _StringsQuizModeJa extends _StringsQuizModeEn {
	_StringsQuizModeJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get shuffle => 'ランダム';
	@override String get sequential => '順番通り';
}

// Path: premium.dialog
class _StringsPremiumDialogJa extends _StringsPremiumDialogEn {
	_StringsPremiumDialogJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プレミアムアップグレード';
	@override String get feature1 => '順番通りモード：最初の問題から順番に解くことができます。';
	@override String get feature2 => '完全広告非表示：バナー、動画などのすべての広告を削除します。';
	@override String get feature3 => 'カテゴリー別復習：パートごとに絞り込んで苦手な部分に集中できます。';
	@override String get buy => '今すぐアップグレード';
	@override String get cancel => 'あとで';
}

// Path: premium.upgradeCard
class _StringsPremiumUpgradeCardJa extends _StringsPremiumUpgradeCardEn {
	_StringsPremiumUpgradeCardJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プレミアムプランへ';
	@override String get subtitle => '広告を非表示にして集中！';
	@override String get buy => '購入';
	@override String get restore => '購入を復元する';
}

// Path: premium.specialOffer
class _StringsPremiumSpecialOfferJa extends _StringsPremiumSpecialOfferEn {
	_StringsPremiumSpecialOfferJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '期間限定特別オファー';
	@override String get subtitle => 'プレミアム広告非表示';
	@override String get desc => '今だけ特別価格で全機能をアンロック！';
	@override String get priceBefore => '390円';
	@override String get priceAfter => '190円';
	@override String get buyNow => '今すぐ購入';
	@override String get later => 'あとで考える';
}

// Path: review.modal
class _StringsReviewModalJa extends _StringsReviewModalEn {
	_StringsReviewModalJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'カテゴリー選択';
	@override String get allQuestions => '全カテゴリー';
	@override String questionCount({required Object count}) => '${count}問';
}

// Path: levelSelect.levels.level1
class _StringsLevelSelectLevelsLevel1Ja extends _StringsLevelSelectLevelsLevel1En {
	_StringsLevelSelectLevelsLevel1Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'レベル1：サバイバル';
	@override String get desc => '知っておくべき必須単語。';
}

// Path: levelSelect.levels.level2
class _StringsLevelSelectLevelsLevel2Ja extends _StringsLevelSelectLevelsLevel2En {
	_StringsLevelSelectLevelsLevel2Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'レベル2：若者言葉';
	@override String get desc => 'Z世代の間で流行っている言葉。';
}

// Path: levelSelect.levels.level3
class _StringsLevelSelectLevelsLevel3Ja extends _StringsLevelSelectLevelsLevel3En {
	_StringsLevelSelectLevelsLevel3Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'レベル3：オタク';
	@override String get desc => 'アニメ＆マンガ文化の用語。';
}

// Path: levelSelect.levels.level4
class _StringsLevelSelectLevelsLevel4Ja extends _StringsLevelSelectLevelsLevel4En {
	_StringsLevelSelectLevelsLevel4Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'レベル4：インターネット';
	@override String get desc => 'ネットスラング＆ゲームチャット。';
}

// Path: levelSelect.levels.level5
class _StringsLevelSelectLevelsLevel5Ja extends _StringsLevelSelectLevelsLevel5En {
	_StringsLevelSelectLevelsLevel5Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'レベル5：一人称・人称';
	@override String get desc => '俺、僕、私... 代名詞。';
}

// Path: levelSelect.levels.level6
class _StringsLevelSelectLevelsLevel6Ja extends _StringsLevelSelectLevelsLevel6En {
	_StringsLevelSelectLevelsLevel6Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'レベル6：ヤクザ';
	@override String get desc => '危険な裏社会のスラング。';
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
	@override late final _StringsPremiumPt premium = _StringsPremiumPt._(_root);
	@override late final _StringsReviewPt review = _StringsReviewPt._(_root);
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
	@override String get submit => 'Responder';
	@override String get tapToSeeMeaning => 'Toque para ver o significado';
	@override String get reviewMode => 'Modo Revisão';
	@override late final _StringsQuizResultPt result = _StringsQuizResultPt._(_root);
	@override late final _StringsQuizLockedPt locked = _StringsQuizLockedPt._(_root);
	@override late final _StringsQuizModePt mode = _StringsQuizModePt._(_root);
}

// Path: premium
class _StringsPremiumPt extends _StringsPremiumEn {
	_StringsPremiumPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override late final _StringsPremiumDialogPt dialog = _StringsPremiumDialogPt._(_root);
	@override late final _StringsPremiumUpgradeCardPt upgradeCard = _StringsPremiumUpgradeCardPt._(_root);
	@override late final _StringsPremiumSpecialOfferPt specialOffer = _StringsPremiumSpecialOfferPt._(_root);
}

// Path: review
class _StringsReviewPt extends _StringsReviewEn {
	_StringsReviewPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override late final _StringsReviewModalPt modal = _StringsReviewModalPt._(_root);
	@override String get button => 'Revisar Fraquezas';
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

// Path: quiz.mode
class _StringsQuizModePt extends _StringsQuizModeEn {
	_StringsQuizModePt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get shuffle => 'Aleatório';
	@override String get sequential => 'Em ordem';
}

// Path: premium.dialog
class _StringsPremiumDialogPt extends _StringsPremiumDialogEn {
	_StringsPremiumDialogPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Upgrade Premium';
	@override String get feature1 => 'Desbloquear Modo Sequencial: Resolva todas as questões em ordem a partir da primeira.';
	@override String get feature2 => 'Totalmente Sem Anúncios: Remova todos os anúncios (banners, vídeos, etc.) do aplicativo.';
	@override String get feature3 => 'Revisão por Categoria: Foco em seus pontos fracos filtrando por parte.';
	@override String get buy => 'Fazer Upgrade Agora';
	@override String get cancel => 'Depois';
}

// Path: premium.upgradeCard
class _StringsPremiumUpgradeCardPt extends _StringsPremiumUpgradeCardEn {
	_StringsPremiumUpgradeCardPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Upgrade para Premium';
	@override String get subtitle => 'Remova anúncios e tenha foco!';
	@override String get buy => 'Comprar';
	@override String get restore => 'Restaurar compra';
}

// Path: premium.specialOffer
class _StringsPremiumSpecialOfferPt extends _StringsPremiumSpecialOfferEn {
	_StringsPremiumSpecialOfferPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Oferta por Tempo Limitado';
	@override String get subtitle => 'Premium Sem Anúncios';
	@override String get desc => 'Desbloqueie todos os recursos com um preço especial agora!';
	@override String get priceBefore => '390 JPY';
	@override String get priceAfter => '190 JPY';
	@override String get buyNow => 'Comprar Agora';
	@override String get later => 'Depois';
}

// Path: review.modal
class _StringsReviewModalPt extends _StringsReviewModalEn {
	_StringsReviewModalPt._(_StringsPt root) : this._root = root, super._(root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Selecionar Categoria';
	@override String get allQuestions => 'Todas as Categorias';
	@override String questionCount({required Object count}) => '${count} questões';
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
			case 'quiz.submit': return 'Submit';
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
			case 'quiz.mode.shuffle': return 'Shuffle';
			case 'quiz.mode.sequential': return 'Sequential';
			case 'premium.dialog.title': return 'Premium Upgrade';
			case 'premium.dialog.feature1': return 'Unlock Sequential Mode: Solve all questions in order from the first one.';
			case 'premium.dialog.feature2': return 'Completely Ad-Free: Remove all ads (banners, videos, etc.) from the app.';
			case 'premium.dialog.feature3': return 'Category-based Review: Focus on your weak spots by filtering by part.';
			case 'premium.dialog.buy': return 'Upgrade Now';
			case 'premium.dialog.cancel': return 'Later';
			case 'premium.upgradeCard.title': return 'Upgrade to Premium';
			case 'premium.upgradeCard.subtitle': return 'Remove ads and focus!';
			case 'premium.upgradeCard.buy': return 'Buy';
			case 'premium.upgradeCard.restore': return 'Restore purchase';
			case 'premium.specialOffer.title': return 'Limited Time Offer';
			case 'premium.specialOffer.subtitle': return 'Premium Ad-Free';
			case 'premium.specialOffer.desc': return 'Unlock all features at a special price now!';
			case 'premium.specialOffer.priceBefore': return '390 JPY';
			case 'premium.specialOffer.priceAfter': return '190 JPY';
			case 'premium.specialOffer.buyNow': return 'Buy Now';
			case 'premium.specialOffer.later': return 'Maybe Later';
			case 'review.modal.title': return 'Select Category';
			case 'review.modal.allQuestions': return 'All Categories';
			case 'review.modal.questionCount': return ({required Object count}) => '${count} questions';
			case 'review.button': return 'Review Weakness';
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
			case 'quiz.submit': return 'Responder';
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
			case 'quiz.mode.shuffle': return 'Aleatorio';
			case 'quiz.mode.sequential': return 'En orden';
			case 'premium.dialog.title': return 'Mejora Premium';
			case 'premium.dialog.feature1': return 'Desbloquear Modo Secuencial: Resuelve todas las preguntas en orden desde la primera.';
			case 'premium.dialog.feature2': return 'Sin Anuncios: Elimina todos los anuncios (banners, videos, etc.) de la aplicación.';
			case 'premium.dialog.feature3': return 'Repaso por Categoría: Enfócate en tus debilidades filtrando por parte.';
			case 'premium.dialog.buy': return 'Mejorar Ahora';
			case 'premium.dialog.cancel': return 'Más tarde';
			case 'premium.upgradeCard.title': return 'Mejora a Premium';
			case 'premium.upgradeCard.subtitle': return '¡Elimina anuncios y enfócate!';
			case 'premium.upgradeCard.buy': return 'Comprar';
			case 'premium.upgradeCard.restore': return 'Restaurar compra';
			case 'premium.specialOffer.title': return 'Oferta por Tiempo Limitado';
			case 'premium.specialOffer.subtitle': return 'Premium Sin Anuncios';
			case 'premium.specialOffer.desc': return '¡Desbloquea todas las funciones a un precio especial ahora!';
			case 'premium.specialOffer.priceBefore': return '390 JPY';
			case 'premium.specialOffer.priceAfter': return '190 JPY';
			case 'premium.specialOffer.buyNow': return 'Comprar Ahora';
			case 'premium.specialOffer.later': return 'Tal vez luego';
			case 'review.modal.title': return 'Seleccionar Categoría';
			case 'review.modal.allQuestions': return 'Todas las Categorías';
			case 'review.modal.questionCount': return ({required Object count}) => '${count} preguntas';
			case 'review.button': return 'Repasar Debilidades';
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
			case 'quiz.submit': return 'Valider';
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
			case 'quiz.mode.shuffle': return 'Aléatoire';
			case 'quiz.mode.sequential': return 'Dans l\'ordre';
			case 'premium.dialog.title': return 'Mise à niveau Premium';
			case 'premium.dialog.feature1': return 'Débloquer le mode séquentiel : résolvez toutes les questions dans l\'ordre en commençant par la première.';
			case 'premium.dialog.feature2': return 'Complètement sans publicité : supprimez toutes les publicités (bannières, vidéos, etc.) de l\'application.';
			case 'premium.dialog.feature3': return 'Révision par catégorie : concentrez-vous sur vos points faibles en filtrant par partie.';
			case 'premium.dialog.buy': return 'Passer au Premium';
			case 'premium.dialog.cancel': return 'Plus tard';
			case 'premium.upgradeCard.title': return 'Passer au Premium';
			case 'premium.upgradeCard.subtitle': return 'Supprimez les pubs et concentrez-vous !';
			case 'premium.upgradeCard.buy': return 'Acheter';
			case 'premium.upgradeCard.restore': return 'Restaurer l\'achat';
			case 'premium.specialOffer.title': return 'Offre à Durée Limitée';
			case 'premium.specialOffer.subtitle': return 'Premium Sans Publicité';
			case 'premium.specialOffer.desc': return 'Débloquez toutes les fonctionnalités à un prix spécial maintenant !';
			case 'premium.specialOffer.priceBefore': return '390 JPY';
			case 'premium.specialOffer.priceAfter': return '190 JPY';
			case 'premium.specialOffer.buyNow': return 'Acheter Maintenant';
			case 'premium.specialOffer.later': return 'Plus tard';
			case 'review.modal.title': return 'Sélectionner la catégorie';
			case 'review.modal.allQuestions': return 'Toutes les catégories';
			case 'review.modal.questionCount': return ({required Object count}) => '${count} questions';
			case 'review.button': return 'Réviser les faiblesses';
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

extension on _StringsJa {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'オタク・スワイプ';
			case 'home.title': return '日本語のスラングを極めよう！';
			case 'home.start': return '学習を始める';
			case 'levelSelect.title': return 'レベル選択';
			case 'levelSelect.subtitle': return 'スラングの旅に出かけよう！';
			case 'levelSelect.levels.level1.title': return 'レベル1：サバイバル';
			case 'levelSelect.levels.level1.desc': return '知っておくべき必須単語。';
			case 'levelSelect.levels.level2.title': return 'レベル2：若者言葉';
			case 'levelSelect.levels.level2.desc': return 'Z世代の間で流行っている言葉。';
			case 'levelSelect.levels.level3.title': return 'レベル3：オタク';
			case 'levelSelect.levels.level3.desc': return 'アニメ＆マンガ文化の用語。';
			case 'levelSelect.levels.level4.title': return 'レベル4：インターネット';
			case 'levelSelect.levels.level4.desc': return 'ネットスラング＆ゲームチャット。';
			case 'levelSelect.levels.level5.title': return 'レベル5：一人称・人称';
			case 'levelSelect.levels.level5.desc': return '俺、僕、私... 代名詞。';
			case 'levelSelect.levels.level6.title': return 'レベル6：ヤクザ';
			case 'levelSelect.levels.level6.desc': return '危険な裏社会のスラング。';
			case 'quiz.question': return '問題';
			case 'quiz.dontKnow': return 'わからない';
			case 'quiz.iKnowIt': return '知ってる！';
			case 'quiz.submit': return '送信';
			case 'quiz.tapToSeeMeaning': return 'タップで意味を表示';
			case 'quiz.reviewMode': return '復習モード';
			case 'quiz.result.perfect': return 'パーフェクト！';
			case 'quiz.result.awesome': return 'すごい！';
			case 'quiz.result.goodJob': return 'よくできました！';
			case 'quiz.result.listTitle': return '結果リスト';
			case 'quiz.result.backToMenu': return 'メニューへ戻る';
			case 'quiz.result.replayAll': return 'すべて解き直す';
			case 'quiz.result.reviewButton': return ({required Object count}) => '${count}単語を復習する';
			case 'quiz.locked.label': return '有料コンテンツ';
			case 'quiz.locked.desc': return 'レベル6をアンロックして続きを見よう！';
			case 'quiz.locked.button': return 'アンロックする';
			case 'quiz.locked.dialogTitle': return 'ヤクザレベルをアンロック';
			case 'quiz.locked.dialogDesc': return '全50単語をアンロックしますか？';
			case 'quiz.locked.cancel': return 'キャンセル';
			case 'quiz.mode.shuffle': return 'ランダム';
			case 'quiz.mode.sequential': return '順番通り';
			case 'premium.dialog.title': return 'プレミアムアップグレード';
			case 'premium.dialog.feature1': return '順番通りモード：最初の問題から順番に解くことができます。';
			case 'premium.dialog.feature2': return '完全広告非表示：バナー、動画などのすべての広告を削除します。';
			case 'premium.dialog.feature3': return 'カテゴリー別復習：パートごとに絞り込んで苦手な部分に集中できます。';
			case 'premium.dialog.buy': return '今すぐアップグレード';
			case 'premium.dialog.cancel': return 'あとで';
			case 'premium.upgradeCard.title': return 'プレミアムプランへ';
			case 'premium.upgradeCard.subtitle': return '広告を非表示にして集中！';
			case 'premium.upgradeCard.buy': return '購入';
			case 'premium.upgradeCard.restore': return '購入を復元する';
			case 'premium.specialOffer.title': return '期間限定特別オファー';
			case 'premium.specialOffer.subtitle': return 'プレミアム広告非表示';
			case 'premium.specialOffer.desc': return '今だけ特別価格で全機能をアンロック！';
			case 'premium.specialOffer.priceBefore': return '390円';
			case 'premium.specialOffer.priceAfter': return '190円';
			case 'premium.specialOffer.buyNow': return '今すぐ購入';
			case 'premium.specialOffer.later': return 'あとで考える';
			case 'review.modal.title': return 'カテゴリー選択';
			case 'review.modal.allQuestions': return '全カテゴリー';
			case 'review.modal.questionCount': return ({required Object count}) => '${count}問';
			case 'review.button': return '弱点復習';
			case 'settings.title': return '設定';
			case 'settings.legal': return '規約・法務';
			case 'settings.privacyPolicy': return 'プライバシーポリシー';
			case 'settings.termsOfUse': return '利用規約';
			case 'settings.tokusho': return '特定商取引法に基づく表記';
			case 'settings.services': return 'サービス';
			case 'settings.restore': return '購入の復元';
			case 'settings.restoreSubtitle': return '購入済みのレベルを復元します';
			case 'settings.restoreSuccess': return '復元処理が完了しました。';
			case 'settings.restoreError': return ({required Object error}) => '復元に失敗しました: ${error}';
			case 'settings.appInfo': return 'アプリ情報';
			case 'settings.version': return 'バージョン';
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
			case 'quiz.submit': return 'Responder';
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
			case 'quiz.mode.shuffle': return 'Aleatório';
			case 'quiz.mode.sequential': return 'Em ordem';
			case 'premium.dialog.title': return 'Upgrade Premium';
			case 'premium.dialog.feature1': return 'Desbloquear Modo Sequencial: Resolva todas as questões em ordem a partir da primeira.';
			case 'premium.dialog.feature2': return 'Totalmente Sem Anúncios: Remova todos os anúncios (banners, vídeos, etc.) do aplicativo.';
			case 'premium.dialog.feature3': return 'Revisão por Categoria: Foco em seus pontos fracos filtrando por parte.';
			case 'premium.dialog.buy': return 'Fazer Upgrade Agora';
			case 'premium.dialog.cancel': return 'Depois';
			case 'premium.upgradeCard.title': return 'Upgrade para Premium';
			case 'premium.upgradeCard.subtitle': return 'Remova anúncios e tenha foco!';
			case 'premium.upgradeCard.buy': return 'Comprar';
			case 'premium.upgradeCard.restore': return 'Restaurar compra';
			case 'premium.specialOffer.title': return 'Oferta por Tempo Limitado';
			case 'premium.specialOffer.subtitle': return 'Premium Sem Anúncios';
			case 'premium.specialOffer.desc': return 'Desbloqueie todos os recursos com um preço especial agora!';
			case 'premium.specialOffer.priceBefore': return '390 JPY';
			case 'premium.specialOffer.priceAfter': return '190 JPY';
			case 'premium.specialOffer.buyNow': return 'Comprar Agora';
			case 'premium.specialOffer.later': return 'Depois';
			case 'review.modal.title': return 'Selecionar Categoria';
			case 'review.modal.allQuestions': return 'Todas as Categorias';
			case 'review.modal.questionCount': return ({required Object count}) => '${count} questões';
			case 'review.button': return 'Revisar Fraquezas';
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
