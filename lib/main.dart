import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'widgets/ad_banner.dart';
import 'utils/ad_manager.dart';
import 'models/slang_item.dart';
import 'widgets/quiz_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 同意フローの初期化 (完了を待つ)
  await AdManager.instance.initializeConsent();
  
  // 2. Mobile Ads SDKの初期化
  MobileAds.instance.initialize();
  
  // アプリ起動時にHome用の広告を先行読み込み
  AdManager.instance.preloadAd('home');
  
  // 画面の向きを縦に固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const MyApp());
}

// -----------------------------------------------------------------------------
// 1. Data Models & Helpers
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// 1. Data Models & Helpers
// -----------------------------------------------------------------------------

class QuizData {
  static SlangData? _data;

  static Future<void> load() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/slang_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _data = SlangData.fromJson(jsonData);
    } catch (e) {
      debugPrint("Error loading slang data: $e");
      // Fallback empty data to prevent crash
      _data = SlangData(
        level1: [],
        level2: [],
        level3: [],
        level4: [],
        bonus: [],
      );
    }
  }

  static List<SlangItem> get level1 => _data?.level1 ?? [];
  static List<SlangItem> get level2 => _data?.level2 ?? [];
  static List<SlangItem> get level3 => _data?.level3 ?? [];
  static List<SlangItem> get level4 => _data?.level4 ?? [];
  static List<SlangItem> get bonus => _data?.bonus ?? [];

  static List<SlangItem> getItemsFromWords(List<String> words) {
    if (_data == null) return [];
    
    final allItems = [
      ...level1,
      ...level2,
      ...level3,
      ...level4,
      ...bonus,
    ];
    return allItems.where((item) => words.contains(item.word)).toList();
  }
}

class PrefsHelper {
  static const String _keyWeakWords = 'weak_words';
  static const String _keyAdCounter = 'ad_counter';

  // --- Weak Words Management ---
  static Future<void> addWeakWords(List<String> words) async {
    if (words.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final List<String> current = prefs.getStringList(_keyWeakWords) ?? [];
    
    bool changed = false;
    for (final w in words) {
      if (!current.contains(w)) {
        current.add(w);
        changed = true;
      }
    }
    
    if (changed) {
      await prefs.setStringList(_keyWeakWords, current);
    }
  }

  static Future<void> removeWeakWords(List<String> words) async {
    if (words.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final List<String> current = prefs.getStringList(_keyWeakWords) ?? [];
    
    bool changed = false;
    for (final w in words) {
       if (current.remove(w)) {
         changed = true;
       }
    }
    
    if (changed) {
      await prefs.setStringList(_keyWeakWords, current);
    }
  }

  static Future<List<String>> getWeakWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyWeakWords) ?? [];
  }

  // --- High Score Management ---
  static Future<void> saveHighScore(String key, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHigh = prefs.getInt(key) ?? 0;
    if (score > currentHigh) {
      await prefs.setInt(key, score);
    }
  }

  static Future<int> getHighScore(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }
  
  // --- Ad Management ---
  static Future<bool> shouldShowInterstitial() async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(_keyAdCounter) ?? 0;
    counter++; 
    await prefs.setInt(_keyAdCounter, counter);
    
    // 3回に1回表示
    return (counter % 3 == 0);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '乙4 爆速クイズ',
      debugShowCheckedModeBanner: false,
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
      home: const HomePage(),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. Home Page
// -----------------------------------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _highScore1 = 0;
  int _highScore2 = 0;
  int _highScore3 = 0;
  int _highScore4 = 0;
  int _weaknessCount = 0;
  bool _isLoading = true; // ローディング状態

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // データ初期ロード
    await QuizData.load();
    await _loadUserData();
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadUserData() async {
    final s1 = await PrefsHelper.getHighScore('highscore_level1');
    final s2 = await PrefsHelper.getHighScore('highscore_level2');
    final s3 = await PrefsHelper.getHighScore('highscore_level3');
    final s4 = await PrefsHelper.getHighScore('highscore_level4');
    final weakList = await PrefsHelper.getWeakWords();

    if (mounted) {
      setState(() {
        _highScore1 = s1;
        _highScore2 = s2;
        _highScore3 = s3;
        _highScore4 = s4;
        _weaknessCount = weakList.length;
      });
    }
  }

  void _startQuiz(BuildContext context, List<SlangItem> itemList, String categoryKey, {bool isRandom10 = true}) async {
    List<SlangItem> itemsToUse = List<SlangItem>.from(itemList);
    
    if (isRandom10) {
      itemsToUse.shuffle();
      if (itemsToUse.length > 10) {
        itemsToUse = itemsToUse.take(10).toList();
      }
    } else {
      itemsToUse.shuffle();
    }
    
    // クイズ開始時に結果画面用の広告とインタースティシャル広告を先行読み込み
    AdManager.instance.preloadAd('result');
    AdManager.instance.preloadInterstitial();
    
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizPage(
          items: itemsToUse,
          categoryKey: categoryKey,
          totalQuestions: isRandom10 ? 10 : itemsToUse.length, // totalQuestionsを渡す
        ),
      ),
    );
    if (!mounted) return;
    _loadUserData(); // 戻ってきたらデータ更新
  }

  void _startWeaknessReview(BuildContext context) async {
    // Navigatorを先に取得してGap回避
    final navigator = Navigator.of(context);
    
    final weakWords = await PrefsHelper.getWeakWords();
    if (!mounted) return;
    if (weakWords.isEmpty) return;

    final weakItems = QuizData.getItemsFromWords(weakWords);
    
    // 復習モード開始
    AdManager.instance.preloadAd('result');
    AdManager.instance.preloadInterstitial();

    await navigator.push(
      MaterialPageRoute(
        builder: (context) => QuizPage(
          items: weakItems,
          isWeaknessReview: true, // 復習モードフラグ
          totalQuestions: weakItems.length,
        ),
      ),
    );
    if (!mounted) return;
    _loadUserData(); // 戻ってきたらデータ更新
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // タイトルエリア
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            "OTAKU",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              color: Colors.pinkAccent,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            "Swipe Slang",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    const Text(
                      "Choose Level",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    
                    _CategoryButton(
                      title: "Level 1: Survival",
                      color: Colors.orange,
                      highScore: _highScore1,
                      onTap: () => _startQuiz(context, QuizData.level1, 'highscore_level1'),
                    ),
                    const SizedBox(height: 16),
                    
                    _CategoryButton(
                      title: "Level 2: Otaku",
                      color: Colors.blue,
                      highScore: _highScore2,
                      onTap: () => _startQuiz(context, QuizData.level2, 'highscore_level2'),
                    ),
                    const SizedBox(height: 16),
                    
                    _CategoryButton(
                      title: "Level 3: Internet",
                      color: Colors.green,
                      highScore: _highScore3,
                      onTap: () => _startQuiz(context, QuizData.level3, 'highscore_level3'),
                    ),
                     const SizedBox(height: 16),
                    
                    _CategoryButton(
                      title: "Level 4: Youth",
                      color: Colors.purple,
                      highScore: _highScore4,
                      onTap: () => _startQuiz(context, QuizData.level4, 'highscore_level4'),
                    ),
                  ],
                ),
              ),
            ),
            
            // 苦手克服ボタン (常に表示、0問ならDisabled)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _weaknessCount > 0 ? () => _startWeaknessReview(context) : null,
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: Text("Review Weak Words ($_weaknessCount)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300], // Disabled時の背景色
                    disabledForegroundColor: Colors.grey[500], // Disabled時の文字色
                    elevation: _weaknessCount > 0 ? 4 : 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            
            // バナー広告
            const AdBanner(adKey: 'home', keepAlive: true),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String title;
  final Color color;
  final int highScore;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.title,
    required this.color,
    required this.highScore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // ハイスコア表示用に少し高く調整
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color.withValues(alpha: 0.3), width: 2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.menu_book, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ハイスコア: $highScore点",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. Quiz Page
// -----------------------------------------------------------------------------

class QuizPage extends StatefulWidget {
  final List<SlangItem> items;
  final String? categoryKey; // ハイスコア保存用Key (復習モードの時はnull)
  final bool isWeaknessReview; // 復習モードかどうか
  final int totalQuestions; // 全問題数（分母）

  const QuizPage({
    super.key,
    required this.items,
    this.categoryKey,
    this.isWeaknessReview = false,
    required this.totalQuestions,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final AppinioSwiperController controller = AppinioSwiperController();
  
  // スコア・履歴管理
  int _score = 0;
  int _currentIndex = 1; // 現在の問題番号
  final List<SlangItem> _incorrectItems = [];
  final List<SlangItem> _correctItemsInReview = []; // 復習モードで正解した問題
  final List<Map<String, dynamic>> _answerHistory = [];

  // 背景色のアニメーション用
  Color _backgroundColor = const Color(0xFFF9F9F9);

  void _handleSwipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    if (activity is Swipe) {
      final item = widget.items[previousIndex];
      // 右スワイプ = "知ってる/覚えた" (Positive/Correct)
      // 左スワイプ = "知らない/忘れた" (Negative/Incorrect)
      bool isKnown = (activity.direction == AxisDirection.right);
      
      // スラングアプリでは「正解/不正解」ではなく「知ってる/知らない」の自己申告に近いが、
      // クイズ形式にするなら「意味を知ってたか？」を問う。
      // 右(知ってる)なら正解扱い、左(知らない)なら不正解（復習リスト入り）扱いにする。

      _answerHistory.add({
        'item': item,
        'result': isKnown,
      });

      setState(() {
        if (isKnown) {
          _score++;
          _backgroundColor = Colors.green.withValues(alpha: 0.2);
          HapticFeedback.lightImpact();
          
          if (widget.isWeaknessReview) {
            _correctItemsInReview.add(item);
          }
        } else {
          _backgroundColor = Colors.red.withValues(alpha: 0.2);
          _incorrectItems.add(item);
          HapticFeedback.heavyImpact();
        }
      });

      // 0.2秒後に背景を戻す
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _backgroundColor = const Color(0xFFF9F9F9);
          });
        }
      });

      // SnackBar
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 600),
          content: Text(
            isKnown ? "NICE! 👍" : "Learning! 📝",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: isKnown ? Colors.green : Colors.orange,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.5,
            left: 50,
            right: 50,
          ),
        ),
      );

      setState(() {
         // インデックスを進める（上限キャップ）
        if (_currentIndex < widget.totalQuestions) {
          _currentIndex++;
        }
      });

      // 全問終了チェック
      if (previousIndex == widget.items.length - 1) {
        _finishQuiz();
      }
    }
  }

  Future<void> _finishQuiz() async {
    // データの永続化処理
    
    // 1. ハイスコア保存
    if (widget.categoryKey != null) {
      await PrefsHelper.saveHighScore(widget.categoryKey!, _score);
    }

    // 2. 苦手リストへの追加
    if (_incorrectItems.isNotEmpty) {
      final incorrectWords = _incorrectItems.map((q) => q.word).toList();
      await PrefsHelper.addWeakWords(incorrectWords);
    }

    // 3. 復習モードの場合、正解した問題を苦手リストから削除
    if (widget.isWeaknessReview && _correctItemsInReview.isNotEmpty) {
      final correctWords = _correctItemsInReview.map((q) => q.word).toList();
      await PrefsHelper.removeWeakWords(correctWords);
    }
    
    // 画面遷移
    if (mounted) {
      final shouldShow = await PrefsHelper.shouldShowInterstitial();
      
      if (shouldShow) {
        AdManager.instance.showInterstitial(
          onComplete: () {
            if (mounted) {
              _navigateToResult();
            }
          },
        );
      } else {
        _navigateToResult();
      }
    }
  }

  void _navigateToResult() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          score: _score,
          total: widget.items.length,
          history: _answerHistory,
          incorrectItems: _incorrectItems,
          // originalItems: widget.items, // 必要あれば
          categoryKey: widget.categoryKey,
          isWeaknessReview: widget.isWeaknessReview,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe to Learn', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true, 
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              // プログレスバーエリア
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Q.$_currentIndex",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "$_currentIndex / ${widget.totalQuestions}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _currentIndex / widget.totalQuestions,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AppinioSwiper(
                  controller: controller,
                  cardCount: widget.items.length,
                  loop: false,
                  backgroundCardCount: 2,
                  swipeOptions: const SwipeOptions.symmetric(horizontal: true, vertical: false),
                  onSwipeEnd: _handleSwipeEnd,
                  cardBuilder: (context, index) {
                    return QuizCard(slangItem: widget.items[index]);
                  },
                ),
              ),
              // 説明テキスト
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("← Missed", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text("Got it! →", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton.icon(
                      onPressed: () {
                        controller.unswipe();
                        setState(() {
                          if (_currentIndex > 1) {
                            _currentIndex--;
                          }
                          // 履歴とスコアのロールバック
                          if (_answerHistory.isNotEmpty) {
                            final last = _answerHistory.removeLast();
                            final bool wasCorrect = last['result'];
                            final SlangItem item = last['item'];
                            
                            if (wasCorrect) {
                              _score--;
                              if (widget.isWeaknessReview) {
                                _correctItemsInReview.remove(item);
                              }
                            } else {
                              _incorrectItems.remove(item);
                            }
                          }
                        });
                      },
                      icon: const Icon(Icons.undo),
                      label: const Text("Undo"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 2,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// -----------------------------------------------------------------------------
// 4. Result Page
// -----------------------------------------------------------------------------

class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  final List<Map<String, dynamic>> history;
  final List<SlangItem> incorrectItems;
  // final List<SlangItem> originalItems; // 必要なければ削除
  final String? categoryKey;
  final bool isWeaknessReview;

  const ResultPage({
    super.key,
    required this.score,
    required this.total,
    required this.history,
    required this.incorrectItems,
    // required this.originalItems,
    this.categoryKey,
    required this.isWeaknessReview,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        centerTitle: true,
        automaticallyImplyLeading: false, 
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Learned",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  "$score / $total",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.orange,
                  ),
                ),
                // 10問テストの判定コメント
                if (!isWeaknessReview && total >= 10)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      score >= 8 ? "You're a Slang Master!" : "Wait, maji?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: score >= 8 ? Colors.green : Colors.red,
                      ),
                    ),
                  )
                else if (score == total)
                   const Text(
                    "PERFECT! 🎉",
                    style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                
                if (isWeaknessReview && score > 0)
                   Padding(
                     padding: const EdgeInsets.only(top: 8.0),
                     child: Text(
                      "Mastered $score weak words!",
                      style: const TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                                       ),
                   ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final SlangItem slang = item['item'];
                final bool isKnown = item['result'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              isKnown ? Icons.check_circle : Icons.cancel,
                              color: isKnown ? Colors.green : Colors.red,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    slang.word,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  Text(
                                    slang.meaning,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "💡 ${slang.explanation}",
                            style: TextStyle(color: Colors.blueGrey[700], fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // バナー広告
          const AdBanner(adKey: 'result'),
          
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (incorrectItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => QuizPage(
                                  items: incorrectItems,
                                  isWeaknessReview: true, 
                                  totalQuestions: incorrectItems.length, // 残り全問
                                ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Review Missed Words"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isWeaknessReview) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        return;
                      }
                      // 通常モードならホームへ
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Back to Home"),
                  ),
                ),
                
                /* 
                   // もし「もう一度やる」ボタンが必要ならここに追加するが、
                   // シンプルにするため一旦削除またはコメントアウト
                if (!isWeaknessReview) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // リトライ機能の実装が必要
                    },
                    child: const Text("Retry", style: TextStyle(color: Colors.grey)),
                  ),
                ], 
                */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
