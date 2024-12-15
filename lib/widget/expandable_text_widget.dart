import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final Color color;
  final bool enabled;
  final String message;

  const ExpandableText(
      {super.key,
      required this.text,
      this.maxLines = 2,
      this.color = Colors.black,
      this.enabled = true,
      this.message = "Leer más"});

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    TextSpan link = TextSpan(
      text: widget.message,
      style: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
      ),
    );

    final String textToShow =
        _isExpanded ? widget.text : _truncateText(widget.text, widget.maxLines);

    return GestureDetector(
      onTap: widget.enabled
          ? () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }
          : null,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: textToShow,
              style: TextStyle(
                color: widget.color,
              ),
            ),
            if (widget.enabled && !_isExpanded) link,
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLines) {
    final textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    if (textPainter.didExceedMaxLines) {
      final pos = textPainter.getPositionForOffset(
        Offset(textPainter.width, textPainter.height),
      );
      return '${text.substring(0, pos.offset)}...';
    }

    return text;
  }
}
