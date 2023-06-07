<<<<<<< HEAD
=======
import 'package:flutter/cupertino.dart';
>>>>>>> 6e5253a (setup newest view for addtodo)
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
<<<<<<< HEAD
    required this.maxLine,
    required this.hintText, 
    required this.txtController,
=======
    required this.maxLine, required this.hintText,
>>>>>>> 6e5253a (setup newest view for addtodo)
  });

  final int maxLine;
  final String hintText;
<<<<<<< HEAD
  final TextEditingController txtController;
=======
>>>>>>> 6e5253a (setup newest view for addtodo)

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
<<<<<<< HEAD
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
        ),
        maxLines: maxLine,
=======
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
           ),
           maxLines: maxLine,
>>>>>>> 6e5253a (setup newest view for addtodo)
      ),
    );
  }
}
