import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/purchase_service.dart';
import 'terms_page.dart';
import 'tokusho_page.dart';
import '../i18n/strings.g.dart'; // Localized strings

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // ★これらのURLはリリース前に必ず正式なものに差し替えてください★
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
      appBar: AppBar(
        title: Text(t.settings.title),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              _buildSectionHeader(t.settings.legal),
              _buildListTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: t.settings.privacyPolicy,
                onTap: () => _launchUrl(context, _privacyPolicyUrl),
              ),
              _buildListTile(
                context,
                icon: Icons.description_outlined,
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
                icon: Icons.store_outlined,
                title: t.settings.tokusho,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TokushoPage()),
                  );
                },
              ),
              const Divider(height: 40),
              _buildSectionHeader(t.settings.services),
              _buildListTile(
                context,
                icon: Icons.restore_outlined,
                title: t.settings.restore,
                subtitle: t.settings.restoreSubtitle,
                onTap: () async {
                  // 復元処理の呼び出し
                  try {
                    await Provider.of<PurchaseService>(context, listen: false)
                        .restorePurchases();
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
              const Divider(height: 40),
              _buildSectionHeader(t.settings.appInfo),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(t.settings.version),
                trailing: const Text("1.0.0"), // 必要に応じてpackage_info_plusで動的に取得
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      String? subtitle,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
