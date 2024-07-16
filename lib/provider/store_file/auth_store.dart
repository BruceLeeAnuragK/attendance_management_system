import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

class AuthStore with Store {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Observable<bool> hide = Observable(true);

  hideOrShowPassword() {
    runInAction(() => hide.value = !hide.value);
  }
}
