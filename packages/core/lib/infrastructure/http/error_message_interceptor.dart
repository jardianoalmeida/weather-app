// coverage:ignore-file
import '../../data/data.dart';

/// Interceptor to extract http error message
class ErrorMessageInterceptor extends HttpInterceptor {
  @override
  void onError(
    HttpOptions request,
    IHttpException exception,
  ) {
    switch (exception.status) {
      case HttpStatus.continue_:
        // TODO: Handle this case.
        break;
      case HttpStatus.switchingProtocols:
        // TODO: Handle this case.
        break;
      case HttpStatus.processing:
        // TODO: Handle this case.
        break;
      case HttpStatus.ok:
        // TODO: Handle this case.
        break;
      case HttpStatus.created:
        // TODO: Handle this case.
        break;
      case HttpStatus.accepted:
        // TODO: Handle this case.
        break;
      case HttpStatus.noContent:
        // TODO: Handle this case.
        break;
      case HttpStatus.nonAuthoritativeInformation:
        // TODO: Handle this case.
        break;
      case HttpStatus.resetContent:
        // TODO: Handle this case.
        break;
      case HttpStatus.partialContent:
        // TODO: Handle this case.
        break;
      case HttpStatus.multiStatus:
        // TODO: Handle this case.
        break;
      case HttpStatus.alreadyReported:
        // TODO: Handle this case.
        break;
      case HttpStatus.imUsed:
        // TODO: Handle this case.
        break;
      case HttpStatus.multipleChoices:
        // TODO: Handle this case.
        break;
      case HttpStatus.movedPermanently:
        // TODO: Handle this case.
        break;
      case HttpStatus.found:
        // TODO: Handle this case.
        break;
      case HttpStatus.movedTemporarily:
        // TODO: Handle this case.
        break;
      case HttpStatus.seeOther:
        // TODO: Handle this case.
        break;
      case HttpStatus.notModified:
        // TODO: Handle this case.
        break;
      case HttpStatus.useProxy:
        // TODO: Handle this case.
        break;
      case HttpStatus.temporaryRedirect:
        // TODO: Handle this case.
        break;
      case HttpStatus.permanentRedirect:
        // TODO: Handle this case.
        break;
      case HttpStatus.badRequest:
        // TODO: Handle this case.
        break;
      case HttpStatus.unauthorized:
        // TODO: Handle this case.
        break;
      case HttpStatus.paymentRequired:
        // TODO: Handle this case.
        break;
      case HttpStatus.forbidden:
        // TODO: Handle this case.
        break;
      case HttpStatus.notFound:
        // TODO: Handle this case.
        break;
      case HttpStatus.methodNotAllowed:
        // TODO: Handle this case.
        break;
      case HttpStatus.notAcceptable:
        // TODO: Handle this case.
        break;
      case HttpStatus.proxyAuthenticationRequired:
        // TODO: Handle this case.
        break;
      case HttpStatus.gatewayTimeout:
      case HttpStatus.networkConnectTimeoutError:
      case HttpStatus.requestTimeout:
        // TODO: Handle this case.
        break;
      case HttpStatus.conflict:
        // TODO: Handle this case.
        break;
      case HttpStatus.gone:
        // TODO: Handle this case.
        break;
      case HttpStatus.lengthRequired:
        // TODO: Handle this case.
        break;
      case HttpStatus.preconditionFailed:
        // TODO: Handle this case.
        break;
      case HttpStatus.requestEntityTooLarge:
        // TODO: Handle this case.
        break;
      case HttpStatus.requestUriTooLong:
        // TODO: Handle this case.
        break;
      case HttpStatus.unsupportedMediaType:
        // TODO: Handle this case.
        break;
      case HttpStatus.requestedRangeNotSatisfiable:
        // TODO: Handle this case.
        break;
      case HttpStatus.expectationFailed:
        // TODO: Handle this case.
        break;
      case HttpStatus.misdirectedRequest:
        // TODO: Handle this case.
        break;
      case HttpStatus.unprocessableEntity:
        // TODO: Handle this case.
        break;
      case HttpStatus.locked:
        // TODO: Handle this case.
        break;
      case HttpStatus.failedDependency:
        // TODO: Handle this case.
        break;
      case HttpStatus.upgradeRequired:
        // TODO: Handle this case.
        break;
      case HttpStatus.preconditionRequired:
        // TODO: Handle this case.
        break;
      case HttpStatus.tooManyRequests:
        // TODO: Handle this case.
        break;
      case HttpStatus.requestHeaderFieldsTooLarge:
        // TODO: Handle this case.
        break;
      case HttpStatus.connectionClosedWithoutResponse:
        // TODO: Handle this case.
        break;
      case HttpStatus.unavailableForLegalReasons:
        // TODO: Handle this case.
        break;
      case HttpStatus.clientClosedRequest:
        // TODO: Handle this case.
        break;
      case HttpStatus.serverError:
        // TODO: Handle this case.
        break;
      case HttpStatus.internalServerError:
        // TODO: Handle this case.
        break;
      case HttpStatus.notImplemented:
        // TODO: Handle this case.
        break;
      case HttpStatus.badGateway:
        // TODO: Handle this case.
        break;
      case HttpStatus.serviceUnavailable:
        // TODO: Handle this case.
        break;
      case HttpStatus.httpVersionNotSupported:
        // TODO: Handle this case.
        break;
      case HttpStatus.variantAlsoNegotiates:
        // TODO: Handle this case.
        break;
      case HttpStatus.insufficientStorage:
        // TODO: Handle this case.
        break;
      case HttpStatus.loopDetected:
        // TODO: Handle this case.
        break;
      case HttpStatus.notExtended:
        // TODO: Handle this case.
        break;
      case HttpStatus.networkAuthenticationRequired:
        // TODO: Handle this case.
        break;
      default:
        break;
    }
  }
}
