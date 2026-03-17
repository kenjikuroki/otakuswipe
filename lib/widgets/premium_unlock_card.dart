import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../services/purchase_manager.dart';
import '../i18n/strings.g.dart';

class PremiumUnlockCard extends StatelessWidget {
  const PremiumUnlockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseManager>(
      builder: (context, purchaseManager, child) {
        if (purchaseManager.isPremium) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFD700).withOpacity(0.05),
                        const Color(0xFFFFFFFF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Color(0xFFDAA520), // Darker Goldenrod for better contrast
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.premium.upgradeCard.title,
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF2D0B5A),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t.premium.upgradeCard.subtitle,
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF2D0B5A).withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => purchaseManager.buyPremium(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: const Color(0xFF2D0B5A),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            t.premium.upgradeCard.buy,
                            style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => purchaseManager.restorePurchases(),
              child: Text(
                t.premium.upgradeCard.restore,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2D0B5A).withOpacity(0.35),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
