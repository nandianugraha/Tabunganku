import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultText extends StatefulWidget {

  final int maxLines;
  final String textLabel;
  final Color colorsText;
  final Color colorbackground;
  final double sizeText;
  final double height;
  final double width;
  final Alignment alignment;
  final BorderRadius borderRadius;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextOverflow textOverflow;
  final TextAlign textAlign;
  final Border border;
  final List<BoxShadow> boxShadow;
  final bool softWrap;


  DefaultText({
    this.maxLines,
    this.textLabel,
    this.colorsText,
    this.sizeText,
    this.colorbackground,
    this.width,
    this.height,
    this.alignment,
    this.borderRadius,
    this.fontWeight,
    this.padding,
    this.margin,
    this.fontStyle,
    this.textOverflow,
    this.textAlign,
    this.border,
    this.boxShadow,
    this.softWrap
});

  @override
  _DefaultText createState() => _DefaultText();

}

class _DefaultText extends State<DefaultText> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      height: widget.height,
      width: widget.width,
      alignment: widget.alignment,
      decoration: BoxDecoration(
        color: widget.colorbackground,
        borderRadius: widget.borderRadius,
        border: widget.border,
        boxShadow: widget.boxShadow
      ),
      child: widget.textLabel == null ? widget.textLabel :
      Text(
        widget.textLabel == null ? '' : widget.textLabel,
        overflow: widget.textOverflow != null ? widget.textOverflow : null ,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines == null ? 1 : widget.maxLines,
        softWrap: widget.softWrap,
        style: TextStyle(
          color: widget.colorsText,
          // fontFamily: Fonts.avenir,
          fontSize: widget.sizeText,
          fontWeight: widget.fontWeight,
          fontStyle: widget.fontStyle,
        ),
      ),
    );
  }
}