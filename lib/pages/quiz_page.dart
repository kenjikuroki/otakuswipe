// lib/pages/quiz_page.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quiz_provider.dart';
import '../models/slang_item.dart';
import '../services/purchase_manager.dart';
import '../i18n/strings.g.dart';
import '../ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/quiz_card.dart';
import '../widgets/ad_placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // スワイプ操作をボタンから操るためのコントローラー
  
  int _currentIndex = 0;
  bool _showFeedback = false; // クイズのフィードバック（解説）を表示しているか
  List<String> _currentChoices = []; // 現在の選択肢
  int? _selectedChoiceIndex; // ユーザーが選択したインデックス
  int _replayCount = 0; // リプレイ時にCardSwiperを再構築するためのキー用
  bool _showNextButton = false; // 「次へ」ボタンを表示するか（遅延用）

  // 広告用の変数を追加
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  // ▼▼▼ 追加: 各問題の結果を保存するリスト (true: 知ってる, false: 知らない) ▼▼▼
  List<bool> _quizResults = [];

  // 背景色 (フラッシュ効果用) - デフォルトは透明にしてグラデーションを表示
  Color _backgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // 画面が開いたらデータを読み込む (LevelSelectPageで読み込み済みのため削除)
    // Future.microtask(() =>
    //     Provider.of<QuizProvider>(context, listen: false).loadSlangData());

    // バナー広告を読み込む
    _loadBannerAd();

    // ▼▼▼ 追加: インタースティシャル広告も事前に読み込んでおく ▼▼▼
    AdHelper.loadInterstitialAd();

    // ▼▼▼ 追加: 画面描画後にプロバイダーからリスト長を取得し、結果リストを初期化 ▼▼▼
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      setState(() {
        // 初期値はすべて false (未回答/知らない) で埋める
        _quizResults = List.filled(provider.slangList.length, false);
        _generateChoicesForCurrentIndex();
      });
    });
  }

  // 現在の問題に対する選択肢を生成する
  void _generateChoicesForCurrentIndex() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    if (_currentIndex >= provider.slangList.length) return;

    final correctItem = provider.slangList[_currentIndex];
    
    // ▼▼▼ 修正: カテゴリに応じた適切な「間違い」のプールを選択 ▼▼▼
    final isPersona = provider.isPersonaItem(correctItem);
    final allItems = isPersona 
        ? provider.getPersonaSlangItems() 
        : provider.getNonPersonaSlangItems();

    List<String> choices = [correctItem.meaning];
    
    // 1. 自分自身以外の単語を「間違い候補」としてシャッフル
    List<SlangItem> distractors = allItems.where((item) => item.word != correctItem.word).toList();
    distractors.shuffle();
    
    // 2. 重複しない意味を持つものを3つ選ぶ
    for (var item in distractors) {
      if (choices.length >= 4) break;
      if (!choices.contains(item.meaning)) {
        choices.add(item.meaning);
      }
    }
    
    // 3. (万が一足りない場合の保険)
    while (choices.length < 4) {
      choices.add("--- ${choices.length} ---");
    }

    choices.shuffle();
    _currentChoices = choices;
    _selectedChoiceIndex = null;
    _showFeedback = false;
    _showNextButton = false; // リセット
  }

  void _loadBannerAd() {
    // プレロードされたバナーがあればそれを使う、なければ新規作成
    _bannerAd = AdHelper.getQuizBanner(
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    // 取得した時点で既にロード済み（プレロード成功）なら即座に表示フラグを立てる
    if (_bannerAd!.responseInfo != null) {
      _isBannerAdReady = true;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // 広告破棄
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final slangList = provider.slangList;
    final screenHeight = MediaQuery.of(context).size.height;
    // iPhone 8 is 667 logical pixels high. Use 700 as a safe threshold for "small screen".
    final isSmallScreen = screenHeight < 750; 

    const brandDarkBg = Color(0xFF2D0B5A);
    const foregroundColor = Color(0xFF2D0B5A); // Changed to deep purple for light theme
    final levelColor = provider.currentLevelColor;
    
    const bgColor = Colors.white;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF7F2FF), // Very Thin Purple
              Color(0xFFFBF8FF), // Light Lavender White
              Color(0xFFF2E9FF), // Soft Purple
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
          // 背景フラッシュ用のアニメーションコンテナ
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: _backgroundColor,
            child: const SizedBox.expand(),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // --- カスタムヘッダー ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      // 1. 戻るボタン (iOSスタイル)
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, color: foregroundColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              provider.currentLevelTitle,
                              style: GoogleFonts.outfit(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold, 
                                color: const Color(0xFF2D0B5A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D0B5A).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: slangList.isEmpty ? 0 : (_currentIndex + 1) / slangList.length,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    levelColor == Colors.black ? const Color(0xFFD400FF) : levelColor
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48), // バランス用余白 (戻るボタンの幅)
                    ],
                  ),
                ),

                // --- メインコンテンツ (カード) ---
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: slangList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // 余白を24->12に削減
                                  child: _buildQuizContent(slangList, provider),
                                ),
                              ),

                              // 3. 広告エリア (プレミアムなら非表示、Yakuzaレベル以外の場合のみ表示)
                              if (!provider.isYakuzaUnlocked && provider.currentLevelId != 'level6_yakuza') ...[
                                if (_isBannerAdReady && _bannerAd != null)
                                  SizedBox(
                                    width: _bannerAd!.size.width.toDouble(),
                                    height: _bannerAd!.size.height.toDouble(),
                                    child: AdWidget(ad: _bannerAd!),
                                  )
                                else
                                  AdPlaceholder(adSize: AdSize.banner), // 読み込み中はキラキラ,
                                const SizedBox(height: 8), // 下に少し余白
                              ] else ...[
                                 const SizedBox(height: 12), // 広告がない場合の余白
                              ],
                            ],
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  // クイズのメインコンテンツ（カード + 4択 または 解説）
  Widget _buildQuizContent(List<SlangItem> slangList, QuizProvider provider) {
    if (slangList.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_currentIndex >= slangList.length) return const SizedBox.shrink();

    final item = slangList[_currentIndex];

    // ロック判定 (Yakuzaレベル用)
    final isLockedItem = (provider.currentLevelId == 'level6_yakuza' && !provider.isYakuzaUnlocked && _currentIndex >= 3);

    return Column(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // スライド or フェード or 回転（フリップ）
              // ここではシンプルにフェード + スケール
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation.drive(Tween(begin: 0.95, end: 1.0)),
                  child: child,
                ),
              );
            },
            child: _showFeedback 
              ? _buildFeedbackCard(item, key: ValueKey("feedback_$_currentIndex"))
              : _buildQuestionCard(item, isLockedItem, key: ValueKey("question_$_currentIndex")),
          ),
        ),
        if (isLockedItem && !_showFeedback)
           Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () => _showPurchaseDialogInQuiz(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(t.quiz.locked.button),
            ),
          ),
      ],
    );
  }

  // 問題カード（単語 + 選択肢）
  Widget _buildQuestionCard(SlangItem item, bool isLocked, {Key? key}) {
     return Container(
       key: key,
       width: double.infinity,
       padding: const EdgeInsets.all(24),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(32),
         boxShadow: [
           BoxShadow(
             color: const Color(0xFF2D0B5A).withOpacity(0.08),
             blurRadius: 30,
             offset: const Offset(0, 10),
           ),
         ],
       ),
       child: Stack(
         children: [
           Center(
             child: SingleChildScrollView(
               physics: const BouncingScrollPhysics(),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const SizedBox(height: 10),
                   // 単語
                   Text(
                     item.word,
                     style: GoogleFonts.outfit(
                       fontSize: 48, 
                       fontWeight: FontWeight.w900, 
                       color: const Color(0xFF2D0B5A),
                     ),
                     textAlign: TextAlign.center,
                   ),
                   if (item.romaji != null && item.romaji!.isNotEmpty)
                     Text(
                       item.romaji!,
                       style: GoogleFonts.outfit(
                         fontSize: 18, 
                         color: const Color(0xFF2D0B5A).withOpacity(0.4),
                         letterSpacing: 2,
                         fontWeight: FontWeight.w400,
                       ),
                     ),
                   const SizedBox(height: 40),
                       if (!isLocked) ...[
                         _buildChoiceButtons(item),
                         const SizedBox(height: 30),
                         Visibility(
                           visible: _selectedChoiceIndex != null,
                           maintainSize: true,
                           maintainAnimation: true,
                           maintainState: true,
                           child: ElevatedButton(
                             onPressed: () => _submitAnswer(item),
                             style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0xFF2D0B5A),
                               foregroundColor: Colors.white,
                               padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                               elevation: 4,
                               shadowColor: const Color(0xFF2D0B5A).withOpacity(0.3),
                             ),
                             child: Text(
                               t.quiz.submit, 
                               style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)
                             ),
                           ),
                         ),
                       ],
                       const SizedBox(height: 10),
                     ],
                   ),
                 ),
               ),
                if (isLocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_rounded, size: 80, color: Color(0xFF2D0B5A)),
                            const SizedBox(height: 16),
                            Text(
                              t.quiz.locked.label, 
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold, 
                                fontSize: 22,
                                color: const Color(0xFF2D0B5A),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
  }

  Widget _buildFeedbackCard(SlangItem item, {Key? key}) {
    final isCorrect = _selectedChoiceIndex != null && _currentChoices[_selectedChoiceIndex!] == item.meaning;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        key: key,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F2FF),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D0B5A).withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 正解・不正解表示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isCorrect ? "CORRECT" : "WRONG",
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 画像
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item.imagePath,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    height: 160,
                    color: const Color(0xFF2D0B5A).withOpacity(0.05),
                    child: const Icon(Icons.image_rounded, size: 64, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 意味
              Text(
                item.meaning,
                style: GoogleFonts.outfit(
                  fontSize: 26, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF2D0B5A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // 解説
              Text(
                item.explanation,
                style: GoogleFonts.outfit(
                  fontSize: 15, 
                  height: 1.5,
                  color: const Color(0xFF2D0B5A).withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              if (item.example != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D0B5A).withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Example: ${item.example}",
                    style: GoogleFonts.outfit(
                      fontSize: 14, 
                      fontStyle: FontStyle.italic, 
                      color: const Color(0xFF2D0B5A).withOpacity(0.5),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              // 次へボタン (カード内に移動、タイマーで表示)
              Visibility(
                visible: _showNextButton,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: _buildNextButton(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButtons(SlangItem item) {
    return Column(
      children: List.generate(_currentChoices.length, (index) {
        final choice = _currentChoices[index];
        final isSelected = _selectedChoiceIndex == index;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChoiceIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2D0B5A).withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2D0B5A) : const Color(0xFF2D0B5A).withOpacity(0.12),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? const Color(0xFF2D0B5A).withOpacity(0.05) : Colors.transparent,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2D0B5A) : const Color(0xFF2D0B5A).withOpacity(0.2),
                          width: 2,
                        ),
                        color: isSelected ? const Color(0xFF2D0B5A) : Colors.transparent,
                      ),
                      child: isSelected 
                        ? const Center(child: Icon(Icons.check_rounded, size: 14, color: Colors.white))
                        : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        choice,
                        style: GoogleFonts.outfit(
                          fontSize: 16, 
                          color: const Color(0xFF2D0B5A).withOpacity(isSelected ? 1.0 : 0.7),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _submitAnswer(SlangItem item) {
    if (_selectedChoiceIndex == null) return;
    final isCorrect = (_currentChoices[_selectedChoiceIndex!] == item.meaning);
    setState(() {
      _showFeedback = true;
      _quizResults[_currentIndex] = isCorrect;
    });

    // 苦手単語の永続化記録 (間違えたら追加、合ってたら削除)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      provider.toggleWeakWord(item.word, !isCorrect);
    });

    // 0.8秒後に「次へ」ボタンを表示
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showNextButton = true;
        });
      }
    });

    // 背景をピカッとする
    if (_currentChoices[_selectedChoiceIndex!] == item.meaning) {
       _flashBackground(Colors.green.withOpacity(0.3));
    } else {
       _flashBackground(Colors.red.withOpacity(0.3));
    }
  }

  // 次へボタン
  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _goToNextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: const Text("NEXT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  void _onChoiceSelected(int index, SlangItem item) {
    // 従来の動作は削除、または _submitAnswer に統合
  }

  void _goToNextQuestion() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    if (_currentIndex < provider.slangList.length - 1) {
      setState(() {
        _currentIndex++;
        _generateChoicesForCurrentIndex();
      });
    } else {
      // 全て終わった場合
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    if (provider.isYakuzaUnlocked || provider.currentLevelId == 'level6_yakuza') {
       _showCompletionDialogWithReview();
    } else {
      AdHelper.showInterstitialAd(context: context, onComplete: () {
        _showCompletionDialogWithReview();
      });
    }
  }

  // 背景を一時的に変更して戻すアニメーション処理
  void _flashBackground(Color flashColor) {
    setState(() {
      _backgroundColor = flashColor;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _backgroundColor = Colors.transparent;
        });
      }
    });
  }

  // ▼▼▼ 修正: 結果ダイアログの表示メソッド ▼▼▼
  Future<void> _showCompletionDialogWithReview() async {
    final provider = Provider.of<QuizProvider>(context, listen: false);

    // ▼▼▼ 修正: レビューは「3回クリアした後」に1回だけ出す (頻繁に出さない) ▼▼▼
    // ※ 本番では「高評価の時のみ」などの条件を加えるのが一般的
    try {
      final prefs = await SharedPreferences.getInstance();
      const keyReviewCount = 'review_prompt_count';
      int currentCount = prefs.getInt(keyReviewCount) ?? 0;
      currentCount++;
      await prefs.setInt(keyReviewCount, currentCount);

      // 3回目のプレイ完了時のみレビューを促す
      if (currentCount == 3) {
        final InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
        }
      }
    } catch (e) {
      debugPrint("Review check failed: $e");
    }

    final total = provider.slangList.length;
    final knownCount = _quizResults.where((result) => result == true).length;

    final unknownCount = total - knownCount;

    // スコアに応じたタイトル（絵文字は削除）
    String title;
    if (knownCount == total && total > 0) {
      title = t.quiz.result.perfect;
    } else if (knownCount >= total * 0.8 && total > 0) {
      title = t.quiz.result.awesome;
    } else {
      title = t.quiz.result.goodJob;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF7F2FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        // タイトル部分 (スコアのみ表示)
        title: Column(
          children: [
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: const Color(0xFF2D0B5A)), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text("$knownCount / $total", style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF2D0B5A))),
          ],
        ),
        // コンテンツ部分 (全問リスト表示)
        content: SizedBox(
          // ダイアログの幅を確保
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  t.quiz.result.listTitle,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: const Color(0xFF2D0B5A).withOpacity(0.4)),
                ),
              ),
              Divider(color: const Color(0xFF2D0B5A).withOpacity(0.1), height: 1),
              // ▼▼▼ ここが変更点: 全問をリスト表示 ▼▼▼
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.slangList.length,
                  itemBuilder: (context, index) {
                    final item = provider.slangList[index];
                    final isKnown = _quizResults[index];

                    return Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: const Color(0xFF2D0B5A).withOpacity(0.05), width: 1)),
                      ),
                      child: ListTile(
                        visualDensity: VisualDensity.compact, // リストの間隔を詰める
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        // 左側のアイコン (✅ または ❌)
                        leading: Icon(
                          isKnown ? Icons.check_circle : Icons.cancel,
                          color: isKnown ? Colors.green : Colors.red,
                        ),
                        // 単語
                        title: Text(
                          item.word,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: isKnown ? const Color(0xFF2D0B5A) : const Color(0xFFF44336), // 間違えた単語は赤
                          ),
                        ),
                        // ローマ字を表示 (あれば)
                        subtitle: (item.romaji != null && item.romaji!.isNotEmpty)
                            ? Text(
                                item.romaji!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              )
                            : null,
                        // 右側のアイコン (目のマークは削除)
                        trailing: null,
                        // タップ時の動作 (正解でも不正解でも詳細表示)
                        onTap: () {
                           _showReviewCardDialog(item);
                        },
                      ),
                    );
                  },
                ),
              ),
              Divider(color: Colors.brown[200], height: 1),
            ],
          ),
        ),
        // アクションボタン
        actions: [
          if (unknownCount > 0)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _startReviewSession(provider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.loop),
              label: Text(t.quiz.result.reviewButton(count: unknownCount)), // 間違えた数も表示
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                 child: Text(t.quiz.result.backToMenu, style: GoogleFonts.outfit(color: const Color(0xFF2D0B5A).withOpacity(0.4))),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 0;
                    _quizResults = List.filled(total, false);
                    _replayCount++; // CardSwiperを強制リセット
                    _generateChoicesForCurrentIndex();
                  });
                },
                child: Text(t.quiz.result.replayAll, style: GoogleFonts.outfit(color: const Color(0xFF2D0B5A), fontWeight: FontWeight.w900)),
              ),
            ],
          )
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsOverflowButtonSpacing: 10,
        // ダイアログ全体の高さを少し広げる設定
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      ),
    );
  }

  // ▼▼▼ 修正: 単語カードをポップアップ表示するメソッド (表裏反転機能付き) ▼▼▼
  void _showReviewCardDialog(SlangItem item) {
    // 初期状態は「裏面（意味）」を表示
    bool isFlippedState = true;

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder を使ってダイアログ内で状態 (isFlippedState) を管理
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 500,
                child: Stack(
                  children: [
                    // カード全体をタップ可能にする
                    GestureDetector(
                      onTap: () {
                        // タップで表裏を反転させる
                        setStateInDialog(() {
                          isFlippedState = !isFlippedState;
                        });
                      },
                      // 現在の状態 (isFlippedState) に基づいてカードを表示
                      child: QuizCard(slangItem: item, isFlipped: isFlippedState),
                    ),
                    // 閉じるボタン
                    Positioned(
                      right: 10,
                      top: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ▼▼▼ 修正: 復習セッションを開始するメソッド ▼▼▼
  void _startReviewSession(QuizProvider provider) {
    // 「知らない(false)」と記録された単語だけのリストを作成
    List<SlangItem> reviewList = [];
    for (int i = 0; i < provider.slangList.length; i++) {
        // 念のため範囲チェック
      if (i < _quizResults.length && _quizResults[i] == false) {
        reviewList.add(provider.slangList[i]);
      }
    }

    if (reviewList.isEmpty) return; // エラー回避

    // プロバイダーに復習用リストをセット
    provider.setReviewList(reviewList);

    // 画面遷移せずに状態だけリセットして再開する
    // これにより AdWidget の再生成エラーを防げる
    setState(() {
      _currentIndex = 0;
      _quizResults = List.filled(reviewList.length, false);
      _showFeedback = false;
      _showNextButton = false; // リセット
      _replayCount++;
      _generateChoicesForCurrentIndex();
    });
  }

  // クイズ画面内での課金ダイアログ
  void _showPurchaseDialogInQuiz(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
         title: Text(t.quiz.locked.dialogTitle),
         content: Text(t.quiz.locked.dialogDesc),
         actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.quiz.locked.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                 Navigator.pop(context); // Close "Unlock" dialog
                 try {
                   // 購入処理開始
                   await Provider.of<PurchaseManager>(context, listen: false).buyYakuza();
                 } catch (e) {
                   debugPrint("Purchase start error: $e");
                   // エラーダイアログを表示
                   if (context.mounted) {
                     showDialog(
                       context: context,
                       builder: (ctx) => AlertDialog(
                         title: const Text("Purchase Failed"), // エラー系は一旦英語のままか、必要ならローカライズ追加（今回はスコープ外）
                         content: Text(e.toString().replaceAll("Exception: ", "")),
                         actions: [
                           TextButton(
                             onPressed: () => Navigator.pop(ctx),
                             child: const Text("OK"),
                           ),
                         ],
                       ),
                     );
                   }
                 }
              }, 
              child: Text(t.quiz.locked.button),
            )
         ],
      )
    );
  }
}
