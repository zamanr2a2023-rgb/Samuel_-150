import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  double _fontSize = 15.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nicknameController.text = prefs.getString('nickname') ?? '';
      _fontSize = prefs.getDouble('fontSize') ?? 15.0;
    });
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context);
    final name = _nicknameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.nicknameRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', name);
    await prefs.setDouble('fontSize', _fontSize);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.settingsSaved),
          backgroundColor: const Color(0xFFFF8C42),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showPrivacy() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E3252),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.privacyDialogTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PrivacySection(title: l10n.privacyIntroTitle, body: l10n.privacyIntroBody),
              _PrivacySection(title: l10n.privacyStoredTitle, body: l10n.privacyStoredBody),
              _PrivacySection(title: l10n.privacyUseTitle, body: l10n.privacyUseBody),
              _PrivacySection(title: l10n.privacyStorageTitle, body: l10n.privacyStorageBody),
              _PrivacySection(title: l10n.privacySharingTitle, body: l10n.privacySharingBody),
              _PrivacySection(title: l10n.privacySecurityTitle, body: l10n.privacySecurityBody),
              _PrivacySection(title: l10n.privacyRightsTitle, body: l10n.privacyRightsBody),
              _PrivacySection(title: l10n.privacyContactTitle, body: l10n.privacyContactBody),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.close,
              style: const TextStyle(
                color: Color(0xFFFF8C42),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF1E3252),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3252),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Gear icons – matching Øystein's layout
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 100,
                          top: 12,
                          child: Icon(
                            Icons.settings,
                            size: 38,
                            color: Colors.grey[500],
                          ),
                        ),
                        Icon(Icons.settings, size: 60, color: Colors.grey[500]),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Text(
                      l10n.settingsTitle,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 44),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        l10n.nicknameLabel,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF8C42),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Nickname text field
                    TextField(
                      controller: _nicknameController,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Font størrelse label
                    Text(
                      l10n.fontSizeLabel,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF8C42),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Font size slider
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF3A8EEA),
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                        overlayColor: const Color(0x223A8EEA),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14,
                        ),
                      ),
                      child: Slider(
                        value: _fontSize,
                        min: 12.0,
                        max: 22.0,
                        onChanged: (value) {
                          setState(() => _fontSize = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Lagre button
                    ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8C42),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        l10n.save,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),

            // Personvern / GDPR at the bottom
            GestureDetector(
              onTap: _showPrivacy,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🔒  ', style: TextStyle(fontSize: 18)),
                    Text(
                      l10n.privacyFooter,
                      style: const TextStyle(
                        color: Color(0xFFFF8C42),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for privacy text sections
class _PrivacySection extends StatelessWidget {
  final String title;
  final String body;
  const _PrivacySection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFF8C42),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
