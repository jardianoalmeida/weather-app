// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

///
/// Checks if [action] throws a exception of type [T] and check it's content
///
void expectException(
  Future action,
  Object current,
) {
  expect(
    action,
    throwsA(
      predicate(
        (error) => error == current,
        'is equals to ${current.toString()}',
      ),
    ),
  );
}
