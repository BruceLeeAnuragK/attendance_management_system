import 'package:mobx/mobx.dart';

class PasswordStore with Store {
  Observable<bool> hide = Observable(true);

  hideOrShowPassword() {
    Action(() => hide.value = !hide.value);
  }
}
