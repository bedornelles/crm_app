import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeAheadFieldDefault extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onChanged;
  final Future<List<String>> Function(String) suggestionsCallback;
  final ValueChanged<String> onSelected;
  final bool temErro;
  final AnimationController? shakeController;
  final GlobalKey? fieldKey;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool mostrarContador;

  const TypeAheadFieldDefault({
    super.key,
    required this.label,
    required this.controller,
    required this.suggestionsCallback,
    required this.onSelected,
    this.hintText,
    this.validator,
    this.onChanged,
    this.temErro = false,
    this.shakeController,
    this.fieldKey,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.mostrarContador = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget field = TypeAheadField<String>(
      controller: controller,
      emptyBuilder: (context) => const SizedBox.shrink(),
      decorationBuilder: (context, child) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        elevation: 4,
        child: child,
      ),
      builder: (context, textController, focusNode) => TextFormField(
        controller: textController,
        focusNode: focusNode,
        style: const TextStyle(fontWeight: FontWeight.w400),
        validator: validator,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'^\s')),
          ...?inputFormatters,
        ],
        maxLength: maxLength,
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
      ),
      suggestionsCallback: suggestionsCallback,
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion));
      },
      onSelected: onSelected,
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