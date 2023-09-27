import 'package:flutter/material.dart';

/// Button Widget
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.onPressed,
    required this.buttonTitle,
    super.key,
    this.padding,
  });

  /// method that handles onPressed functionality
  final void Function()? onPressed;

  /// Title of Button
  final String buttonTitle;

  /// padding provided for title text
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        child: Padding(
          padding: padding == null ? const EdgeInsets.all(8) : padding!,
          child: Text(buttonTitle),
        ),
      );
}
