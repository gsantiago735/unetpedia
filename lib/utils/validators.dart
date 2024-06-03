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

  static String? emptyValidation(String? value, {int maxCharacters = 1000}) {
    if (value == null || value.replaceAll('\n', '').isEmpty) {
      return 'Los campos están vacíos.';
    }
    if (value.length > maxCharacters) {
      return "Debe contener menos de $maxCharacters caracteres.";
    }

    return null;
  }

  static String? passwordValidation(
      String? value, String password, String cPassword) {
    if (value == null || value.isEmpty) {
      return 'Los campos están vacíos.';
    } else if (value.length < 6) {
      return "La contraseña debe contener al menos 6 caracteres.";
    } else if (password != cPassword) {
      return "Las contraseñas deben coincidir.";
    }
    return null;
  }
}
