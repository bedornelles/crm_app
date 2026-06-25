import 'package:flutter/material.dart';

class ConfirmacaoLogout {
  static Future<void> show(
      BuildContext context, {
        required VoidCallback onConfirmar,
      }) async {
    final theme = Theme.of(context);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Você tem certeza que deseja sair?',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                onConfirmar();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.check, color: theme.colorScheme.secondary),
                    const SizedBox(width: 16),
                    Text(
                      'Sim, desejo sair',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.grey.shade200),
            InkWell(
              onTap: () => Navigator.pop(ctx),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.undo, color: theme.colorScheme.secondary),
                    const SizedBox(width: 16),
                    Text(
                      'Voltar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}