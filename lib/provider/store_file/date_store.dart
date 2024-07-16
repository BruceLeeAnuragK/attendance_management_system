import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

class DateStore with Store {
  Observable<String> formattedDate = Observable('');

  void getSystemTime() {
    runInAction(
      () {
        var now = DateTime.now();
        var formatter = DateFormat.yMMMMd('en_US');
        var formattedDate = formatter.format(now);
        var parts = formattedDate.split(' ');
        var month = parts[1];
        this.formattedDate.value =
            '${parts[0]} $month ${parts.sublist(2).join(' ')}';
      },
    );
  }
}
