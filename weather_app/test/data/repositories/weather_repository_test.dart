import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/data/data.dart';
import 'package:weather_app/domain/domain.dart';

import '../../mocks/mocks.dart';
import 'weather_repository_test.mocks.dart';

@GenerateMocks([IWeatherDatasource])
void main() {
  late IWeatherRepository sut;
  late MockIWeatherDatasource remoteDatasourceSpy;

  setUp(() {
    remoteDatasourceSpy = MockIWeatherDatasource();
    sut = WeatherRepository(remoteDatasourceSpy);
  });

  group('IWeatherRepository - Repository / ', () {
    test('Should call datasource successfully', () async {
      // arrange
      when(remoteDatasourceSpy.getWeather('curitiba')).thenAnswer((_) async => WeatherFactory.makeModel());
      // act
      final result = await sut.getWeather('curitiba');
      // assert
      expect(result, isA<Right>());
    });

    test('Should return left with WeatherFailure.unexpected when throws', () async {
      // arrange
      when(remoteDatasourceSpy.getWeather('curitiba')).thenAnswer((_) => throw Exception());
      // act
      final result = await sut.getWeather('curitiba');
      // assert
      expect(result, isA<Left>());
    });
  });
}
