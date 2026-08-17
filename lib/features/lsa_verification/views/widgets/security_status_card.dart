import 'package:flutter/material.dart';

class SecurityStatusCard extends StatelessWidget {
  const SecurityStatusCard({
    super.key,
    required this.statusLabel,
    required this.statusMessage,
    required this.statusColor,
    required this.traceId,
    required this.logicHash,
  });

  final String statusLabel;
  final String statusMessage;
  final Color statusColor;
  final String traceId;
  final String logicHash;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: statusColor),
              const SizedBox(width: 8),
              Text(
                statusLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (statusMessage.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(statusMessage),
          ],
          if (traceId.isNotEmpty) ...[
            const SizedBox(height: 14),
            _MetaRow(label: 'trace_id', value: traceId),
            const SizedBox(height: 6),
            _MetaRow(
              label: 'logic_hash',
              value: logicHash,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
