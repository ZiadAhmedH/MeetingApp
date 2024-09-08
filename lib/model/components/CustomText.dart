import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextBaseline? textBaseline;
  const CustomText({super.key, 
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontStyle,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration, this.decorationColor, this.decorationThickness, this.textBaseline
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        overflow: overflow,
        decoration:decoration ,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        textBaseline: textBaseline,
        fontSize: fontSize ?? 14.0, // Default font size is 14.0 if not provided
        fontWeight: fontWeight ?? FontWeight.normal, // Default is normal weight
        color: color ?? Colors.black, // Default color is black if not provided
        fontStyle: fontStyle ?? FontStyle.normal, // Default is normal style
        fontFamily: 'Gilroy', // No default font family
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
    );
  }
}