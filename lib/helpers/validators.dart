class MyValidators {

  static String validateLocation(String value) {
    if (value.length < 8) {
      return 'Vnesite ulico, hišna št. in kraj';
    } else {
      return null;
    }
  }

  static String validateQuantity(String value) {
    String val = value.replaceAll('.', '');
    val = val.replaceAll(',', '');
    val = val.replaceAll(' ', '');
    val = val.replaceAll('-', '');
    if (val != null && val.length > 0) {
      if (int.parse(val) > 20) {
        return 'Maksimalno: 20';
      }
    } else if (val.length == 0) {
      return 'Vnesite približno količino';
    }
    return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Vnesite email!';
    } else {
      return null;
    }
  }

  static String validatePhone(String value) {
    if (value.isNotEmpty) {
      if (value.length < 9) {
        return 'Vnešena številka je prekratka!';
      } else if (value.length > 9) {
        return 'Vnešena številka je predolga!';
      }
    }
    return null;
  }
}