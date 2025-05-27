import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? labelText;
  final bool readOnly;
  final bool? enabled;
  final int? maxLine;
  final VoidCallback? onPressed;
  final Function(String)? onChanged;
  final bool isPassword;

  const TextFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    this.keyboard,
    this.labelText,
    this.readOnly = false,
    this.enabled,
    this.maxLine,
    this.onPressed,
    this.onChanged,
    this.isPassword = false
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        child: Text(
          widget.title,
          style: const TextStyle(color: Colors.pink, fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 6.0),
      TextFormField(
        cursorColor: Colors.pink,
        keyboardType: widget.keyboard,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.pink)
          ),
          suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.pink,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null
        ),
        readOnly: widget.readOnly,
        maxLines: widget.isPassword ? 1 : widget.maxLine,
        onTap: widget.onPressed,
        onChanged: widget.onChanged,
      ),
    ],
  );
}