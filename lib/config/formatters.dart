/// Formatea números con punto de miles: 52321152 → "52.321.152".
String formatNumber(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    // Cada 3 cifras contando desde la derecha va un punto.
    final fromRight = digits.length - i;
    if (i > 0 && fromRight % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Traduce el nombre de la región que manda la API (en inglés).
String regionName(String region) {
  const names = {
    'americas': 'América',
    'europe': 'Europa',
    'africa': 'África',
    'asia': 'Asia',
    'oceania': 'Oceanía',
    'antarctic': 'Antártida',
  };
  return names[region.toLowerCase()] ?? region;
}
