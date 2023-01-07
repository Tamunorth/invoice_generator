import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:store_invoice_generator/api/pdf_api.dart';
import 'package:store_invoice_generator/api/pdf_invoice_api.dart';
import 'package:store_invoice_generator/model/customer.dart';
import 'package:store_invoice_generator/model/invoice.dart';
import 'package:store_invoice_generator/model/supplier.dart';
import 'package:store_invoice_generator/validators.dart';
import 'package:store_invoice_generator/widget/textfield_box.dart';

class InputEntriesPage extends StatefulWidget {
  const InputEntriesPage(
      {Key? key, required this.clientName, required this.clientAddress})
      : super(key: key);
  final String clientName;
  final String clientAddress;

  @override
  State<InputEntriesPage> createState() => _InputEntriesPageState();
}

class _InputEntriesPageState extends State<InputEntriesPage> {
  final TextEditingController dateCtrl = TextEditingController();

  final TextEditingController descriptionCtrl = TextEditingController();

  final TextEditingController qtyCtrl = TextEditingController();

  final TextEditingController unitPriceCtrl = TextEditingController();

  final ValueNotifier<List<InvoiceItem>> invoiceItems = ValueNotifier([]);

  final GlobalKey<FormState> _formKey = GlobalKey();

  // final TextEditingController titleCtrl = TextEditingController();

  Future<void> generateInvoice(List<InvoiceItem>? items) async {
    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));

    final invoice = Invoice(
      supplier: const Supplier(
        name: 'Pallas Place',
        address:
            '33 George Innih Street, Apo legislative quarters, Zone E, Abuja.',
        paymentInfo: '',
      ),
      customer: Customer(
        name: widget.clientName,
        address: widget.clientAddress,
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'My description...',
        number:
            '${DateTime.now().year}-${((DateTime.now().millisecondsSinceEpoch) / 15000).toInt()}',
      ),
      items: [
        ...?items,
      ],
    );

    final pdfFile = await PdfInvoiceApi.generate(invoice);

    PdfApi.openFile(pdfFile);
  }

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
                    ValueListenableBuilder(
                        valueListenable: invoiceItems,
                        builder: (context, List<InvoiceItem> value, child) {
                          return value.isEmpty
                              ? InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_sharp,
                                    // color: Colors.blue,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    invoiceItems.value = [];
                                  },
                                  child: Text(
                                    'Clear all',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                        }),
                    InkWell(
                      onTap: () async {
                        if (invoiceItems.value.isNotEmpty) {
                          await generateInvoice(invoiceItems.value);
                          //   Navigator.of(context)
                          //       .push(MaterialPageRoute(builder: (context) {
                          //     return PdfPage(
                          //       items: invoiceItems.value,
                          //     );
                          //   }));
                        }
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.blue,
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
                  label: 'Description',
                  controller: descriptionCtrl,
                ),
                TextFieldBox(
                  prefix: Text('₦ '),
                  validator: Validators.validateDouble(),
                  label: 'Unit Price',
                  controller: unitPriceCtrl,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyTextInputFormatter(decimalDigits: 0)
                  ],
                ),
                TextFieldBox(
                  validator: Validators.validateInt(),
                  label: 'Quantity',
                  controller: qtyCtrl,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyTextInputFormatter(decimalDigits: 0)
                  ],
                ),
                TextFieldBox(
                  validator: Validators.validateString(),
                  label: 'Date',
                  controller: dateCtrl,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blue, // <-- SEE HERE
                              onPrimary: Colors.white, // <-- SEE HERE
                              onSurface: Colors.black, // <-- SEE HERE
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                primary: Colors.blue, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    dateCtrl.text =
                        date?.toIso8601String().substring(0, 10) ?? '';
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    log('Save');

                    if (_formKey.currentState!.validate()) {
                      invoiceItems.value = [
                        ...invoiceItems.value,
                        InvoiceItem(
                          description: descriptionCtrl.text.trim(),
                          date: DateTime.now(),
                          quantity: int.tryParse(qtyCtrl.text.trim()) ?? 1,
                          vat: double.parse('0.0'),
                          unitPrice:
                              double.tryParse(unitPriceCtrl.text.trim()) ?? 1,
                        ),
                      ];

                      descriptionCtrl.clear();
                      qtyCtrl.clear();
                      unitPriceCtrl.clear();
                      dateCtrl.clear();
                    }

                    // setState(() {});
                    //
                    log(invoiceItems.value.toString());
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
                        'ADD ITEM',
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
                ValueListenableBuilder(
                    valueListenable: invoiceItems,
                    builder: (context, value, child) {
                      return Column(
                        children: invoiceItems.value
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          child: Text(e.description)),
                                      Text(e.quantity.toString()),
                                      Text(e.unitPrice.toString()),
                                      GestureDetector(
                                        onTap: () {
                                          var modifiedList = invoiceItems.value;

                                          modifiedList.remove(e);

                                          invoiceItems.value = [
                                            ...modifiedList
                                          ];

                                          // invoiceItems.value = [
                                          //   ...invoiceItems.value,
                                          //   InvoiceItem(
                                          //     description: descriptionCtrl.text.trim(),
                                          //     date: DateTime.now(),
                                          //     quantity: 21,
                                          //     vat: 12,
                                          //     unitPrice: 1222,
                                          //   ),
                                          // ];
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
