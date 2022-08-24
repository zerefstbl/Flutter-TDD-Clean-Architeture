import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tddcleanac/data/http/http.dart';
import 'package:tddcleanac/data/usecases/usecases.dart';

import 'package:tddcleanac/domain/helpers/helpers.dart';
import 'package:tddcleanac/domain/usecases/authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication? sut;
  HttpClientSpy? httpClient;
  String? url;
  AuthenticationParams? params;

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation? mockRequest() => when(httpClient!.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest()!.thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest()!.thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut =
        RemoteAuthentication(httpClient: httpClient, url: url, method: 'post');
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });
  test('Should call HttpClient with correct URL', () async {
    await sut!.auth(params!);

    verify(httpClient!.request(
      url: url,
      method: 'post',
      body: {
        'email': params!.email,
        'password': params!.secret,
      },
    ));
  });

  test('Should throw Unexpectederror if HttpClient returns 400 ', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexceptedError if HttpCLient return 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexceptedError if HttpCLient return 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialError if HttpClient return 401',
      () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut!.auth(params!);

    expect(account.token, validData['accessToken']);
  });

  test(
    'Should throw Unexpectederror if HttpClient return 200 with invalid data',
    () async {
      mockHttpData({'invalid_key': 'invalid_value'});

      final future = sut!.auth(params!);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
