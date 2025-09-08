import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final bool enabled;
  final String message;
  final TextStyle style;
  static const TextStyle _defaultStyle = TextStyle(color: Colors.black);

  ExpandableText(
    this.text, {
    super.key,
    this.maxLines = 2,
    this.enabled = true,
    this.message = "Leer más",
    TextStyle? style,
  }) : style = style != null ? _defaultStyle.merge(style) : _defaultStyle;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String message = '... ${widget.message}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final (String textToShow, bool isOverflowing) =
            _isExpanded ? (widget.text, false) : _truncateText(widget.text, widget.maxLines, constraints.maxWidth, message, widget.enabled);

        final TextSpan? link = widget.enabled && isOverflowing
            ? TextSpan(
                text: widget.message,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null;

        final RichText richText = RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: textToShow,
                style: widget.style,
              ),
              if (link != null) ...[TextSpan(text: '... ', style: widget.style), link] else const TextSpan(),
            ],
          ),
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded || widget.enabled ? TextOverflow.visible : TextOverflow.ellipsis,
        );

        return widget.enabled == false
            ? richText
            : GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: richText,
              );
      },
    );
  }

  (String, bool) _truncateText(String text, int maxLines, double maxWidth, String message, bool isEnabled) {
    final textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final messagePainter = TextPainter(
      text:
          TextSpan(text: ' $message', style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    if (textPainter.didExceedMaxLines && isEnabled) {
      int endIndex = textPainter.getPositionForOffset(Offset(maxWidth - messagePainter.width, textPainter.height)).offset;
      return (text.substring(0, endIndex), true);
    }

    return (text, false);
  }
}
