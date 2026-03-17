import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/purchase_manager.dart';
import 'terms_page.dart';
import 'tokusho_page.dart';
import '../i18n/strings.g.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final String _privacyPolicyUrl = 'https://note.com/dapper_flax6182/n/nf18b0b71bba4?app_launch=false';

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch display');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening link: $e. Please restart the app.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          t.settings.title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF2D0B5A)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2D0B5A)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF7F2FF),
              Color(0xFFFBF8FF),
              Color(0xFFF2E9FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildSectionHeader(t.settings.legal),
                  _buildListTile(
                    context,
                    icon: Icons.privacy_tip_rounded,
                    title: t.settings.privacyPolicy,
                    onTap: () => _launchUrl(context, _privacyPolicyUrl),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.description_rounded,
                    title: t.settings.termsOfUse,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TermsPage()),
                      );
                    },
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.store_rounded,
                    title: t.settings.tokusho,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TokushoPage()),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Divider(color: Color(0xFF2D0B5A), thickness: 0.05),
                  ),
                  _buildSectionHeader(t.settings.services),
                  _buildListTile(
                    context,
                    icon: Icons.restore_rounded,
                    title: t.settings.restore,
                    subtitle: t.settings.restoreSubtitle,
                    onTap: () async {
                      try {
                        await Provider.of<PurchaseManager>(context, listen: false).restorePurchases();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(t.settings.restoreSuccess)),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.settings.restoreError(error: e))),
                          );
                        }
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Divider(color: Color(0xFF2D0B5A), thickness: 0.05),
                  ),
                  _buildSectionHeader(t.settings.appInfo),
                  _buildListTile(
                    context,
                    icon: Icons.info_rounded,
                    title: t.settings.version,
                    trailingText: "1.0.0",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          color: const Color(0xFF2D0B5A).withOpacity(0.4),
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      String? subtitle,
      String? trailingText,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D0B5A).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF2D0B5A), size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D0B5A),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: const Color(0xFF2D0B5A).withOpacity(0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingText != null)
                  Text(
                    trailingText,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: const Color(0xFF2D0B5A).withOpacity(0.3),
                    ),
                  )
                else
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: const Color(0xFF2D0B5A).withOpacity(0.2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
