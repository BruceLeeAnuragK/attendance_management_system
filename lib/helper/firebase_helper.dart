import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collection = "User";
  String colUsername = "username";
  String colEmail = "email";
  String schCollection = "lists";

  addUser({required UserModel userModel}) {
    Map<String, dynamic> datas = {
      colUsername: userModel.username,
      colEmail: userModel.email,
    };
    firestore
        .collection(collection)
        .doc(userModel.username.toString())
        .set(datas);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection(collection).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSchoolList() {
    return firestore.collection(schCollection).doc('schools').snapshots();
  }
}
