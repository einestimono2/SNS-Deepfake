import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final bool enableAutoHandle;
  final TextDirection textDirection;
  final String trimExpandedText;
  final String trimCollapsedText;

  const ExpandableText(
    this.text, {
    super.key,
    this.trimLines = 2,
    this.enableAutoHandle = false,
    this.textDirection = TextDirection.ltr,
    this.trimExpandedText = 'Show less',
    this.trimCollapsedText = 'Read more',
  });

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    const colorClickableText = Colors.blue;

    TextSpan link = TextSpan(
      text: _readMore ? "... " : " ",
      children: [
        if (_readMore)
          TextSpan(
            text: widget.trimExpandedText,
            style: const TextStyle(color: colorClickableText),
            recognizer: TapGestureRecognizer()..onTap = _onTapLink,
          )
        else
          TextSpan(
            text: widget.trimCollapsedText,
            style: const TextStyle(color: colorClickableText),
            recognizer: TapGestureRecognizer()..onTap = _onTapLink,
          )
      ],
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );

        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: widget.textDirection,
          maxLines: widget.trimLines,
          ellipsis: '...',
        );

        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));

        endIndex = textPainter.getOffsetBefore(pos.offset)!;
        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );

    return widget.enableAutoHandle
        ? GestureDetector(
            onTap: _onTapLink,
            child: result,
          )
        : result;
  }
}
