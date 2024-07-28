import 'package:clicks_outlet/constants/style.dart';
import 'package:flutter/material.dart';

class HashtagEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<InlineSpan> children = [];
    String text = this.text;

    int lastIndex = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ' ') {
        String word = text.substring(lastIndex, i);
        if (word.startsWith('#')) {
          children.add(
            WidgetSpan(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorsConst.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        } else {
          children.add(TextSpan(text: word));
        }
        children.add(TextSpan(text: ' '));
        lastIndex = i + 1;
      }
    }

    if (lastIndex < text.length) {
      children.add(TextSpan(text: text.substring(lastIndex)));
    }

    return TextSpan(style: style, children: children);
  }
}
