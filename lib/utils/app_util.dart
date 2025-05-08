import 'package:appli_ap_sante/utils/logger.dart';
import 'package:intl/intl.dart';

class AppUtil {
  static String formatAmount(
    String amount, {
    String selectedCurrency = '',
  }) {
    try {
      final doubleAmout = double.tryParse(amount);
      final intAmount = double.tryParse(amount)?.toInt();
      final finalAmout = doubleAmout == intAmount ? intAmount : doubleAmout;
      final decimalDigits =
          "$finalAmout".split('.').elementAtOrNull(1)?.length ?? 0;
      return NumberFormat.currency(
        locale: 'fr',
        symbol: selectedCurrency,
        decimalDigits: decimalDigits,
      ).format(finalAmout);
    } catch (e) {
      AppLogger.e('Error to parse $amount',
          error: e, functionName: 'formatAmount');
    }
    return '***';
    // NumberFormat.decimalPattern('fr').format(getItem.loyer)
  }
}
