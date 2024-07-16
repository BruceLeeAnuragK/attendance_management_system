import 'package:mobx/mobx.dart';

class BottomNavigationStore with Store {
  Observable<int> currentIndex = Observable(1);
  Observable<int> currentTabIndex = Observable(1);

  changeIndex({required int index}) {
    runInAction(() => currentIndex.value = index);
  }

  chnageTabIndex({required int index}) {
    runInAction(() => currentTabIndex.value = index);
  }
}
