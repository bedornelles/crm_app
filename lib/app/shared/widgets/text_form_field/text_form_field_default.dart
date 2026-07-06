import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldDefault extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool temErro;
  final AnimationController? shakeController;
  final GlobalKey? fieldKey;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool mostrarContador;
  final TextCapitalization textCapitalization;

  const TextFormFieldDefault({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.textInputType,
    this.inputFormatters,
    this.temErro = false,
    this.shakeController,
    this.fieldKey,
    this.focusNode,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.mostrarContador = true,
    this.textCapitalization = TextCapitalization.none,

  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(fontWeight: FontWeight.w400),
      keyboardType: textInputType,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
        ...?inputFormatters,
      ],
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        counterText: mostrarContador ? null : '',
        border: temErro
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
        )
            : null,
      ),
    );

    if (shakeController != null) {
      field = AnimatedBuilder(
        animation: shakeController!,
        builder: (context, child) {
          final offset = sin(shakeController!.value * pi * 6) * 8;
          return Transform.translate(offset: Offset(offset, 0), child: child);
        },
        child: field,
      );
    }

    if (fieldKey != null) {
      field = KeyedSubtree(key: fieldKey, child: field);
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
        field,
      ],
    );
  }
}