//regular expressions used in this app
class AppReg {
  AppReg._PrivateConstructor();

  static RegExp numbers = RegExp(r'[0-9]+$');
  static RegExp phoneNumber = RegExp(r'^[+]9665[0-9]{8}$');
}
