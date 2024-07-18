import 'dart:convert'; // for the utf8.encode method

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import 'auth_helper.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collection = "users";
  String colUsername = "username";
  String colEmail = "email";
  String colPassword = "password";
  String colRole = "role";

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashed = sha256.convert(bytes);
    return hashed.toString();
  }

  Future<void> signUp(
      {required UserModel userModel, required String role}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      if (userCredential.user != null) {
        String hashedPassword = hashPassword(userModel.password);

        Map<String, dynamic> data = {
          colUsername: userModel.username,
          colEmail: userModel.email,
          colPassword: hashedPassword,
          colRole: role,
        };

        await firestore
            .collection(collection)
            .doc(userCredential.user!.uid)
            .set(data);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("Error signing up: The email address is already in use.");
      } else {
        print("Error signing up: $e");
      }
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  Future<void> logIn({required UserModel userModel}) async {
    User? user = await AuthHelper.authHelper.logIn(
      email: userModel.email,
      password: userModel.password,
    );
    if (user != null) {
      return;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection(collection).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserRole(String userId) {
    return firestore.collection(collection).doc(userId).get();
  }
}
