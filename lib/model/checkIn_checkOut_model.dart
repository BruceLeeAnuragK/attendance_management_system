import 'package:cloud_firestore/cloud_firestore.dart';

class CheckinCheckoutModel {
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkout;

  CheckinCheckoutModel({
    required this.date,
    required this.checkIn,
    required this.checkout,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'checkIn': checkIn?.toIso8601String(),
      'checkout': checkout?.toIso8601String(),
    };
  }

  factory CheckinCheckoutModel.fromMap(Map<String, dynamic> map) {
    return CheckinCheckoutModel(
      date: (map['date'] as Timestamp).toDate(),
      checkIn: map['checkIn'] != null
          ? (map['checkIn'] as Timestamp).toDate()
          : null,
      checkout: map['checkout'] != null
          ? (map['checkout'] as Timestamp).toDate()
          : null,
    );
  }
}
