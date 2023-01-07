import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_invoice_generator/model/invoice.dart';
import 'package:store_invoice_generator/page/input_entries_page.dart';
import 'package:store_invoice_generator/validators.dart';
import 'package:store_invoice_generator/widget/textfield_box.dart';

class InputClientDetailsPage extends StatefulWidget {
  const InputClientDetailsPage({Key? key}) : super(key: key);

  @override
  State<InputClientDetailsPage> createState() => _InputClientDetailsPageState();
}

class _InputClientDetailsPageState extends State<InputClientDetailsPage> {
  final TextEditingController dateCtrl = TextEditingController();

  final TextEditingController nameCtrl = TextEditingController();

  final TextEditingController qtyCtrl = TextEditingController();

  final TextEditingController addressCtrl = TextEditingController();

  final ValueNotifier<List<InvoiceItem>> invoiceItems = ValueNotifier([]);

  final GlobalKey<FormState> _formKey = GlobalKey();

  // final TextEditingController titleCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        nameCtrl.clear();
                        addressCtrl.clear();
                      },
                      child: Text(
                        'Clear all',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldBox(
                  validator: Validators.validateString(),
                  label: 'Customers Name',
                  controller: nameCtrl,
                ),
                TextFieldBox(
                  validator: Validators.validateString(),
                  label: 'Customers Address',
                  controller: addressCtrl,
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    // log('Save');

                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return InputEntriesPage(
                              clientName: nameCtrl.text.trim(),
                              clientAddress: addressCtrl.text.trim(),
                            );
                          },
                        ),
                      );
                    }

                    // setState(() {});
                    //
                    // log(invoiceItems.value.toString());
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
