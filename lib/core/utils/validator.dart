import 'package:email_validator/email_validator.dart';

String? notEmptyValidator(var value) {
  if (value == null || value.isEmpty) {
    return "Isian tidak boleh kosong";
  } else if (value.length < 3) {
    return "Isian minimal 3 huruf";
  } else {
    return null;
  }
}

String? emailValidator(var value) {
  String? notEmpty = notEmptyValidator(value);

  if (notEmpty != null) {
    return notEmpty;
  }

  if (!EmailValidator.validate(value!)) {
    return "Format email tidak valid";
  }

  return null;
}

String? passConfirmValidator(var value) {
  String? notEmpty = notEmptyValidator(value);

  if (notEmpty != null) {
    return notEmpty;
  }

  if (value.length < 8) {
    return "password minimal 8 karater";
  }

  return null;
}
