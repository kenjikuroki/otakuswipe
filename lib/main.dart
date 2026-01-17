import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


import 'pages/level_select_page.dart';
import 'pages/quiz_page.dart';
import 'providers/quiz_provider.dart';
import 'services/purchase_service.dart'; // 追加
import 'package:flutter_localizations/flutter_localizations.dart'; // localizationsDelegates用
// ignore: unused_import
import 'i18n/strings.g.dart'; // slang生成ファイル

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale(); // デバイスの言語設定を初期化
  
  // Removed MobileAds.instance.initialize() from here. Moved to LevelSelectPage.

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PurchaseService()), // 追加
        ChangeNotifierProxyProvider<PurchaseService, QuizProvider>(
          create: (_) => QuizProvider(),
          update: (_, purchase, quiz) => quiz!..updatePurchaseService(purchase),
        ),
      ],
      child: const MyApp(),
    ),
  );
}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    // デバイスの言語が変わった時にslangの設定を更新する
    LocaleSettings.useDeviceLocale();
    debugPrint('DEBUG: Locale changed to $locales');
  }

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          final locale = TranslationProvider.of(context).flutterLocale;
          debugPrint('DEBUG: Current detected locale: $locale');
          return MaterialApp(
            title: 'Otaku Swipe', // ここも t.appTitle にしても良いが、MaterialAppのtitleはシステム用なので固定でも可。一旦そのままか、後でOnGenerateTitleにする。
            onGenerateTitle: (context) => t.appTitle,
            debugShowCheckedModeBanner: false,
            locale: TranslationProvider.of(context).flutterLocale, // slang設定
            supportedLocales: AppLocaleUtils.supportedLocales, // slang設定
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF9F9F9),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 1,
              ),
              textTheme: GoogleFonts.mPlusRounded1cTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: const LevelSelectPage(),
          );
        }
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Otaku Swipe')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Master Japanese Slang!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const QuizPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text("Start Learning"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
