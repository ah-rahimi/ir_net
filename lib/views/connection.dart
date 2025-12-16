import 'package:flutter/material.dart';
import 'package:ir_net/widgets/modern_widgets.dart';

import '../main.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Speed Test',
            icon: Icons.speed,
            trailing: testButton(),
          ),
          const SizedBox(height: 20),
          results(),
        ],
      ),
    );
  }

  Widget results() {
    return Column(
      children: [
        pingRow(),
        const SizedBox(height: 12),
        downloadRow(),
        const SizedBox(height: 12),
        uploadRow(),
      ],
    );
  }

  Widget pingRow() {
    return StreamBuilder(
      stream: bloc.ping,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 0.0;
        return InfoRow(
          icon: Icons.timer,
          label: 'Ping',
          value: '${value.toInt()} ms',
          iconColor: const Color(0xFF06B6D4),
        );
      },
    );
  }

  Widget downloadRow() {
    return StreamBuilder(
      stream: bloc.downloadSpeed,
      builder: (context, snapshot) {
        final value = (snapshot.data ?? 0.0).toInt();
        final formattedValue = value == 0 ? '--' : '$value Mb/s';
        return InfoRow(
          icon: Icons.download,
          label: 'Download Speed',
          value: formattedValue,
          iconColor: const Color(0xFF3B82F6),
        );
      },
    );
  }

  Widget uploadRow() {
    return StreamBuilder(
      stream: bloc.uploadSpeed,
      builder: (context, snapshot) {
        var value = (snapshot.data ?? 0.0).toInt();
        if (value > 500) {
          value = 0;
        }
        final formattedValue = value == 0 ? '--' : '$value Mb/s';
        return InfoRow(
          icon: Icons.upload,
          label: 'Upload Speed',
          value: formattedValue,
          iconColor: const Color(0xFF8B5CF6),
        );
      },
    );
  }

  Widget testButton() {
    return StreamBuilder(
      stream: bloc.speedTestStatus,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 'Not started';
        final isRunning = value == 'Running';

        return GradientButton(
          text: 'Test',
          icon: isRunning ? null : Icons.play_arrow,
          isLoading: isRunning,
          onPressed: isRunning ? null : bloc.onConnectionTestClick,
        );
      },
    );
  }
}
