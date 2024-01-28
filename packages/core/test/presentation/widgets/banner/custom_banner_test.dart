import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget makeTestableWidget() => const CustomBanner(
      message: 'DEV',
      child: SizedBox.shrink(),
    );

void main() {
  group('CustomBanner - Widget Test / ', () {
    group('Smoke test', () {
      testWidgets('Should find a Directionality when component is called', (WidgetTester tester) async {
        //arrange
        await tester.pumpWidget(makeTestableWidget());
        //act
        final Finder component = find.byType(Directionality);
        //assert
        expect(component, findsOneWidget);
      });
      testWidgets('Should find a Banner when component is called', (WidgetTester tester) async {
        //arrange
        await tester.pumpWidget(makeTestableWidget());
        //act
        final Finder component = find.byType(Banner);
        //assert
        expect(component, findsOneWidget);
      });
      testWidgets('Should find a SizedBox when component is called', (WidgetTester tester) async {
        //arrange
        await tester.pumpWidget(makeTestableWidget());
        //act
        final Finder component = find.byType(SizedBox);
        //assert
        expect(component, findsOneWidget);
      });
    });
    group('Colors', () {
      testWidgets('Should find Color(0xFF0586F6) on puller color when component is called', (WidgetTester tester) async {
        //arrange
        await tester.pumpWidget(makeTestableWidget());
        //act
        final Finder component = find.byType(Banner).last;
        final Banner color = tester.widget(component);
        //assert
        expect(color.color, const Color(0xFF0586F6));
      });
    });
  });
}
