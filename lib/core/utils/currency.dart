String formatUsd(num? value) {
  if (value == null) return '-';

  final amount = value.toStringAsFixed(2);
  final parts = amount.split('.');
  final integer = parts.first;
  final fraction = parts.length > 1 ? parts[1] : '00';

  final withSeparators = integer.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
  );

  return '\$$withSeparators.$fraction';
}

double? tryParseDouble(String? source) {
  if (source == null || source.isEmpty) return null;
  return double.tryParse(source);
}
