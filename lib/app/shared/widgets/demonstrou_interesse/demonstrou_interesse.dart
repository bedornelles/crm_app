import 'dart:math';
import 'package:flutter/material.dart';

class DemonstrouInteresse extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool> onChanged;
  final bool temErro;
  final AnimationController? shakeController;
  final GlobalKey? fieldKey;

  const DemonstrouInteresse({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.temErro = false,
    this.shakeController,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderSide = temErro
        ? BorderSide(color: Colors.red.shade600, width: 1.5)
        : BorderSide.none;

    Widget botoes = Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              backgroundColor: value == true ? Colors.green : Colors.white,
              foregroundColor: value == true ? Colors.white : theme.colorScheme.secondary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: borderSide,
              ),
            ),
            onPressed: () => onChanged(true),
            icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
            label: const Text('Sim', style: TextStyle(fontSize: 15)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              backgroundColor: value == false ? theme.colorScheme.primary : Colors.white,
              foregroundColor: value == false ? Colors.white : theme.colorScheme.secondary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: borderSide,
              ),
            ),
            onPressed: () => onChanged(false),
            icon: const Icon(Icons.thumb_down_alt_outlined, size: 20),
            label: const Text('Não', style: TextStyle(fontSize: 15)),
          ),
        ),
      ],
    );

    if (shakeController != null) {
      botoes = AnimatedBuilder(
        animation: shakeController!,
        builder: (context, child) {
          final offset = sin(shakeController!.value * pi * 6) * 8;
          return Transform.translate(offset: Offset(offset, 0), child: child);
        },
        child: botoes,
      );
    }

    if (fieldKey != null) {
      botoes = KeyedSubtree(key: fieldKey, child: botoes);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        botoes,
      ],
    );
  }
}