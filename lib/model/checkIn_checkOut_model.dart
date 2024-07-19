class CheckinCheckoutModel {
  final String checkIn;
  final String checkout;

  CheckinCheckoutModel({
    required this.checkIn,
    required this.checkout,
  });

  Map<String, dynamic> toMap() {
    return {
      'checkIn': checkIn,
      'checkout': checkout,
    };
  }

  factory CheckinCheckoutModel.fromMap(Map<String, dynamic> map) {
    return CheckinCheckoutModel(
      checkIn: map['checkIn'],
      checkout: map['checkout'],
    );
  }
}
