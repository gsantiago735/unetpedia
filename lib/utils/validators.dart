class Validators {
  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty || value.replaceAll('\n', '').isEmpty) {
      return 'Los campos están vacíos.';
    } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  static String? loginPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Los campos están vacíos.';
    } else if (value.length < 6) {
      return "La contraseña debe contener al menos 6 caracteres.";
    }
    return null;
  }
}
