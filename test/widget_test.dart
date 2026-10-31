import 'package:flutter_test/flutter_test.dart';
import 'package:paises_app/config/formatters.dart';

void main() {
  test('formatNumber pone punto de miles', () {
    expect(formatNumber(0), '0');
    expect(formatNumber(999), '999');
    expect(formatNumber(1000), '1.000');
    expect(formatNumber(52321152), '52.321.152');
  });

  test('regionName traduce las regiones', () {
    expect(regionName('Americas'), 'América');
    expect(regionName('Desconocida'), 'Desconocida');
  });
}
