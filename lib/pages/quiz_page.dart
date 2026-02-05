// lib/pages/quiz_page.dart

import 'dart:ui'; // 追加
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/quiz_provider.dart';
import '../widgets/quiz_card.dart';
import '../ad_helper.dart';
import '../widgets/ad_placeholder.dart';
import '../models/slang_item.dart';
import '../services/purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 追加
import 'package:in_app_review/in_app_review.dart'; // 追加
import '../i18n/strings.g.dart'; // 追加

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

  // 広告用の変数を追加
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  // ▼▼▼ 追加: 各問題の結果を保存するリスト (true: 知ってる, false: 知らない) ▼▼▼
  List<bool> _quizResults = [];

  // 背景色 (フラッシュ効果用)
  Color _backgroundColor = Colors.grey[100]!;

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
    final allItems = provider.slangList;

    List<String> choices = [correctItem.meaning];
    
    // 他の単語から選択肢を3つ選ぶ
    List<SlangItem> others = allItems.where((item) => item.word != correctItem.word).toList();
    others.shuffle();
    
    // 他の単語の意味を追加（重複しないように、かつ足りない場合は適当な文字を入れるなどの考慮が必要だが、基本4つ以上ある前提）
    choices.addAll(others.take(3).map((e) => e.meaning));
    
    // 4つに満たない場合のフォールバック（あまりないが）
    while (choices.length < 4) {
      choices.add("---");
    }

    choices.shuffle();
    _currentChoices = choices;
    _selectedChoiceIndex = null;
    _showFeedback = false;
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

    return Scaffold(
      backgroundColor: Colors.grey[100], // 背景を少しグレーにしてカードを目立たせる
      appBar: AppBar(
        title: Text(provider.currentLevelTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 背景フラッシュ用のアニメーションコンテナ
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: _backgroundColor,
            child: const SizedBox.expand(),
          ),
          
          
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: slangList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                  // 1. プログレスバー (残り枚数)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      children: [
                        // カウンター表示 (例: 1 / 10)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${t.quiz.question} ${(_currentIndex + 1).clamp(1, slangList.length)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${(_currentIndex + 1).clamp(1, slangList.length)} / ${slangList.length}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // プログレスバー
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: slangList.isEmpty ? 0 : (_currentIndex + (_showFeedback ? 1 : 0)) / slangList.length,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: _buildQuizContent(slangList, provider),
                    ),
                  ),

                  // 3. 広告エリア (Yakuzaレベル以外の場合のみ表示)
                  if (provider.currentLevelId != 'level6_yakuza') ...[
                    if (_isBannerAdReady && _bannerAd != null)
                      SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      )
                    else
                      const AdPlaceholder(adSize: AdSize.banner), // 読み込み中はキラキラ,
                    const SizedBox(height: 10), // 下に少し余白
                  ] else ...[
                     const SizedBox(height: 20), // 広告がない場合の余白
                  ],
                ],
              ),
            ),
          ),
        ],
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
          flex: 2,
          child: _showFeedback 
            ? _buildFeedbackCard(item)
            : _buildQuestionCard(item, isLockedItem),
        ),
        const SizedBox(height: 20),
        if (!_showFeedback && !isLockedItem)
          Expanded(
            flex: 3,
            child: _buildChoiceButtons(item),
          ),
        if (_showFeedback)
          _buildNextButton(),
        if (isLockedItem && !_showFeedback)
           ElevatedButton(
            onPressed: () => _showPurchaseDialogInQuiz(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(t.quiz.locked.button),
          ),
      ],
    );
  }

  // 問題カード（単語のみ）
  Widget _buildQuestionCard(SlangItem item, bool isLocked) {
     return Stack(
       children: [
         Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  item.word,
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                if (item.romaji != null && item.romaji!.isNotEmpty)
                  Text(
                    item.romaji!,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                const Spacer(),
              ],
            ),
          ),
         ),
         if (isLocked)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock, size: 60, color: Colors.black87),
                          const SizedBox(height: 10),
                          Text(t.quiz.locked.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
       ],
     );
  }

  // フィードバックカード（解説 + 画像）
  Widget _buildFeedbackCard(SlangItem item) {
    final isCorrect = _selectedChoiceIndex != null && _currentChoices[_selectedChoiceIndex!] == item.meaning;

    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 正解・不正解表示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isCorrect ? "CORRECT!" : "WRONG!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 画像
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  item.imagePath,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              // 意味
              Text(
                item.meaning,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const Divider(height: 30),
              // 解説
              Text(
                item.explanation,
                style: const TextStyle(fontSize: 16, height: 1.4),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),
              if (item.example != null)
                Text(
                  "Example: ${item.example}",
                  style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 4択ボタン
  Widget _buildChoiceButtons(SlangItem item) {
    return ListView.builder(
      itemCount: _currentChoices.length,
      itemBuilder: (context, index) {
        final choice = _currentChoices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton(
            onPressed: () => _onChoiceSelected(index, item),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 4,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.amber, width: 2),
              ),
            ),
            child: Text(
              choice,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
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
    setState(() {
      _selectedChoiceIndex = index;
      _showFeedback = true;
      _quizResults[_currentIndex] = (_currentChoices[index] == item.meaning);
    });

    // 背景をピカッとする
    if (_currentChoices[index] == item.meaning) {
       _flashBackground(Colors.green.withOpacity(0.3));
    } else {
       _flashBackground(Colors.red.withOpacity(0.3));
    }
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
    if (provider.currentLevelId == 'level6_yakuza') {
       _showCompletionDialogWithReview();
    } else {
      AdHelper.showInterstitialAd(onComplete: () {
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
          _backgroundColor = Colors.grey[100]!;
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
        backgroundColor: const Color(0xFFFFF5F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // タイトル部分 (スコアのみ表示)
        title: Column(
          children: [
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown), textAlign: TextAlign.center),
            Text("$knownCount / $total", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown)),
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
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  t.quiz.result.listTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[400]),
                ),
              ),
              Divider(color: Colors.brown[200], height: 1),
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
                        border: Border(bottom: BorderSide(color: Colors.brown[100]!, width: 1)),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isKnown ? Colors.black87 : Colors.red[900], // 間違えた単語は少し赤く
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
                 child: Text(t.quiz.result.backToMenu, style: const TextStyle(color: Colors.grey)),
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
                child: Text(t.quiz.result.replayAll, style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
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
                   await Provider.of<PurchaseService>(context, listen: false).buyYakuzaLevel();
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
