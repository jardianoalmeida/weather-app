import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateTime sut;

  setUp(() {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting('pt_BR', null);
  });

  test('Should return in format MMMd', () {
    sut = DateTime(2024, 1, 26);
    expect(sut.format('MMMMd'), '26 de janeiro');
  });

  test('The day of the week should return the same as Friday', () {
    sut = DateTime(2024, 1, 26);
    expect(sut.dayName, 'Sexta-feira');
  });
}
