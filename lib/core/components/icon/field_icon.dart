import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FieldIcons {
  static Widget clearIcon({VoidCallback? onPressed}) {
    return IconButton(
      icon: const Icon(
        Symbols.cancel,
        fill: 1,
        color: FalletterColor.gray600,
      ),
      onPressed: onPressed,
    );
  }

  static Widget showPwIcon({VoidCallback? onPressed}) {
    return IconButton(
      icon: const Icon(
        Symbols.visibility,
        fill: 1,
        color: FalletterColor.gray600,
      ),
      onPressed: onPressed,
    );
  }

  static Widget hidePwIcon({VoidCallback? onPressed}) {
    return IconButton(
      icon: const Icon(
        Symbols.visibility_off,
        fill: 1,
        color: FalletterColor.gray600,
      ),
      onPressed: onPressed,
    );
  }

  static Widget emailText() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        '@dsm.hs.kr',
        style: FalletterTextStyle.body2.copyWith(color: FalletterColor.gray500),
      ),
    );
  }
}