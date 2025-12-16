import 'package:flutter/material.dart';
import 'package:ir_net/theme/theme_provider.dart';
import 'package:ir_net/utils/platform.dart';
import 'package:ir_net/views/connection.dart';
import 'package:ir_net/views/ip_stat.dart';
import 'package:ir_net/views/kerio.dart';
import 'package:ir_net/views/leak.dart';
import 'package:ir_net/views/options.dart';
import 'package:ir_net/widgets/modern_widgets.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _buildBody(),
      ),
      bottomNavigationBar: PlatformUtils.isMobile ? _buildBottomNav() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color(0xFF3B82F6), const Color(0xFF0EA5E9)]
                    : [const Color(0xFF2563EB), const Color(0xFF0EA5E9)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.wifi_tethering, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'IRNet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            context.watch<ThemeProvider>().isDark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            context.read<ThemeProvider>().toggleTheme();
          },
          tooltip: 'Toggle Theme',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    if (PlatformUtils.isMobile) {
      return _buildMobileLayout();
    }
    return _buildDesktopLayout();
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_selectedIndex == 0) ...[
            const LeakView(),
            const SizedBox(height: 16),
            const Connection(),
          ],
          if (_selectedIndex == 1) ...[
            const KerioView(),
          ],
          if (_selectedIndex == 2) ...[
            const IpStatView(),
          ],
          if (_selectedIndex == 3) ...[
            const AppOptions(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Hero Section
              _buildHeroSection(),
              const SizedBox(height: 32),
              
              // Kerio Section (Full Width)
              const KerioView(),
              const SizedBox(height: 24),
              
              // Main Content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      children: [
                        const LeakView(),
                        const SizedBox(height: 24),
                        const AppOptions(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  
                  // Right Column
                  Expanded(
                    child: Column(
                      children: [
                        const IpStatView(),
                        const SizedBox(height: 24),
                        const Connection(),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return ModernCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color(0xFF3B82F6), const Color(0xFF0EA5E9)]
                    : [const Color(0xFF2563EB), const Color(0xFF0EA5E9)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.security,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Network Security Monitor',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Freedom does not have a price',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GradientButton(
            text: 'Refresh',
            icon: Icons.refresh,
            onPressed: bloc.onRefreshButtonClick,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GradientButton(
            text: 'Exit',
            icon: Icons.exit_to_app,
            onPressed: bloc.onExitClick,
            gradientColors: const [Color(0xFFEF4444), Color(0xFFF97316)],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.shield),
          label: 'Leak Test',
        ),
        NavigationDestination(
          icon: Icon(Icons.vpn_key),
          label: 'Kerio',
        ),
        NavigationDestination(
          icon: Icon(Icons.info),
          label: 'Network Info',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
