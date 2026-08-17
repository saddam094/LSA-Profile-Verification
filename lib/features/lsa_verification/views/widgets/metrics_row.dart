import 'package:flutter/material.dart';

class MetricsRow extends StatelessWidget {
  const MetricsRow({
    super.key,
    required this.frictionCount,
    required this.lastFrictionSeconds,
    required this.quarantineCount,
  });

  final int frictionCount;
  final int lastFrictionSeconds;
  final int quarantineCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Metric(
            icon: Icons.timer_outlined,
            label: 'Friction events',
            value: '$frictionCount',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Metric(
            icon: Icons.hourglass_bottom_outlined,
            label: 'Last stall',
            value: '${lastFrictionSeconds}s',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Metric(
            icon: Icons.lock_outline,
            label: 'Quarantined',
            value: '$quarantineCount',
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
