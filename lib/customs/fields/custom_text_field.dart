import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizprogram/globals.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final Color? borderColor;
  final Color? iconColor;
  final bool isPassword;
  final int? maxLines;
  final String? labelText;
  final TextStyle? labelStyle;
  final FocusNode? focusNode; // Added FocusNode

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.fillColor,
    this.borderColor,
    this.iconColor,
    this.isPassword = false,
    this.maxLines = 1,
    this.labelText,
    this.labelStyle,
    this.focusNode, // Added FocusNode
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          setState(() {
            isFocused = true;
          });
        } else {
          setState(() {
            isFocused = false;
          });
        }
      },
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: screenSize * 0.013
          ),
          labelText: widget.labelText != null
              ? widget.controller.text.isNotEmpty || isFocused
              ? widget.labelText
              : widget.hintText
              : null,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: screenSize * 0.013,
              color: const Color(0xFF101010)
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: false,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: widget.iconColor)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: widget.iconColor ?? Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
          fillColor: widget.fillColor ?? const Color(0xFFf2f2f2),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor ?? const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.018,
              horizontal: screenWidth * 0.04
          ),
        ),
        keyboardType: widget.keyboardType,
        obscureText: _obscureText,
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
}
