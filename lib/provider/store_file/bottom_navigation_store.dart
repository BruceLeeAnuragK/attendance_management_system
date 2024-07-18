import 'package:mobx/mobx.dart';

class BottomNavigationStore with Store {
  Observable<int> currentIndex = Observable(1);
  Observable<int> currentTabIndex = Observable(1);
  Observable<double> animationValue =
      Observable(0.0); // New observable for animation

  @action
  void updateAnimationValue(double value) {
    animationValue.value = value;
  }

  @action
  void resetAnimationValue() {
    animationValue.value = 0.0;
  }

  @computed
  double get animation => animationValue.value;

  changeIndex({required int index}) {
    runInAction(() => currentIndex.value = index);
  }

  chnageTabIndex({required int index}) {
    runInAction(() => currentTabIndex.value = index);
  }
}
