import 'package:flutter/material.dart';

class FormHelper {
  static TextFormField textInput({
    required TextEditingController controller,
    required IconData icon,
    required String labelText,
    required TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    Widget? suffixIcon,
    bool? obscureText = false,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      style: TextStyle(color: Colors.white.withValues(alpha: .9), fontSize: 18.0),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(18),
        prefixIcon: Icon(icon, size: 30, color: Colors.white.withValues(alpha: .9)),
        errorStyle: const TextStyle(color: Color.fromARGB(255, 97, 8, 2), fontSize: 16),
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  static Container submitUIButton(BuildContext context, String title, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        child: Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}
