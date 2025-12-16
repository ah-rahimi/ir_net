import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ir_net/widgets/modern_widgets.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import '../data/shared_preferences.dart';

class AppOptions extends StatefulWidget {
  const AppOptions({super.key});

  @override
  State<AppOptions> createState() => _AppOptionsState();
}

class _AppOptionsState extends State<AppOptions> {
  @override
  Widget build(BuildContext context) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Settings',
            icon: Icons.settings,
          ),
          const SizedBox(height: 12),
          showLeakInSysTray(),
          const Divider(height: 24),
          launchAtStartup(),
        ],
      ),
    );
  }

  Widget launchAtStartup() {
    if (Platform.isWindows == false) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<bool>(
      future: LaunchAtStartup.instance.isEnabled(),
      builder: (context, snapshot) {
        final value = snapshot.data ?? false;
        return _buildSettingTile(
          icon: Icons.power_settings_new,
          title: 'Launch on Startup',
          subtitle: 'Start IRNet automatically with Windows',
          value: value,
          onChanged: (enabled) {
            if (enabled == true) {
              LaunchAtStartup.instance.enable();
            } else {
              LaunchAtStartup.instance.disable();
            }
            setState(() {});
          },
        );
      },
    );
  }

  Widget showLeakInSysTray() {
    return FutureBuilder<bool>(
      future: AppSharedPreferences.showLeakInSysTray,
      builder: (context, snapshot) {
        final value = snapshot.data ?? false;
        return _buildSettingTile(
          icon: Icons.notifications_active,
          title: 'System Tray Notifications',
          subtitle: 'Show leak detection status in system tray',
          value: value,
          onChanged: (enabled) async {
            await AppSharedPreferences.setShowLeakInSysTray(enabled ?? false);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
