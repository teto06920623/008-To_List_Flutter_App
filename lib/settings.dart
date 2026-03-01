import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // تحميل الإعدادات المحفوظة
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications_on') ?? true;
    });
  }

  // حفظ الإعدادات
  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان لتطابق الـ Home
    Color bgColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F7);
    Color cardColor = _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("General", _isDarkMode),
          
          // كارت الإعدادات العامة (شبه تصميم البروفايل)
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  trailing: Switch(
                    value: _isDarkMode,
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() => _isDarkMode = value);
                      _saveSetting('is_dark_mode', value);
                    },
                  ),
                  textColor: textColor,
                ),
                const Divider(height: 1, indent: 50),
                _buildSettingTile(
                  icon: Icons.notifications_none_outlined,
                  title: "Notifications",
                  trailing: Switch(
                    value: _notificationsEnabled,
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() => _notificationsEnabled = value);
                      _saveSetting('notifications_on', value);
                    },
                  ),
                  textColor: textColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle("Support", _isDarkMode),

          // كارت الدعم
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  textColor: textColor,
                ),
                const Divider(height: 1, indent: 50),
                _buildSettingTile(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  textColor: textColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          
          // زر تسجيل الخروج
          Center(
            child: TextButton.icon(
              onPressed: () {
                // منطق تسجيل الخروج هنا
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // بناء عنوان القسم (General, Support, إلخ)
  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
      ),
    );
  }

  // بناء سطر الإعداد الواحد
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required Color textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: trailing,
    );
  }
}