import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/presentation/presentation.dart';

Future<void> makeTestableWidget(WidgetTester tester) async {
  await mockNetworkImagesFor(
    () async => await tester.pumpWidget(
      MaterialApp(
        home: DayTile(
          forecast: Forecast(day: '', maxTemp: 20, minTemp: 17, status: Status(description: '', image: '')),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('Components', () {
    testWidgets('Should find a Padding when component is called', (WidgetTester tester) async {
      //arrange
      await makeTestableWidget(tester);
      //act
      final Finder icon = find.byType(Padding);
      //assert
      expect(icon, findsOneWidget);
    });
    testWidgets('Should find a Row when component is called', (WidgetTester tester) async {
      //arrange
      await makeTestableWidget(tester);
      //act
      final Finder icon = find.byType(Row);
      //assert
      expect(icon, findsOneWidget);
    });
  });
  testWidgets('Should find a Container when component is called', (WidgetTester tester) async {
    //arrange
    await makeTestableWidget(tester);
    //act
    final Finder icon = find.byType(Container);
    //assert
    expect(icon, findsOneWidget);
  });
  testWidgets('Should find a Spacer when component is called', (WidgetTester tester) async {
    //arrange
    await makeTestableWidget(tester);
    //act
    final Finder icon = find.byType(Spacer);
    //assert
    expect(icon, findsOneWidget);
  });
  testWidgets('Should find a SizedBox when component is called', (WidgetTester tester) async {
    //arrange
    await makeTestableWidget(tester);
    //act
    final Finder icon = find.byType(SizedBox);
    //assert
    expect(icon, findsWidgets);
  });
  testWidgets('Should find a Text when component is called', (WidgetTester tester) async {
    //arrange
    await makeTestableWidget(tester);
    //act
    final Finder icon = find.byType(Text);
    //assert
    expect(icon, findsWidgets);
  });
}
