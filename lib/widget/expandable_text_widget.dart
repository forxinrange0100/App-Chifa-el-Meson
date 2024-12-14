import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final Color color;
  final bool enabled;

  const ExpandableText(
      {super.key,
      required this.text,
      this.maxLines = 3,
      this.color = Colors.black,
      this.enabled = true});

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.enabled
              ? () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              : null,
          child: Text(
            widget.text,
            maxLines: _isExpanded ? null : widget.maxLines,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(color: widget.color),
          ),
        )
      ],
    );
  }
}
