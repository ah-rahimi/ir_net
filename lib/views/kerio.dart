import 'package:flutter/material.dart';
import 'package:ir_net/data/shared_preferences.dart';
import 'package:ir_net/main.dart';
import 'package:ir_net/utils/kerio.dart';
import 'package:ir_net/widgets/modern_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class KerioView extends StatefulWidget {
  const KerioView({super.key});

  @override
  State<KerioView> createState() => _KerioViewState();
}

class _KerioViewState extends State<KerioView> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final ip = await AppSharedPreferences.kerioIP;
    final username = await AppSharedPreferences.kerioUsername;
    final password = await AppSharedPreferences.kerioPassword;

    if (mounted) {
      setState(() {
        _ipController.text = ip ?? '';
        _usernameController.text = username ?? '';
        _passwordController.text = password ?? '';
      });
    }
  }

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SectionHeader(
                title: 'Kerio Control',
                icon: Icons.vpn_key,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  bloc.onKerioLoginClick();
                  _showMessage('Refreshing...');
                },
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryColor,
                ),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Data Usage Progress
          _buildDataUsageProgress(),
          
          const SizedBox(height: 20),
          
          // IP Input
          _buildIPInput(),
          
          const SizedBox(height: 12),
          
          // Credentials Row
          Row(
            children: [
              Expanded(child: _buildUsernameInput()),
              const SizedBox(width: 12),
              Expanded(child: _buildPasswordInput()),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Login Button & Auto Login
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GradientButton(
                  text: 'Login',
                  icon: Icons.login,
                  onPressed: _login,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAutoLoginSwitch(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataUsageProgress() {
    return StreamBuilder(
      stream: bloc.kerioBalance,
      builder: (context, snapshot) {
        final balance = snapshot.data;
        final total = balance?.total ?? 0;
        final remaining = balance?.remaining ?? 0;
        final used = total - remaining;
        final progress = total > 0 ? remaining / total : 0.0;
        
        final totalFormatted = total == 0 ? '--' : KerioUtils.formatBytes(total);
        final remainingFormatted = remaining == 0 ? '--' : KerioUtils.formatBytes(remaining);
        final usedFormatted = total == 0 ? '--' : KerioUtils.formatBytes(used);
        
        final isLow = remaining < 1073741824; // Less than 1GB
        final isCritical = remaining < 536870912; // Less than 512MB

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCritical
                  ? [const Color(0xFFEF4444).withOpacity(0.1), const Color(0xFFF97316).withOpacity(0.1)]
                  : isLow
                      ? [const Color(0xFFF59E0B).withOpacity(0.1), const Color(0xFFEAB308).withOpacity(0.1)]
                      : [const Color(0xFF10B981).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCritical
                  ? const Color(0xFFEF4444)
                  : isLow
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF10B981),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Data Usage',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCritical
                          ? const Color(0xFFEF4444)
                          : isLow
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF10B981),
                    ),
                  ),
                  Text(
                    remainingFormatted,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCritical
                          ? const Color(0xFFEF4444)
                          : isLow
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCritical
                        ? const Color(0xFFEF4444)
                        : isLow
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDataInfo('Used', usedFormatted, Icons.arrow_upward),
                  _buildDataInfo('Total', totalFormatted, Icons.data_usage),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildIPInput() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: TextField(
        controller: _ipController,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          hintText: 'Kerio login page IP',
          prefixIcon: const Icon(Icons.language),
          suffixIcon: IconButton(
            onPressed: () {
              final url = _ipController.text.trim();
              if (url.isNotEmpty) {
                final uri = Uri.tryParse(url.startsWith('http') ? url : 'http://$url');
                if (uri != null) {
                  launchUrl(uri);
                }
              }
            },
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in Browser',
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameInput() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: TextField(
        controller: _usernameController,
        decoration: InputDecoration(
          hintText: 'Username',
          prefixIcon: const Icon(Icons.person),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAutoLoginSwitch() {
    return FutureBuilder<bool>(
      future: AppSharedPreferences.kerioAutoLogin,
      builder: (context, snapshot) {
        final value = snapshot.data ?? false;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Auto',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: value,
                onChanged: (enabled) async {
                  await AppSharedPreferences.setKerioAutoLogin(enabled);
                  setState(() {});
                },
                activeColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  void _login() async {
    final ip = _ipController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (ip.isEmpty || username.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    await AppSharedPreferences.setKerioIP(ip);
    await AppSharedPreferences.setKerioUsername(username);
    await AppSharedPreferences.setKerioPassword(password);
    
    bloc.onKerioLoginClick();
    _showMessage('Login request sent');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
