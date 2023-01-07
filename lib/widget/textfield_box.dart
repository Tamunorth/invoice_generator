import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_invoice_generator/widget/pallets.dart';

class TextFieldBox extends StatelessWidget {
  const TextFieldBox({
    Key? key,
    required this.controller,
    this.label,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.prefix,
  }) : super(key: key);
  final TextEditingController controller;
  final String? label;
  final Widget? prefix;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(label ?? ''),
          SizedBox(height: 8),
          TextFormField(
            onTap: onTap,
            onFieldSubmitted: (value) async {
              // images.clear();
              // await getImage();
            },
            inputFormatters: inputFormatters,
            validator: validator,
            controller: controller,
            cursorColor: Pallets.primary,
            cursorWidth: 1.5,
            decoration: InputDecoration(
              prefix: prefix,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),

              labelText: label,

              labelStyle: TextStyle(
                color: Pallets.grey50,
              ),
              // hintText: label ?? 'Enter',
              // constraints: BoxConstraints(maxHeight: 40, minHeight: 40),

              hintStyle: TextStyle(
                color: Pallets.grey50,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Pallets.grey75,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Pallets.red,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),

              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Pallets.grey75,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Pallets.grey75,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
