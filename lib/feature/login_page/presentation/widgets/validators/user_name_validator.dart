/// Return error message if message [_regexp] doesnt matches with
String? userNameValid(String? input) {
  RegExp _regexp =
      RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
  String _errorMsg = 'Username should be between 8 and 20 symbols';

  if (input == null || !_regexp.hasMatch(input)) {
    return _errorMsg;
  }
}
