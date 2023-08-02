// ignore_for_file: non_constant_identifier_names

class PopResultBuilder {
  static Map<String, dynamic> from_Auth_SignUp_to_Auth_Login({
    String? email,
    String? password,
  }) =>
      {
        'email': email,
        'password': password,
      };
}
