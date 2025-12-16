import 'dart:collection';
import 'dart:math';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:ir_net/main.dart';
import 'package:ir_net/utils/cmd.dart';
import 'package:ir_net/widgets/modern_widgets.dart';

class IpStatView extends StatefulWidget {
  const IpStatView({super.key});

  @override
  State<IpStatView> createState() => _IpStatViewState();
}

class _IpStatViewState extends State<IpStatView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Network Information',
            icon: Icons.public,
          ),
          const SizedBox(height: 16),
          lookupResult(),
          const SizedBox(height: 16),
          networkInfo(),
        ],
      ),
    );
  }

  Widget networkInfo() {
    return StreamBuilder<LocalNetworksResult>(
      stream: bloc.localNetwork,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ipAddress(),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.dns,
              label: 'DNS Servers',
              value: '${data.dns[0]}\n${data.dns[1]}',
              color: const Color(0xFF0EA5E9),
            ),
            const SizedBox(height: 12),
            ..._buildLocalIpCards(data.interfaces),
          ],
        );
      },
    );
  }

  List<Widget> _buildLocalIpCards(List<NetworkInterface> interfaces) {
    return interfaces.map((inf) {
      var interfaceName = inf.interfaceName;
      if (interfaceName.length > 20) {
        interfaceName = "${interfaceName.substring(0, 10)}...${interfaceName.substring(interfaceName.length - 7)}";
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildInfoCard(
          icon: Icons.network_check,
          label: 'Local IP ($interfaceName)',
          value: inf.ipv4,
          color: const Color(0xFF10B981),
        ),
      );
    }).toList();
  }

  Widget ipAddress() {
    return StreamBuilder<dynamic>(
      stream: bloc.ipLookupResult,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const ShimmerLoading(
            width: double.infinity,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          );
        }
        return _buildInfoCard(
          icon: Icons.public,
          label: 'Public IP Address',
          value: data['query'],
          color: const Color(0xFF3B82F6),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget lookupResult() {
    return StreamBuilder<dynamic>(
      stream: bloc.ipLookupResult,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return Column(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ShimmerLoading(
                  width: double.infinity,
                  height: 50,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          );
        }

        final map = data as LinkedHashMap;
        final countryCode = map['countryCode'];
        final entries = map.entries
            .where((e) => e.key != 'lat' && e.key != 'lon' && e.key != 'query' && e.key != 'countryCode')
            .toList();
        
        if (entries.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Column(
                children: entries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final e = entry.value;
                  
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              e.key.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${e.value}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                if (e.key == 'country') ...[
                                  const SizedBox(width: 12),
                                  CountryFlag.fromCountryCode(
                                    countryCode,
                                    theme: const ImageTheme(
                                      height: 20,
                                      width: 30,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
