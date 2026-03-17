// lib/pages/level_select_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:ui'; // Added for glassmorphism effects
import 'package:google_fonts/google_fonts.dart';
import '../providers/quiz_provider.dart';
import '../ad_helper.dart';
import '../widgets/ad_placeholder.dart';
import 'quiz_page.dart';
import '../utils/ad_manager.dart';
import 'settings_page.dart';
import '../widgets/premium_unlock_card.dart';
import '../services/purchase_manager.dart';
import '../i18n/strings.g.dart';

class LevelSelectPage extends StatefulWidget {
  const LevelSelectPage({super.key});

  @override
  State<LevelSelectPage> createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {
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
    
    // 次の画面の広告をプリロード (QuizPageなどで使用)
    AdHelper.preloadQuizBanner();

    // インタースティシャル広告もここでプリロード開始 (最速でロード)
    AdHelper.loadInterstitialAd();

    // 4. データロードなど既存の処理
    if (mounted) {
      Provider.of<QuizProvider>(context, listen: false).loadMasterData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purchaseManager = Provider.of<PurchaseManager>(context);
    final isPremium = purchaseManager.isPremium;
    final isYakuzaUnlocked = purchaseManager.isYakuzaUnlocked;
    final quizProvider = Provider.of<QuizProvider>(context);

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
        child: SafeArea(
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
                          const SizedBox(height: 30),
                          
                          // --- 1. モード切替トグル (最上部) ---
                          Center(child: _buildModeToggle(quizProvider, isPremium)),
                          
                          const SizedBox(height: 40),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.levelSelect.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 32, 
                                      fontWeight: FontWeight.w900, 
                                      color: const Color(0xFF2D0B5A), // Deep Purple
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    t.levelSelect.subtitle,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14, 
                                      color: const Color(0xFF2D0B5A).withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              _buildSettingsButton(context),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // メニューリスト
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.only(bottom: 20),
                              physics: const BouncingScrollPhysics(),
                              children: [
                                _levelCard(
                                  id: 'lv1',
                                  title: t.levelSelect.levels.level1.title,
                                  desc: t.levelSelect.levels.level1.desc,
                                  color: Colors.orange,
                                  icon: Icons.local_fire_department,
                                ),
                                const SizedBox(height: 8),
                                _levelCard(
                                  id: 'lv2',
                                  title: t.levelSelect.levels.level2.title,
                                  desc: t.levelSelect.levels.level2.desc,
                                  color: Colors.pink,
                                  icon: Icons.favorite,
                                ),
                                const SizedBox(height: 8),
                                _levelCard(
                                  id: 'lv3',
                                  title: t.levelSelect.levels.level3.title,
                                  desc: t.levelSelect.levels.level3.desc,
                                  color: Colors.purple,
                                  icon: Icons.auto_stories,
                                ),
                                const SizedBox(height: 8),
                                _levelCard(
                                  id: 'lv4',
                                  title: t.levelSelect.levels.level4.title,
                                  desc: t.levelSelect.levels.level4.desc,
                                  color: Colors.blue,
                                  icon: Icons.wifi,
                                ),
                                const SizedBox(height: 8),
                                _levelCard(
                                  id: 'lv5',
                                  title: t.levelSelect.levels.level5.title,
                                  desc: t.levelSelect.levels.level5.desc,
                                  color: Colors.teal,
                                  icon: Icons.face,
                                ),
                                const SizedBox(height: 8),
                                // Level 6: Yakuza
                                _levelCard(
                                  id: 'level6_yakuza',
                                  title: t.levelSelect.levels.level6.title,
                                  desc: t.levelSelect.levels.level6.desc,
                                  color: const Color(0xFFD400FF),
                                  icon: Icons.sports_martial_arts,
                                  onTap: () {
                                    quizProvider.selectLevel("level6_yakuza");
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage()));
                                  },
                                ),
                                const SizedBox(height: 24),
                                _buildReviewButton(quizProvider),
                                const SizedBox(height: 24),
                                const PremiumUnlockCard(),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle(QuizProvider provider, bool isPremium) {
    return Container(
      width: 220,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF2D0B5A).withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // シャッフル
          Expanded(
            child: GestureDetector(
              onTap: () => provider.selectedMode = QuizMode.shuffle,
              child: Container(
                decoration: BoxDecoration(
                  color: provider.selectedMode == QuizMode.shuffle 
                      ? Colors.white 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: provider.selectedMode == QuizMode.shuffle ? [
                    BoxShadow(
                      color: const Color(0xFF2D0B5A).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ] : null,
                ),
                child: Center(
                  child: Icon(
                    Icons.shuffle,
                    color: provider.selectedMode == QuizMode.shuffle ? const Color(0xFF2D0B5A) : const Color(0xFF2D0B5A).withOpacity(0.3),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          // 順番通り
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isPremium) {
                  provider.selectedMode = QuizMode.sequential;
                } else {
                  _showPremiumDialog(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: provider.selectedMode == QuizMode.sequential 
                      ? Colors.white 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: provider.selectedMode == QuizMode.sequential ? [
                    BoxShadow(
                      color: const Color(0xFF2D0B5A).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ] : null,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.format_list_numbered,
                        color: provider.selectedMode == QuizMode.sequential ? const Color(0xFF2D0B5A) : const Color(0xFF2D0B5A).withOpacity(0.3),
                        size: 20,
                      ),
                      if (!isPremium)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Icon(Icons.lock, size: 8, color: Colors.amber[700]),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // プレミアム案内ダイアログ
  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ヘッダー (グラデーション)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFDAA520), size: 40),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      t.premium.dialog.title,
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              // 特典リスト
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    _benefitRow(Icons.onetwothree_rounded, t.premium.dialog.feature1),
                    const SizedBox(height: 16),
                    _benefitRow(Icons.block_rounded, t.premium.dialog.feature2),
                    const SizedBox(height: 16),
                    _benefitRow(Icons.auto_awesome_rounded, t.premium.dialog.feature3),
                  ],
                ),
              ),
              // ボタン
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            await Provider.of<PurchaseManager>(context, listen: false).buyPremium();
                          } catch (e) {
                            debugPrint("Purchase error: $e");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D0B5A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: Text(t.premium.dialog.buy, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(t.premium.dialog.cancel, style: GoogleFonts.outfit(color: const Color(0xFF2D0B5A).withOpacity(0.4))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ヤクザレベルアンロックダイアログ
  void _showYakuzaUnlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text(
          t.quiz.locked.dialogTitle,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF2D0B5A)),
        ),
        content: Text(
          t.quiz.locked.dialogDesc,
          style: GoogleFonts.outfit(color: const Color(0xFF2D0B5A).withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.quiz.locked.cancel, 
              style: GoogleFonts.outfit(color: const Color(0xFF2D0B5A).withOpacity(0.4))
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await Provider.of<PurchaseManager>(context, listen: false).buyYakuza();
              } catch (e) {
                debugPrint("Purchase error: $e");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D0B5A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: Text(t.quiz.locked.button, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFDAA520), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(fontSize: 15, color: const Color(0xFF2D0B5A).withOpacity(0.7), height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewButton(QuizProvider provider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF4081), // Vibrant Pink
            Color(0xFFD400FF), // Neon Purple
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD400FF).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _showReviewModal(context, provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology_rounded, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              t.review.button,
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // 復習モーダル
  void _showReviewModal(BuildContext context, QuizProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReviewModal(provider: provider),
    );
  }

  Widget _levelCard({
    required String id,
    required String title,
    required String desc,
    required Color color,
    required IconData icon,
    bool isLocked = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D0B5A).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap ?? () async {
            final provider = Provider.of<QuizProvider>(context, listen: false);
            await provider.selectLevel(id);
            if (!context.mounted) return;
            Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizPage()));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // アイコンエリア
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: GoogleFonts.outfit(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: const Color(0xFF2D0B5A)
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc, 
                        style: GoogleFonts.outfit(
                          fontSize: 12, 
                          color: const Color(0xFF2D0B5A).withOpacity(0.5),
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ],
                  ),
                ),
                if (isLocked)
                  Icon(Icons.lock_rounded, size: 20, color: const Color(0xFF2D0B5A).withOpacity(0.2))
                else
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: const Color(0xFF2D0B5A).withOpacity(0.2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D0B5A).withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.settings_rounded, color: Color(0xFF2D0B5A)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
      ),
    );
  }
}

class _ReviewModal extends StatelessWidget {
  final QuizProvider provider;
  const _ReviewModal({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D0B5A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              t.review.modal.title,
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF2D0B5A)),
            ),
            const SizedBox(height: 24),
            // --- 全カテゴリー ---
            _allCategoryItem(context),
            const SizedBox(height: 16),
            // --- 各カテゴリー ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _categoryChip(context, 'lv1', t.levelSelect.levels.level1.title, Icons.local_fire_department_rounded, Colors.orange),
                  _categoryChip(context, 'lv2', t.levelSelect.levels.level2.title, Icons.favorite_rounded, Colors.pink),
                  _categoryChip(context, 'lv3', t.levelSelect.levels.level3.title, Icons.auto_stories_rounded, Colors.purple),
                  _categoryChip(context, 'lv4', t.levelSelect.levels.level4.title, Icons.wifi_rounded, Colors.blue),
                  _categoryChip(context, 'lv5', t.levelSelect.levels.level5.title, Icons.face_rounded, Colors.teal),
                  _categoryChip(context, 'level6_yakuza', t.levelSelect.levels.level6.title, Icons.sports_martial_arts_rounded, const Color(0xFFD400FF)),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _allCategoryItem(BuildContext context) {
    final count = provider.getTotalWeakCount();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D0B5A).withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: count > 0 ? () {
            provider.startAllCategoryReview();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage()));
          } : null,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded, color: Color(0xFFD400FF), size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    t.review.modal.allQuestions,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF2D0B5A)),
                  ),
                ),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF44336).withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      t.review.modal.questionCount(count: count),
                      style: GoogleFonts.outfit(color: const Color(0xFFF44336), fontSize: 14, fontWeight: FontWeight.w900),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(BuildContext context, String levelId, String title, IconData icon, Color color) {
    final count = provider.getCategoryWeakCount(levelId);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D0B5A).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: count > 0 ? () {
              provider.selectLevel(levelId);
              provider.startCategoryReview(levelId);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage()));
            } : null,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: count > 0 ? color : const Color(0xFF2D0B5A).withOpacity(0.2), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title, 
                    style: GoogleFonts.outfit(
                      color: count > 0 ? const Color(0xFF2D0B5A) : const Color(0xFF2D0B5A).withOpacity(0.2), 
                      fontWeight: count > 0 ? FontWeight.bold : FontWeight.w500
                    )
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      "($count)", 
                      style: GoogleFonts.outfit(color: color, fontSize: 12, fontWeight: FontWeight.w900)
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
