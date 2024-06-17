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
    final regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value == null || value.isEmpty) {
      return 'Los campos están vacíos.';
    } else if ((!regex.hasMatch(value))) {
      if (!value.contains(RegExp(r'[A-Z]'))) {
        return 'La contraseña debe contener al menos una letra mayúscula.';
      } else if (!value.contains(RegExp(r'[a-z]'))) {
        return 'La contraseña debe contener al menos una letra minúscula.';
      } else if (!value.contains(RegExp(r'[0-9]'))) {
        return 'La contraseña debe contener al menos un número.';
      } else if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
        return 'La contraseña debe contener al menos un caracter especial.';
      } else {
        return 'La contraseña debe contener al menos 8 caracteres.';
      }
    } else {
      return null;
    }
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

  static String? registerPasswordValidation(
      String? value, String password, String cPassword) {
    final text = loginPasswordValidation(value);
    if (text != null) {
      return text;
    } else if (password != cPassword) {
      return "Las contraseñas deben coincidir.";
    }
    return null;
  }
}
