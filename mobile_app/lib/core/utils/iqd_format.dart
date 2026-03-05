/// Iraqi Dinar formatting for display.
String formatIQD(int amount) {
  if (amount >= 1000) {
    final k = amount ~/ 1000;
    final rest = amount % 1000;
    if (rest == 0) return '$k,000 د.ع';
    return '$k,${rest.toString().padLeft(3, '0')} د.ع';
  }
  return '$amount د.ع';
}
