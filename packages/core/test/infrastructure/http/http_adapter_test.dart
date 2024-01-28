import 'dart:async';
import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart' as local;

class MockInterceptor extends Mock {
  dynamic call(dynamic data);
}

@GenerateMocks([
  io.HttpClient,
  io.HttpClientResponse,
  io.HttpHeaders,
  io.HttpClientRequest,
  HttpInterceptor,
])
void main() {
  late IHttpClient sut;
  late local.MockHttpClient httpClientSpy;
  late local.MockHttpClientResponse httpResponseSpy;
  late local.MockHttpHeaders httpHeadersSpy;
  late local.MockHttpClientRequest httpRequestSpy;
  late StreamController<List<int>> ctrl;
  late Duration timeout;

  void mockHttpClient() {
    when(httpClientSpy.postUrl(any)).thenAnswer((_) async => httpRequestSpy);
    when(httpClientSpy.getUrl(any)).thenAnswer((_) async => httpRequestSpy);
    when(httpClientSpy.patchUrl(any)).thenAnswer((_) async => httpRequestSpy);
    when(httpClientSpy.putUrl(any)).thenAnswer((_) async => httpRequestSpy);
    when(httpClientSpy.deleteUrl(any)).thenAnswer((_) async => httpRequestSpy);

    when(httpRequestSpy.headers).thenReturn(httpHeadersSpy);
    when(httpRequestSpy.close()).thenAnswer((_) async => httpResponseSpy);
  }

  void mockResponse(int status, [String? response, String? reason]) {
    when(httpResponseSpy.statusCode).thenReturn(status);

    if (reason != null) {
      when(httpResponseSpy.reasonPhrase).thenReturn(reason);
    }

    when(httpResponseSpy.transform(any)).thenAnswer(
      (_) => Stream<String>.fromIterable([
        if (response != null) response,
      ]),
    );
  }

  void mockRequestException() {
    when(httpRequestSpy.close()).thenThrow(Exception('forced exception'));
  }

  void mockResponseException(String reason) {
    when(httpResponseSpy.reasonPhrase).thenReturn(reason);
    when(httpResponseSpy.statusCode).thenReturn(400);
    when(httpResponseSpy.transform(any)).thenAnswer(
      (real) => ctrl.stream.transform(real.positionalArguments[0]),
    );
    ctrl.addError(Exception(reason));
  }

  setUp(() {
    httpClientSpy = local.MockHttpClient();
    httpResponseSpy = local.MockHttpClientResponse();
    httpHeadersSpy = local.MockHttpHeaders();
    httpRequestSpy = local.MockHttpClientRequest();
    ctrl = StreamController<List<int>>();
    timeout = const Duration(milliseconds: 10);

    sut = HttpAdapter(
      client: httpClientSpy,
      baseUrl: 'http://base-url.com/',
    );

    mockHttpClient();
  });

  group('post', () {
    late String responseData;
    late Object? responseObject;

    setUp(() {
      responseData = '{"any-key":"any-value"}';
      responseObject = {'any-key': 'any-value'};

      mockResponse(200, responseData);
    });

    test('Deve fazer a request com os parâmetros corretos', () async {
      final url = faker.internet.httpsUrl();

      await sut.post(
        url,
        body: {'any-key': 'any-value'},
        headers: {'any-key': 'any-value'},
        timeout: timeout,
      );

      verify(httpClientSpy.connectionTimeout = timeout).called(1);
      verify(httpRequestSpy.write('{"any-key":"any-value"}')).called(1);
      verify(
        httpHeadersSpy.set(
          'content-type',
          'application/json; charset=utf-8',
        ),
      ).called(1);
      verify(httpHeadersSpy.set('accept', 'application/json')).called(1);
      verify(httpHeadersSpy.set('any-key', 'any-value')).called(1);
      verifyNever(httpClientSpy.postUrl(Uri.parse(url))).called(0);
    });

    test('Deve fazer a request com os parâmetros corretos, sobrescrevendo headers', () async {
      final sut = HttpAdapter(
        client: httpClientSpy,
        headers: {'default-header': 'default-value'},
        baseUrl: 'http://base-url.com/',
      );
      await sut.post(
        faker.internet.httpsUrl(),
        body: {'any-key': 'any-value'},
        headers: {'any-key': 'any-value'},
        timeout: timeout,
      );

      verify(httpClientSpy.connectionTimeout = timeout).called(1);
      verify(httpRequestSpy.write('{"any-key":"any-value"}')).called(1);
      verify(httpHeadersSpy.set('default-header', 'default-value')).called(1);
      verify(httpHeadersSpy.set('any-key', 'any-value')).called(1);
    });

    test('Deve fazer a request com os parâmetros corretos usando baseUrl', () async {
      final sut = HttpAdapter(
        client: httpClientSpy,
        baseUrl: 'http://base-url.com/',
      );
      await sut.post(
        'endpoint',
        body: {'any-key': 'any-value'},
        headers: {'any-key': 'any-value'},
        timeout: timeout,
      );

      verify(httpClientSpy.connectionTimeout = timeout).called(1);
      verify(httpRequestSpy.write('{"any-key":"any-value"}')).called(1);
      verify(
        httpHeadersSpy.set(
          'content-type',
          'application/json; charset=utf-8',
        ),
      ).called(1);
      verify(httpHeadersSpy.set('accept', 'application/json')).called(1);
      verify(httpHeadersSpy.set('any-key', 'any-value')).called(1);
      verifyNever(
        httpClientSpy.postUrl(Uri.parse('http://base-url.com/endpoint')),
      ).called(0);
    });

    test('Deve fazer a request e receber um objeto simples', () async {
      responseData = faker.lorem.words(10).join(' ');
      responseObject = responseData;
      mockResponse(201, responseData);

      final response = await sut.post(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve fazer a request com os parâmetros corretos sem body', () async {
      await sut.post(
        faker.internet.httpsUrl(),
        headers: {'any-key': 'any-value'},
      );

      verifyNever(httpRequestSpy.write(any));
    });

    test('Deve retornar dados corretos para status code 200', () async {
      final response = await sut.post(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 200 sem body', () async {
      mockResponse(200);

      final response = await sut.post(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 201', () async {
      mockResponse(201, responseData);

      final response = await sut.post(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 202', () async {
      mockResponse(202);

      final response = await sut.post(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.accepted);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 204', () async {
      mockResponse(204);

      final response = await sut.post(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.noContent);
      expect(response.data, isNull);
    });

    test('Deve retornar DomainException ao ocorrer falha na request', () async {
      mockRequestException();

      final future = sut.post(faker.internet.httpsUrl());

      expectException(
        future,
        const DomainException(
          cause: 'Exception: forced exception',
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400', () async {
      final reason = faker.lorem.word();
      mockResponse(400, responseData, reason);

      final future = sut.post(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(
          status: HttpStatus.badRequest,
          message: reason,
          data: responseObject,
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400 sem body', () async {
      final reason = faker.lorem.word();
      mockResponse(HttpStatus.badRequest.code, null, reason);

      final future = sut.post(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(status: HttpStatus.badRequest, message: reason),
      );
    });

    test('Deve retornar UnauthorizedException para status code 401', () async {
      final reason = faker.lorem.word();
      mockResponse(401, null, reason);

      final future = sut.post(faker.internet.httpsUrl());

      expectException(
        future,
        UnauthorizedException(message: reason),
      );
    });

    test('Deve retornar ServerErrorException para status code 500', () async {
      final reason = faker.lorem.word();
      mockResponse(500, null, reason);

      final future = sut.post(faker.internet.httpsUrl());

      expectException(
        future,
        ServerErrorException(message: reason),
      );
    });
    test('Deve retornar BadRequestException quando a leitura do response falhar', () async {
      var reason = faker.lorem.word();
      mockResponseException(reason);
      final future = sut.post(faker.internet.httpUrl());
      expectException(
        future,
        BadRequestException(message: reason, data: 'Exception: $reason'),
      );
    });
  });

  group('get', () {
    late String responseData;
    late Object? responseObject;

    setUp(() {
      responseData = '{"any-key":"any-value"}';
      responseObject = {'any-key': 'any-value'};

      mockResponse(200, responseData);
    });

    test('Deve fazer a request com os parâmetros corretos', () async {
      final url = faker.internet.httpsUrl();
      await sut.get(
        url,
        headers: {'any-key': 'any-value'},
        query: {'any-key': 'any-value'},
        timeout: timeout,
      );

      verifyNever(
        httpClientSpy.getUrl(Uri.parse('$url?any-key=any-value')),
      ).called(0);
      verify(httpClientSpy.connectionTimeout = timeout).called(1);
      verify(
        httpHeadersSpy.set('content-type', 'application/json; charset=utf-8'),
      ).called(1);
      verify(httpHeadersSpy.set('accept', 'application/json')).called(1);
      verify(httpHeadersSpy.set('any-key', 'any-value')).called(1);
    });

    test('Deve fazer a request e receber um objeto simples', () async {
      responseData = faker.lorem.words(10).join(' ');
      responseObject = responseData;
      mockResponse(201, responseData);

      final response = await sut.get(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 200', () async {
      final response = await sut.get(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, isNotNull);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 201', () async {
      mockResponse(201, responseData);

      final response = await sut.get(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 202', () async {
      mockResponse(202);

      final response = await sut.get(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.accepted);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 204', () async {
      mockResponse(204);

      final response = await sut.get(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.noContent);
      expect(response.data, isNull);
    });

    test('Deve retornar DomainException ao ocorrer falha na request', () async {
      mockRequestException();

      final future = sut.get(faker.internet.httpsUrl());

      expectException(
        future,
        const DomainException(
          cause: 'Exception: forced exception',
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400', () async {
      final reason = faker.lorem.word();
      mockResponse(400, responseData, reason);

      final future = sut.get(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(
          status: HttpStatus.badRequest,
          message: reason,
          data: responseObject,
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400 sem body', () async {
      final reason = faker.lorem.word();
      mockResponse(400, null, reason);

      final future = sut.get(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(status: HttpStatus.badRequest, message: reason),
      );
    });

    test('Deve retornar UnauthorizedException para status code 401', () async {
      final reason = faker.lorem.word();
      mockResponse(HttpStatus.unauthorized.code, null, reason);

      final future = sut.get(faker.internet.httpsUrl());

      expectException(
        future,
        UnauthorizedException(message: reason),
      );
    });

    test('Deve retornar ServerErrorException para status code 500', () async {
      final reason = faker.lorem.word();
      mockResponse(500, null, reason);

      final future = sut.get(faker.internet.httpsUrl());

      expectException(
        future,
        ServerErrorException(message: reason),
      );
    });
    test('Deve retornar BadRequestException quando a leitura do response falhar', () async {
      var reason = faker.lorem.word();
      mockResponseException(reason);
      final future = sut.get(faker.internet.httpUrl());
      expectException(
        future,
        BadRequestException(message: reason, data: 'Exception: $reason'),
      );
    });
  });

  group('patch', () {
    late String responseData;
    late Object? responseObject;

    setUp(() {
      responseData = '{"any-key":"any-value"}';
      responseObject = {'any-key': 'any-value'};

      mockResponse(200, responseData);
    });

    test('Deve fazer a request com os parâmetros corretos', () async {
      await sut.patch(
        faker.internet.httpsUrl(),
        body: {'any-key': 'any-value'},
        headers: {'any-key': 'any-value'},
        timeout: timeout,
      );

      verify(httpClientSpy.connectionTimeout = timeout).called(1);
      verify(httpRequestSpy.write('{"any-key":"any-value"}')).called(1);
      verify(
        httpHeadersSpy.set(
          'content-type',
          'application/json; charset=utf-8',
        ),
      ).called(1);
      verify(httpHeadersSpy.set('accept', 'application/json')).called(1);
      verify(httpHeadersSpy.set('any-key', 'any-value')).called(1);
    });

    test('Deve fazer a request e receber um objeto simples', () async {
      responseData = faker.lorem.words(10).join(' ');
      responseObject = responseData;
      mockResponse(201, responseData);

      final response = await sut.patch(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve fazer a request com os parâmetros corretos sem body', () async {
      await sut.patch(
        faker.internet.httpsUrl(),
        headers: {'any-key': 'any-value'},
      );

      verifyNever(httpRequestSpy.write(any));
    });

    test('Deve retornar dados corretos para status code 200', () async {
      final response = await sut.patch(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 200 sem body', () async {
      mockResponse(200);

      final response = await sut.patch(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 201', () async {
      mockResponse(201, responseData);

      final response = await sut.patch(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 202', () async {
      mockResponse(202);

      final response = await sut.patch(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.accepted);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 204', () async {
      mockResponse(204);

      final response = await sut.patch(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.noContent);
      expect(response.data, isNull);
    });

    test('Deve retornar DomainException ao ocorrer falha na request', () async {
      mockRequestException();

      final future = sut.patch(faker.internet.httpsUrl());

      expectException(
        future,
        const DomainException(
          cause: 'Exception: forced exception',
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400', () async {
      final reason = faker.lorem.word();
      mockResponse(HttpStatus.badRequest.code, responseData, reason);

      final future = sut.patch(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(
          status: HttpStatus.badRequest,
          message: reason,
          data: responseObject,
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400 sem body', () async {
      final reason = faker.lorem.word();
      mockResponse(400, null, reason);

      final future = sut.patch(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(status: HttpStatus.badRequest, message: reason),
      );
    });

    test('Deve retornar UnauthorizedException para status code 401', () async {
      final reason = faker.lorem.word();
      mockResponse(HttpStatus.unauthorized.code, null, reason);

      final future = sut.patch(faker.internet.httpsUrl());

      expectException(
        future,
        UnauthorizedException(message: reason),
      );
    });

    test('Deve retornar ServerErrorException para status code 500', () async {
      final reason = faker.lorem.word();
      mockResponse(500, null, reason);

      final future = sut.patch(faker.internet.httpsUrl());

      expectException(
        future,
        ServerErrorException(message: reason),
      );
    });
    test('Deve retornar BadRequestException quando a leitura do response falhar', () async {
      var reason = faker.lorem.word();
      mockResponseException(reason);
      final future = sut.patch(faker.internet.httpUrl());
      expectException(
        future,
        BadRequestException(message: reason, data: 'Exception: $reason'),
      );
    });
  });

  group('put', () {
    late String responseData;
    late Object? responseObject;

    setUp(() {
      responseData = '{"any-key":"any-value"}';
      responseObject = {'any-key': 'any-value'};

      mockResponse(200, responseData);
    });

    test('Deve fazer a request com os parâmetros corretos', () async {
      await sut.put(
        faker.internet.httpsUrl(),
        body: {'any-key': 'any-value'},
        headers: {'any-key': 'any-value'},
        timeout: timeout,
      );

      verify(httpClientSpy.connectionTimeout = timeout).called(1);
      verify(httpRequestSpy.write('{"any-key":"any-value"}')).called(1);
      verify(
        httpHeadersSpy.set(
          'content-type',
          'application/json; charset=utf-8',
        ),
      ).called(1);
      verify(httpHeadersSpy.set('accept', 'application/json')).called(1);
      verify(httpHeadersSpy.set('any-key', 'any-value')).called(1);
    });

    test('Deve fazer a request e receber um objeto simples', () async {
      responseData = faker.lorem.words(10).join(' ');
      responseObject = responseData;
      mockResponse(201, responseData);

      final response = await sut.put(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve fazer a request com os parâmetros corretos sem body', () async {
      await sut.put(
        faker.internet.httpsUrl(),
        headers: {'any-key': 'any-value'},
      );

      verifyNever(httpRequestSpy.write(any));
    });

    test('Deve retornar dados corretos para status code 200', () async {
      final response = await sut.put(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 200 sem body', () async {
      mockResponse(200);

      final response = await sut.put(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 201', () async {
      mockResponse(201, responseData);

      final response = await sut.put(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.created);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 202', () async {
      mockResponse(202);

      final response = await sut.put(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.accepted);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 204', () async {
      mockResponse(204);

      final response = await sut.put(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.noContent);
      expect(response.data, isNull);
    });

    test('Deve retornar DomainException ao ocorrer falha na request', () async {
      mockRequestException();

      final future = sut.put(faker.internet.httpsUrl());

      expectException(
        future,
        const DomainException(
          cause: 'Exception: forced exception',
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400', () async {
      final reason = faker.lorem.word();
      mockResponse(400, responseData, reason);

      final future = sut.put(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(
          status: HttpStatus.badRequest,
          message: reason,
          data: responseObject,
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400 sem body', () async {
      final reason = faker.lorem.word();
      mockResponse(HttpStatus.badRequest.code, null, reason);

      final future = sut.put(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(status: HttpStatus.badRequest, message: reason),
      );
    });

    test('Deve retornar UnauthorizedException para status code 401', () async {
      final reason = faker.lorem.word();
      mockResponse(401, null, reason);

      final future = sut.put(faker.internet.httpsUrl());

      expectException(
        future,
        UnauthorizedException(message: reason),
      );
    });

    test('Deve retornar ServerErrorException para status code 500', () async {
      final reason = faker.lorem.word();
      mockResponse(500, null, reason);

      final future = sut.put(faker.internet.httpsUrl());

      expectException(
        future,
        ServerErrorException(message: reason),
      );
    });
    test('Deve retornar BadRequestException quando a leitura do response falhar', () async {
      var reason = faker.lorem.word();
      mockResponseException(reason);
      final future = sut.put(faker.internet.httpUrl());
      expectException(
        future,
        BadRequestException(message: reason, data: 'Exception: $reason'),
      );
    });
  });

  group('delete', () {
    late String responseData;
    late Object? responseObject;

    setUp(() {
      responseData = '{"any-key":"any-value"}';
      responseObject = {'any-key': 'any-value'};

      mockResponse(200, responseData);
    });

    test('Deve fazer a request com os parâmetros corretos', () async {
      await sut.delete(
        faker.internet.httpsUrl(),
        body: {'any-key': 'any-value'},
        headers: {'any-key': 'any-value'},
        timeout: timeout,
      );

      verify(httpClientSpy.connectionTimeout = timeout).called(1);
      verify(httpRequestSpy.write('{"any-key":"any-value"}')).called(1);
      verify(
        httpHeadersSpy.set(
          'content-type',
          'application/json; charset=utf-8',
        ),
      ).called(1);
      verify(httpHeadersSpy.set('accept', 'application/json')).called(1);
      verify(httpHeadersSpy.set('any-key', 'any-value')).called(1);
    });

    test('Deve fazer a request e receber um objeto simples', () async {
      responseData = faker.lorem.words(10).join(' ');
      responseObject = responseData;
      mockResponse(200, responseData);

      final response = await sut.delete(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, responseObject);
    });

    test('Deve fazer a request com os parâmetros corretos sem body', () async {
      await sut.delete(
        faker.internet.httpsUrl(),
        headers: {'any-key': 'any-value'},
      );

      verifyNever(httpRequestSpy.write(any));
    });

    test('Deve retornar dados corretos para status code 200', () async {
      final response = await sut.delete(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, responseObject);
    });

    test('Deve retornar dados corretos para status code 200 sem body', () async {
      mockResponse(200);

      final response = await sut.delete(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.ok);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 202', () async {
      mockResponse(202);

      final response = await sut.delete(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.accepted);
      expect(response.data, isNull);
    });

    test('Deve retornar dados corretos para status code 204', () async {
      mockResponse(204);

      final response = await sut.delete(faker.internet.httpsUrl());

      expect(response.status, HttpStatus.noContent);
      expect(response.data, isNull);
    });

    test('Deve retornar DomainException ao ocorrer falha na request', () async {
      mockRequestException();

      final future = sut.delete(faker.internet.httpsUrl());

      expectException(
        future,
        const DomainException(
          cause: 'Exception: forced exception',
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400', () async {
      final reason = faker.lorem.word();
      mockResponse(400, responseData, reason);

      final future = sut.delete(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(
          status: HttpStatus.badRequest,
          message: reason,
          data: responseObject,
        ),
      );
    });

    test('Deve retornar BadRequestException para status code 400 sem body', () async {
      final reason = faker.lorem.word();
      mockResponse(400, null, reason);

      final future = sut.delete(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(status: HttpStatus.badRequest, message: reason),
      );
    });

    test('Deve retornar UnauthorizedException para status code 401', () async {
      final reason = faker.lorem.word();
      mockResponse(401, null, reason);

      final future = sut.delete(faker.internet.httpsUrl());

      expectException(
        future,
        UnauthorizedException(message: reason),
      );
    });

    test('Deve retornar ServerErrorException para status code 500', () async {
      final reason = faker.lorem.word();
      mockResponse(500, null, reason);

      final future = sut.delete(faker.internet.httpsUrl());

      expectException(
        future,
        ServerErrorException(message: reason),
      );
    });
    test('Deve retornar BadRequestException quando a leitura do response falhar', () async {
      var reason = faker.lorem.word();
      mockResponseException(reason);
      final future = sut.delete(faker.internet.httpUrl());
      expectException(
        future,
        BadRequestException(message: reason, data: 'Exception: $reason'),
      );
    });
  });

  group('interceptor', () {
    late String newErrorMessage;
    late String originalMessage;
    late local.MockHttpInterceptor interceptorSpy;

    void mockInterceptor(
      local.MockHttpInterceptor interceptor, {
      dynamic onError,
      HttpOptions? onRequest,
      HttpResponse? onResponse,
      Future<HttpResponse> Function()? onResponseAsync,
    }) {
      when(interceptor.onError(any)).thenAnswer((e) {});

      if (onError != null) {
        when(interceptor.onError(any)).thenThrow(onError);
      }
      when(interceptor.onRequest(any, any)).thenAnswer(
        (answer) => onRequest ?? answer.positionalArguments.first,
      );
      when(interceptor.onResponse(any)).thenAnswer(
        (answer) => onResponse ?? answer.positionalArguments.first,
      );

      if (onResponseAsync != null) {
        when(interceptor.onResponse(any)).thenAnswer((answer) async => await onResponseAsync());
      }
    }

    late String responseData;
    late Object? responseObject;

    setUp(() {
      responseData = '{"any-key":"any-value"}';
      responseObject = {
        'data': {'any-key': 'any-value'},
      };

      mockResponse(200, responseData);

      newErrorMessage = faker.lorem.sentence();
      originalMessage = faker.lorem.sentence();

      interceptorSpy = local.MockHttpInterceptor();
      sut.addInterceptors([interceptorSpy]);

      mockInterceptor(interceptorSpy);
    });

    test('Deve relançar exception original caso interceptor não lance', () async {
      mockResponseException(originalMessage);

      final future = sut.post(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(
          message: originalMessage,
          data: 'Exception: $originalMessage',
        ),
      );
    });

    test('Deve capturar e alterar um HttpException', () async {
      mockResponseException(originalMessage);

      mockInterceptor(
        interceptorSpy,
        onError: BadRequestException(message: newErrorMessage),
      );

      final future = sut.post(faker.internet.httpsUrl());

      expectException(future, BadRequestException(message: newErrorMessage));
    });

    test('Deve capturar e alterar um HttpException no get', () async {
      mockResponseException(originalMessage);

      mockInterceptor(
        interceptorSpy,
        onError: BadRequestException(message: newErrorMessage),
      );

      final future = sut.get(faker.internet.httpsUrl());

      expectException(future, BadRequestException(message: newErrorMessage));
    });

    test('Deve capturar e alterar um HttpException somente no segundo interceptor', () async {
      mockResponseException(originalMessage);

      final secondInterceptorSpy = local.MockHttpInterceptor();

      sut.addInterceptors([secondInterceptorSpy]);
      mockInterceptor(
        secondInterceptorSpy,
        onError: BadRequestException(message: newErrorMessage),
      );

      final future = sut.get(faker.internet.httpsUrl());

      expectException(future, BadRequestException(message: newErrorMessage));
    });

    test('Deve capturar e alterar o timeout da request', () async {
      final url = faker.internet.httpsUrl();
      mockInterceptor(
        interceptorSpy,
        onRequest: HttpOptions(
          path: '',
          url: url,
          method: HttpMethod.put,
          timeout: const Duration(hours: 1),
          apiVersion: 'v1',
        ),
      );

      await sut.put(url);

      verify(httpClientSpy.connectionTimeout = const Duration(hours: 1)).called(1);
    });

    test('Deve capturar e alterar o response', () async {
      final url = faker.internet.httpsUrl();
      mockInterceptor(
        interceptorSpy,
        onResponse: HttpResponse.success(responseObject),
      );

      final response = await sut.put(url);

      expect(
        response,
        HttpResponse(status: HttpStatus.ok, data: responseObject),
      );
    });

    test('Deve capturar e alterar o response com método assíncrono', () async {
      final url = faker.internet.httpsUrl();
      mockInterceptor(
        interceptorSpy,
        onResponseAsync: () => Future.value(HttpResponse.success(responseObject)),
      );

      final response = await sut.put(url);

      expect(
        response,
        HttpResponse(status: HttpStatus.ok, data: responseObject),
      );
    });
  });

  group('interceptor', () {
    late String newErrorMessage;
    late String originalMessage;
    late local.MockHttpInterceptor interceptorSpy;

    void mockInterceptor(
      local.MockHttpInterceptor interceptor, {
      dynamic onError,
      HttpOptions? onRequest,
      HttpResponse? onResponse,
      Future<HttpResponse> Function()? onResponseAsync,
    }) {
      when(interceptor.onError(any)).thenAnswer((e) {});

      if (onError != null) {
        when(interceptor.onError(any)).thenThrow(onError);
      }
      when(interceptor.onRequest(any, any)).thenAnswer(
        (answer) => onRequest ?? answer.positionalArguments.first,
      );
      when(interceptor.onResponse(any)).thenAnswer(
        (answer) => onResponse ?? answer.positionalArguments.first,
      );

      if (onResponseAsync != null) {
        when(interceptor.onResponse(any)).thenAnswer((answer) async => await onResponseAsync());
      }
    }

    late String responseData;
    late Object? responseObject;

    setUp(() {
      responseData = '{"any-key":"any-value"}';
      responseObject = {
        'data': {'any-key': 'any-value'},
      };

      mockResponse(200, responseData);

      newErrorMessage = faker.lorem.sentence();
      originalMessage = faker.lorem.sentence();

      interceptorSpy = local.MockHttpInterceptor();
      sut.addInterceptors([interceptorSpy]);

      mockInterceptor(interceptorSpy);
    });

    test('Deve relançar exception original caso interceptor não lance', () async {
      mockResponseException(originalMessage);

      final future = sut.post(faker.internet.httpsUrl());

      expectException(
        future,
        BadRequestException(
          message: originalMessage,
          data: 'Exception: $originalMessage',
        ),
      );
    });

    test('Deve capturar e alterar um HttpException', () async {
      mockResponseException(originalMessage);

      mockInterceptor(
        interceptorSpy,
        onError: BadRequestException(message: newErrorMessage),
      );

      final future = sut.post(faker.internet.httpsUrl());

      expectException(future, BadRequestException(message: newErrorMessage));
    });

    test('Deve capturar e alterar um HttpException no get', () async {
      mockResponseException(originalMessage);

      mockInterceptor(
        interceptorSpy,
        onError: BadRequestException(message: newErrorMessage),
      );

      final future = sut.get(faker.internet.httpsUrl());

      expectException(future, BadRequestException(message: newErrorMessage));
    });

    test('Deve capturar e alterar um HttpException somente no segundo interceptor', () async {
      mockResponseException(originalMessage);

      final secondInterceptorSpy = local.MockHttpInterceptor();

      sut.addInterceptors([secondInterceptorSpy]);
      mockInterceptor(
        secondInterceptorSpy,
        onError: BadRequestException(message: newErrorMessage),
      );

      final future = sut.get(faker.internet.httpsUrl());

      expectException(future, BadRequestException(message: newErrorMessage));
    });

    test('Deve capturar e alterar o timeout da request', () async {
      final url = faker.internet.httpsUrl();
      mockInterceptor(
        interceptorSpy,
        onRequest: HttpOptions(
          path: '',
          url: url,
          method: HttpMethod.put,
          timeout: const Duration(hours: 1),
          apiVersion: 'v1',
        ),
      );

      await sut.put(url);

      verify(httpClientSpy.connectionTimeout = const Duration(hours: 1)).called(1);
    });

    test('Deve capturar e alterar o response', () async {
      final url = faker.internet.httpsUrl();
      mockInterceptor(
        interceptorSpy,
        onResponse: HttpResponse.success(responseObject),
      );

      final response = await sut.put(url);

      expect(
        response,
        HttpResponse(status: HttpStatus.ok, data: responseObject),
      );
    });

    test('Deve capturar e alterar o response com método assíncrono', () async {
      final url = faker.internet.httpsUrl();
      mockInterceptor(
        interceptorSpy,
        onResponseAsync: () => Future.value(HttpResponse.success(responseObject)),
      );

      final response = await sut.put(url);

      expect(
        response,
        HttpResponse(status: HttpStatus.ok, data: responseObject),
      );
    });
  });

  group('timeout', () {
    late String errorMessage;

    void mockRequestTimeoutError() {
      when(httpRequestSpy.close()).thenThrow(io.SocketException(errorMessage));
    }

    setUp(() {
      errorMessage = faker.lorem.sentence();
      mockRequestTimeoutError();
    });

    test('Deve lançar TimeoutException em caso de timeout no get', () async {
      final future = sut.get(
        faker.internet.httpsUrl(),
        timeout: const Duration(milliseconds: 100),
      );

      expectException(future, TimeoutException(message: errorMessage));
    });

    test('Deve lançar TimeoutException em caso de timeout no post', () async {
      final future = sut.post(
        faker.internet.httpsUrl(),
        timeout: const Duration(milliseconds: 100),
      );

      expectException(future, TimeoutException(message: errorMessage));
    });

    test('Deve lançar TimeoutException em caso de timeout no put', () async {
      final future = sut.put(
        faker.internet.httpsUrl(),
        timeout: const Duration(milliseconds: 100),
      );

      expectException(future, TimeoutException(message: errorMessage));
    });

    test('Deve lançar TimeoutException em caso de timeout no patch', () async {
      final future = sut.patch(
        faker.internet.httpsUrl(),
        timeout: const Duration(milliseconds: 100),
      );

      expectException(future, TimeoutException(message: errorMessage));
    });

    test('Deve lançar TimeoutException em caso de timeout no delete', () async {
      final future = sut.delete(
        faker.internet.httpsUrl(),
        timeout: const Duration(milliseconds: 100),
      );

      expectException(future, TimeoutException(message: errorMessage));
    });
  });
}
