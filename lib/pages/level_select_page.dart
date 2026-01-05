// lib/pages/level_select_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 追加
import '../providers/quiz_provider.dart';
import '../ad_helper.dart'; // 追加
import '../widgets/ad_placeholder.dart'; // 追加
import 'quiz_page.dart';
import '../services/purchase_service.dart'; // 追加
import '../utils/ad_manager.dart';
import 'settings_page.dart';

class LevelSelectPage extends StatefulWidget {
  const LevelSelectPage({super.key});

  @override
  State<LevelSelectPage> createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. UI描画完了後、少し待ってからダイアログを表示する (ATT対策)
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // 2. 同意フローの初期化 (完了を待つ)
    await AdManager.instance.initializeConsent();
    
    // 3. Mobile Ads SDKの初期化 & 広告ロード
    await MobileAds.instance.initialize();
    
    // バナー広告をロード
    _loadBannerAd();

    // 次の画面の広告をプリロード
    AdHelper.preloadQuizBanner();

    // インタースティシャル広告もここでプリロード開始 (最速でロード)
    AdHelper.loadInterstitialAd();

    // 4. データロードなど既存の処理
    if (mounted) {
      Provider.of<QuizProvider>(context, listen: false).loadMasterData();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
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
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F0), // 薄いオレンジ背景
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Select Level",
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.brown),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Colors.brown, size: 30),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                                );
                              },
                            ),
                          ],
                        ),
                        const Text(
                          "Choose your slang journey!",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        
                        // メニューリスト
                        Expanded(
                          child: ListView(
                            children: [
                              _levelCard(
                                id: 'lv1',
                                title: "Level 1: Survival",
                                desc: "Essential words you must know.",
                                color: Colors.orange,
                                icon: Icons.local_fire_department,
                              ),
                              _levelCard(
                                id: 'lv2',
                                title: "Level 2: Youth",
                                desc: "Trending words among Gen Z.",
                                color: Colors.pink,
                                icon: Icons.favorite,
                              ),
                              _levelCard(
                                id: 'lv3',
                                title: "Level 3: Otaku",
                                desc: "Anime & Manga culture terms.",
                                color: Colors.purple,
                                icon: Icons.auto_stories,
                              ),
                              _levelCard(
                                id: 'lv4',
                                title: "Level 4: Internet",
                                desc: "Net slang & Gaming chat.",
                                color: Colors.blue,
                                icon: Icons.wifi,
                              ),
                              _levelCard(
                                id: 'lv5',
                                title: "Level 5: Persona",
                                desc: "Ore, Boku, Watashi... Pronouns.",
                                color: Colors.teal,
                                icon: Icons.face,
                              ),
                              // Level 6: Yakuza (課金ロック付き)
                              Consumer<PurchaseService>(
                                builder: (context, purchaseService, child) {
                                  // isUnlocked チェックは不要になったので削除
                                  
                                  return _levelCard(
                                    id: 'lv6', // IDはダミーでもOKだが一応設定
                                    title: "Level 6: Yakuza / Underworld",
                                    desc: "Dangerous underworld slang.",
                                    color: Colors.black, // ヤクザをイメージした黒
                                    // 常時アイコンを表示（鍵マークにはしない）
                                    icon: Icons.sports_martial_arts, 
                                    // ロック中はボタンの見た目を少し暗くするなどの処理（お好みで）
                                    onTap: () {
                                      // 未解放でもクイズ画面へ遷移（中で3問目まで無料）
                                      // ※JSONデータのキーは "level6_yakuza" としてください
                                      Provider.of<QuizProvider>(context, listen: false).selectLevel("level6_yakuza");
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage()));
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // ▼▼ 広告エリア（プレースホルダー付き） ▼▼
                const SizedBox(height: 10),
                if (_isBannerAdReady && _bannerAd != null)
                  SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  )
                else
                  const AdPlaceholder(adSize: AdSize.banner), // 読み込み中はキラキラ
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _levelCard({
    required String id,
    required String title,
    required String desc,
    required Color color,
    required IconData icon,
    VoidCallback? onTap, // 追加
  }) {
    return GestureDetector(
      onTap: onTap ?? () async {
        // 1. レベルをセット (データロードを待機)
        final provider = Provider.of<QuizProvider>(context, listen: false);
        await provider.selectLevel(id);

        if (!context.mounted) return;

        // 2. クイズ画面へGO
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuizPage()),
        ).then((_) {
          // 戻ってきたらまた次のためにプレロードしておく（任意）
          AdHelper.preloadQuizBanner();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
