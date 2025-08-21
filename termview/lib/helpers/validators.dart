String? validateName(String? value, String fieldName) {
  if (value == null || value.isEmpty) return '$fieldName is required';
  final regex = RegExp(r'^[A-Za-z]+$');
  if (!regex.hasMatch(value)) return 'Only letters allowed';
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) return 'Username is required';
  final regex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  if (!regex.hasMatch(value)) return 'Letters, numbers, underscore only (3-20 chars)';
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email is required';
  final regex = RegExp(r'^[\w-\.]+@gmail\.com$');
  if (!regex.hasMatch(value)) return 'Only Gmail addresses are allowed';
  return null;
}


String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Password must be at least 6 characters';

  final upperCaseRegex = RegExp(r'[A-Z]');
  final specialCharRegex = RegExp(r'[^a-zA-Z0-9]'); 

  if (!upperCaseRegex.hasMatch(value)) 
    return 'Password must have at least one uppercase letter';
  if (!specialCharRegex.hasMatch(value)) 
    return 'Password must have at least one special character';

  return null;
}

String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }
