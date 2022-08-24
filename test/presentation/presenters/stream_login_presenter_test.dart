import 'dart:async';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tddcleanac/presentation/protocols/protocols.dart';
import 'package:tddcleanac/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  ValidationSpy? validation;
  StreamLoginPresenter? sut;
  String? email;

  PostExpectation mockValidationCall(String field) => when(
        validation!.validate(
            field: field == '' ? anyNamed('field') : field,
            value: anyNamed('value')),
      );

  void mockValidation({String field = '', String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test('Should call validation with correct email', () async {
    sut!.validateEmail(email);

    verify(validation!.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error validation if validation fails', () async {
    mockValidation(value: 'error');

    expectLater(sut!.emailErrorStream, emits('error'));

    sut!.validateEmail(email);
  });
}
