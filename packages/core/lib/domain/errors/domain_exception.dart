import '../interfaces/interfaces.dart';

///
/// Default Domain exception
///
class DomainException extends BaseException {
  ///
  /// Creates a new DomainException
  ///
  const DomainException({
    super.message = 'unexpectedError',
    super.cause,
    super.data,
  });

  @override
  List<Object?> get props => [cause, message, data];
}
