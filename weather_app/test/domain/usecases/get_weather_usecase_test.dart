import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/domain/domain.dart';

import '../../mocks/mocks.dart';
import 'get_weather_usecase_test.mocks.dart';

@GenerateMocks([IWeatherRepository])
void main() {
  late IGetWeatherUsecase sut;
  late MockIWeatherRepository repository;

  setUp(() {
    repository = MockIWeatherRepository();
    sut = GetWeatherUsecase(repository);
  });

  group('IGetWeatherUsecase - Usecase / ', () {
    test('Should call respository successfully', () async {
      // arrange
      when(repository.getWeather('curitiba')).thenAnswer((_) async => Right(WeatherFactory.makeEntity()));
      // act
      final result = await sut('curitiba');
      // assert
      expect(result, isA<Right>());
    });
    test('Should return left with WeatherFailure.unexpected when throws', () async {
      // arrange
      when(repository.getWeather('curitiba')).thenAnswer((_) async => Left(WeatherFailure.unexpected()));
      // act
      final result = await sut('curitiba');
      // assert
      expect(result, isA<Left>());
    });
  });
}
