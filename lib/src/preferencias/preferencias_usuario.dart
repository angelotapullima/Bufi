import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  //instancia singleton para crear una sola instancia en toda la aplicación de
  //Sharedpreferences
  static final Preferences _instancia = new Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  SharedPreferences _prefs;

  Preferences._internal();

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  clearPreferences() async {
    await _prefs.clear();
  }

  get idUser {
    return _prefs.getString('c_u');
  }

  set idUser(String value) {
    _prefs.setString('c_u', value);
  }

  get idCity {
    return _prefs.getString('c_c');
  }

  set idCity(String value) {
    _prefs.setString('c_c', value);
  }

  get idPerson {
    _prefs.getString('c_p');
  }

  set idPerson(String value) {
    _prefs.setString('c_p', value);
  }

  get userNickname {
    return _prefs.getString('_n');
  }

  set userNickname(String value) {
    _prefs.setString('_n', value);
  }

  get userEmail {
    return _prefs.getString('u_e');
  }

  set userEmail(String value) {
    _prefs.setString('u_e', value);
  }

  get userImage {
    return _prefs.getString('u_i');
  }

  set userImage(String value) {
    _prefs.setString('u_i', value);
  }

  get personName {
    return _prefs.getString('p_n');
  }

  set personName(String value) {
    _prefs.setString('p_n', value);
  }

  get personSurname {
    return _prefs.getString('p_s');
  }

  set personSurname(String value) {
    _prefs.setString('p_s', value);
  }

  get idRoleUser {
    return _prefs.getString('ru');
  }

  set idRoleUser(String value) {
    _prefs.setString('ru', value);
  }

  get roleName {
    return _prefs.getString('rn');
  }

  set roleName(String value) {
    _prefs.setString('rn', value);
  }

  get token {
    return _prefs.getString('token');
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get cargaCategorias {
    return _prefs.getString('cargaCategorias');
  }

  set cargaCategorias(String value) {
    _prefs.setString('cargaCategorias', value);
  }

  get saludo {
    return _prefs.getString('saludo');
  }

  set saludo(String value) {
    _prefs.setString('saludo', value);
  }

  get tokenFirebase {
    return _prefs.getString('tokenFirebase');
  }

  set tokenFirebase(String value) {
    _prefs.setString('tokenFirebase', value);
  }
}
