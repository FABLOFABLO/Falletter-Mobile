import 'package:falletter/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DeleteCommentButton extends StatefulWidget {
  final VoidCallback onPressed;

  const DeleteCommentButton({
    super.key,
    required this.onPressed
  });

  @override
  State<DeleteCommentButton> createState() => _DeleteCommentButtonState();
}

class _DeleteCommentButtonState extends State<DeleteCommentButton> {
  bool _isPressed = false;

  void _tapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _tapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _tapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTapCancel: _tapCancel,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isPressed ?  FalletterColor.error : FalletterColor.middleBlack,
          shape: BoxShape.circle,
        ),
        child: Icon(Symbols.delete, color: _isPressed ? FalletterColor.white : FalletterColor.gray400),
      ),
    );
  }
}
