import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:louie_shop/models/HttpExeption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expierdDate;
  String _userId;
  Timer _authTimer;

  String get token {
    if (_expierdDate != null &&
        _expierdDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    print(token != null);
    if (token != null) {}
    return token != null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authintcate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/${urlSegment}key=AIzaSyAYX9vGYMi6QEevy_IL4Fhh2_vX1fc4-dI';

    var res = await http.post(Uri.parse(url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    final resData = json.decode(res.body);
    // print(resData);
    if (resData['error'] != null) {
      throw HttpExption(msg: resData['error']['message']);
    }
    _userId = resData['localId'];
    _token = resData['idToken'];
    _expierdDate =
        DateTime.now().add(Duration(seconds: int.parse(resData['expiresIn'])));
    autoLogOut();
    notifyListeners();
    final pref =await SharedPreferences.getInstance();
    final userData = json.encode({
      'token' :_token ,
      'userId':_userId,
      'expDate':_expierdDate.toIso8601String()
    });
    pref.setString('userDataPref', userData);
  }

  Future<void> singUp(String email, String password) async {
    return _authintcate(email, password, 'accounts:signUp?');
  }

  Future<void> logIn(String email, String password) async {
    return _authintcate(email, password, 'accounts:signInWithPassword?');
  }

  Future<void> logOut() async{
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    _userId = null;
    _token = null;
    _expierdDate = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final expDate = _expierdDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expDate),logOut);

  }

  Future<bool> tryautoLogin()async{
    final pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('userDataPref')){
      return false ;
    }
    final extData = json.decode(pref.getString('userDataPref')) as Map<String,Object>;
    final ex = DateTime.parse(extData['expDate']);
    if(ex.isBefore(DateTime.now())){
      return false ;
    }
    _token = extData['token'];
    _userId= extData['userId'];
    _expierdDate = ex ;
    notifyListeners();
    autoLogOut();
    return true ;





  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userDataPref')) {
  //     return false;
  //   }
  //   final extractedUserData = json.decode(prefs.getString('userDataPref')) as Map<String, Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expDate']);
  //
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expierdDate = expiryDate;
  //   notifyListeners();
  //   autoLogOut();
  //   print('lololo');
  //   return true;
  // }
  //
  //












}
