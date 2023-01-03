import 'package:intl/intl.dart';
import 'package:store_invoice_generator/api/pdf_invoice_api.dart';

class Utils {
  static formatPrice(double price) => '$naira ${price.toStringAsFixed(2)}';

  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
