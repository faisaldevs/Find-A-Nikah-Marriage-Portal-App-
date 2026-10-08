/// Client-side rules for credentials. UX only — the server validates again
/// (a modified client can skip these).
abstract final class CredentialsPolicy {
  static const minPasswordLength = 8;
  static const codeLength = 6;

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _digit = RegExp('[0-9]');
  static final _letter = RegExp('[a-zA-Z]');
  static final _code = RegExp(r'^\d{6}$');

  static bool isValidEmail(String email) => _email.hasMatch(email.trim());

  static bool hasMinLength(String password) =>
      password.length >= minPasswordLength;

  static bool hasDigit(String password) => _digit.hasMatch(password);

  static bool hasLetter(String password) => _letter.hasMatch(password);

  static bool isValidPassword(String password) =>
      hasMinLength(password) && hasDigit(password) && hasLetter(password);

  static bool isValidCode(String code) => _code.hasMatch(code);
}
