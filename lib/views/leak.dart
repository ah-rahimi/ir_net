import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ir_net/data/leak_item.dart';
import 'package:ir_net/main.dart';
import 'package:ir_net/widgets/modern_widgets.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:url_launcher/url_launcher.dart';

class LeakView extends StatefulWidget {
  const LeakView({super.key});

  @override
  State<LeakView> createState() => _LeakViewState();
}

class _LeakViewState extends State<LeakView> with SingleTickerProviderStateMixin {
  late TextEditingController textInputController;
  late AnimationController _animationController;
  StreamSubscription? _clearLeakInputSubscription;

  @override
  void initState() {
    super.initState();
    textInputController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Listen to clear leak input stream
    _setupClearInputListener();
  }
  
  void _setupClearInputListener() {
    _clearLeakInputSubscription?.cancel();
    _clearLeakInputSubscription = bloc.clearLeakInput.listen((_) {
      if (mounted) {
        textInputController.clear();
      }
    });
  }

  @override
  void dispose() {
    _clearLeakInputSubscription?.cancel();
    textInputController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Leak Detection',
            icon: Icons.shield_outlined,
            subtitle: 'Test your VPN for DNS leaks',
          ),
          const SizedBox(height: 16),
          input(),
          const SizedBox(height: 16),
          items(),
        ],
      ),
    );
  }

  Widget items() {
    return StreamBuilder<List<LeakItem>>(
      stream: bloc.leakChecklist,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(height: 16),
                Text(
                  'No leak tests yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        return SizedBox(
          height: 300,
          child: TouchMouseScrollable(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _buildLeakItem(data[index], index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeakItem(LeakItem item, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(item.url)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              _buildStatusIcon(item.status ?? LeakStatus.loading),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.url,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => bloc.onDeleteLeakItemClick(item),
                icon: const Icon(Icons.close, size: 18),
                color: const Color(0xFF64748B),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(LeakStatus status) {
    switch (status) {
      case LeakStatus.failed:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.close,
            color: Color(0xFFEF4444),
            size: 18,
          ),
        );
      case LeakStatus.passed:
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.check,
            color: Color(0xFF10B981),
            size: 18,
          ),
        );
      case LeakStatus.loading:
        return const SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
    }
  }

  Widget input() {
    return TextField(
      controller: textInputController,
      onChanged: bloc.onLeakInputChanged,
      onSubmitted: (_) => bloc.onAddLeakItemClick(),
      decoration: InputDecoration(
        hintText: 'https://developer.google.com',
        prefixIcon: const Icon(Icons.link),
        suffixIcon: IconButton(
          onPressed: bloc.onAddLeakItemClick,
          icon: const Icon(Icons.add_circle),
          tooltip: 'Add URL',
        ),
      ),
    );
  }
}
