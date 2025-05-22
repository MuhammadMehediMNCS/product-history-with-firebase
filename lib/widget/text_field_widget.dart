import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? labelText;
  final bool readOnly;
  final bool? enabled;
  final int? maxLine;
  final VoidCallback? onPressed;
  final Function(String)? onChanged;

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
    this.onChanged
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(color: Colors.pink, fontFamily: 'NotoSansBengali-Regular', fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 6.0),
      TextFormField(
        cursorColor: Colors.pink,
        keyboardType: keyboard,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.pink)
          ),
        ),
        readOnly: readOnly,
        maxLines: maxLine,
        onTap: onPressed,
        onChanged: onChanged,
      ),
    ],
  );
}