import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;

  const ExpandableText({super.key, required this.text, this.maxLength = 250});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.length <= widget.maxLength) {
      return Text(widget.text, style: TextStyle(fontSize: 14, height: 1.5));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isExpanded
              ? widget.text
              : '${widget.text.substring(0, widget.maxLength)}...',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Show Less' : 'View More',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
