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
import '../services/purchase_service.dart'; // 追加

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // スワイプ操作をボタンから操るためのコントローラー
  final CardSwiperController _swiperController = CardSwiperController();
  
  int _currentIndex = 0;
  bool _isFlipped = false; // 今のカードが裏返っているか
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
      });
    });
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
    _swiperController.dispose();
    _bannerAd?.dispose(); // 広告破棄
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final slangList = provider.slangList;

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
                                "Question ${(_currentIndex + 1).clamp(1, slangList.length)}",
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
                            value: _currentIndex / slangList.length, // 0からスタートし、最後は90%になるように変更
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. スワイプカードエリア
                  Expanded(
                    child: CardSwiper(
                      isLoop: false, // ループを無効化
                      key: ValueKey("${slangList.hashCode}_$_replayCount"), // リスト変更 or リプレイで再構築
                      controller: _swiperController,
                      cardsCount: slangList.length,
                      numberOfCardsDisplayed: slangList.length < 3 ? slangList.length : 3, // 後ろに重なって見える枚数
                      backCardOffset: const Offset(0, 40), // 重なりのズレ幅
                      padding: const EdgeInsets.all(24),
                      
                      // スワイプした時の処理
                      onSwipe: (previousIndex, currentIndex, direction) {
                        // ▼▼ ロックされているカードはスワイプ禁止（念のため） ▼▼
                        final currentLevelId = provider.currentLevelId;
                        final isYakuzaUnlocked = provider.isYakuzaUnlocked;
                        // currentIndex は「次に表示されるカード」のインデックス
                        // previousIndex は「今スワイプしてるカード」のインデックス
                        // つまり、今スワイプしようとしているカードが「有料エリア(3問目以降=index 3以降)」なら禁止？
                        // 要件：4問目(index 3)から見えない。
                        // つまり index 3 のカードはスワイプできないようにする
                        
                        // Yakuzaレベル かつ 未解放 かつ 4枚目(index 3)以降ならスワイプ無効
                        if (currentLevelId == 'level6_yakuza' && !isYakuzaUnlocked && previousIndex >= 3) {
                          return false; 
                        }

                        _handleSwipe(previousIndex, direction);
                        return true; // trueならスワイプ許可
                      },
                      
                      // カードの中身を作る
                      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                        final item = slangList[index];
                        final isCurrentCardFlipped = (index == _currentIndex && _isFlipped);

                        // ▼▼ 課金ロック判定 ▼▼
                        final currentLevelId = provider.currentLevelId;
                        final isYakuzaUnlocked = provider.isYakuzaUnlocked;
                        // 4問目以降 (index 3, 4, 5...) はロック
                        final isLockedItem = (currentLevelId == 'level6_yakuza' && !isYakuzaUnlocked && index >= 3);

                        // Stackを使ってカードの上にオーバーレイを重ねる構造にする
                        return Stack(
                          children: [
                            // 1. メインのカード (GestureDetectorでラップ)
                            GestureDetector(
                              onTap: () {
                                if (isLockedItem) {
                                   // ロック中はタップで課金ダイアログ
                                   _showPurchaseDialogInQuiz(context);
                                } else {
                                  setState(() {
                                    _isFlipped = !_isFlipped;
                                  });
                                }
                              },
                              child: isLockedItem 
                                // ロック中は「すりガラス」表現
                                ? Stack(
                                    children: [
                                      // 1. 元のカード (少し暗めにするなど調整しても良いが、ブラーだけで十分な場合も)
                                      QuizCard(
                                        slangItem: item,
                                        isFlipped: false, // 裏面が見えないように表面固定
                                      ),
                                      // 2. すりガラスフィルター (ClipRRectで角丸を合わせる)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          // QuizCardのborderRadiusに合わせて20に設定
                                          borderRadius: BorderRadius.circular(20),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // 強めのブラー
                                            child: Container(
                                              color: Colors.white.withOpacity(0.2), // 半透明の白を重ねてフロスト感を出す
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                // 通常時
                                : QuizCard(
                                    slangItem: item,
                                    isFlipped: isCurrentCardFlipped,
                                  ),
                            ),

                            // 2. ロック時のオーバーレイ (鍵アイコンとボタン)
                            if (isLockedItem)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lock, size: 60, color: Colors.black87),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Paid Content",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Unlock Level 6 to see more!",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () => _showPurchaseDialogInQuiz(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Unlock Now"),
                                    ),
                                  ],
                                ),
                              ),

                            // 3. 左スワイプ時のオーバーレイ (Don't Know / 赤)
                            if (!isLockedItem && percentThresholdX < 0)
                              _buildSwipeOverlay(
                                text: "DON'T KNOW",
                                color: Colors.red,
                                alignment: Alignment.topRight,
                                angle: 0.2, 
                                opacity: (percentThresholdX.abs() * 2.0).clamp(0.0, 1.0),
                              ),

                            // 4. 右スワイプ時のオーバーレイ (I KNOW IT! / 緑)
                            if (!isLockedItem && percentThresholdX > 0)
                              _buildSwipeOverlay(
                                text: "I KNOW IT!",
                                color: Colors.green,
                                alignment: Alignment.topLeft,
                                angle: -0.2,
                                opacity: (percentThresholdX.abs() * 2.0).clamp(0.0, 1.0),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  // 3. 操作ボタンエリア
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 40, right: 40), // bottomを減らす
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 左スワイプボタン (Don't know)
                        _circleButton(
                          icon: Icons.close,
                          color: Colors.red,
                          onTap: () => _swiperController.swipe(CardSwiperDirection.left),
                        ),
                        
                        // 戻るボタン (Undo) - おまけ機能
                        _miniButton(
                          icon: Icons.replay,
                          onTap: () {
                             // カードスワイパーを再構築せずに戻すのは難しいので、簡易的にインデックス操作
                             // が、ValueKeyがついているので戻るボタンの挙動は少し怪しくなるかも？
                             // いったんそのまま
                             _swiperController.undo();
                             setState(() {
                               if (_currentIndex > 0) _currentIndex--;
                               _isFlipped = false;
                             });
                          },
                        ),

                        // 右スワイプボタン (I know)
                        _circleButton(
                          icon: Icons.favorite, // ハートに変更（Tinder感）
                          color: Colors.green,
                          onTap: () => _swiperController.swipe(CardSwiperDirection.right),
                        ),
                      ],
                    ),
                  ),

                  // ▼▼ ここに広告エリアを追加 (Yakuzaレベル以外の場合のみ表示) ▼▼
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

  // スワイプされた後のロジック
  void _handleSwipe(int previousIndex, CardSwiperDirection direction) {
    // 結果リストの範囲内かチェック
    if (previousIndex < _quizResults.length) {
        // 右スワイプなら true (知ってる)、左なら false (知らない) を記録
        _quizResults[previousIndex] = (direction == CardSwiperDirection.right);
    }

    if (direction == CardSwiperDirection.right) {
      debugPrint("Knew it! -> $previousIndex");
      // 緑にピカッとする
      _flashBackground(Colors.green.withOpacity(0.3));
    } else {
      debugPrint("Didn't know -> $previousIndex");
      // 赤にピカッとする
      _flashBackground(Colors.red.withOpacity(0.3));
    }

    setState(() {
      _currentIndex = previousIndex + 1;
      _isFlipped = false; // 次のカードは必ず表面からスタート
    });

    // 全て終わった場合
    final total = Provider.of<QuizProvider>(context, listen: false).slangList.length;
    if (_currentIndex >= total) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      
      // Yakuzaレベル(有料)の場合は広告を出さずに完了画面へ
      if (provider.currentLevelId == 'level6_yakuza') {
         _showCompletionDialogWithReview();
      } else {
        // 広告を出してからダイアログを出す
        debugPrint("Showing Interstitial Ad...");
        AdHelper.showInterstitialAd(onComplete: () {
          // 広告を閉じた（または読み込めなかった）後に実行される
          _showCompletionDialogWithReview();
        });
      }
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
  void _showCompletionDialogWithReview() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final total = provider.slangList.length;
    final knownCount = _quizResults.where((result) => result == true).length;
    final unknownCount = total - knownCount;

    // スコアに応じたタイトル（絵文字は削除）
    String title;
    if (knownCount == total && total > 0) {
      title = "Perfect Master!";
    } else if (knownCount >= total * 0.8 && total > 0) {
      title = "Awesome!";
    } else {
      title = "Good job!";
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
                  "Results List",
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
              label: Text("Review $unknownCount Words"), // 間違えた数も表示
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
                 child: const Text("Back to Menu", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 0;
                    _quizResults = List.filled(total, false);
                    _replayCount++; // CardSwiperを強制リセット
                  });
                },
                child: const Text("Replay All", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
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
      _isFlipped = false;
      _replayCount++;
    });
  }

  // 丸い大きなボタン
  Widget _circleButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
        foregroundColor: color,
        elevation: 5,
        shadowColor: Colors.black26,
      ),
      child: Icon(icon, size: 36),
    );
  }

  // 小さな機能ボタン
  Widget _miniButton({required IconData icon, required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.grey, size: 24),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  // ▼▼▼ 新規追加: スワイプ時のオーバーレイ表示を作成するメソッド ▼▼▼
  Widget _buildSwipeOverlay({
    required String text,
    required Color color,
    required Alignment alignment,
    required double angle,
    required double opacity, // 追加
  }) {
    // ふんわりアニメーションさせるために AnimatedOpacity を使用
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200), // 変化にかかる時間
        curve: Curves.easeOut, // 変化の仕方（最初は早く、最後はゆっくり）
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.all(30),
          alignment: alignment, // 指定した角に配置
          child: Transform.rotate(
            angle: angle, // テキストを少し傾ける
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 4), // 枠線
                borderRadius: BorderRadius.circular(10),
                color: color.withOpacity(0.1), // 半透明の背景色
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // クイズ画面内での課金ダイアログ
  void _showPurchaseDialogInQuiz(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
         title: const Text("Unlock Yakuza Level"),
         content: const Text("Unlock the full 50 words list?"),
         actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                 Navigator.pop(context); // Close dialog
                 // 購入処理開始 (結果はPurchaseServiceのストリームで監視される)
                 await Provider.of<PurchaseService>(context, listen: false).buyYakuzaLevel(); 
              }, 
              child: const Text("Unlock"),
            )
         ],
      )
    );
  }
}
