import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizu/exports/models.dart' show User;

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //collections
  //users' collection
  static const String _users_collection = 'users';

  //check of existance of a document for a user
  Future<bool> checkUserExistance(String uid) async {
    try {
      bool isExists = await _firestore
          .collection(_users_collection)
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          return true;
        } else {
          return false;
        }
      });
      return isExists;
    } catch (e) {
      throw e;
    }
  }

  Future<void> createUser(Map<String, dynamic> data, String uid) async {
    try {
      await _firestore.collection(_users_collection).doc(uid).set(data);
    } catch (e) {
      throw e;
    }
  }

  //to check the existance of a document by user id and return a Customer or Mandoob object
  Future<User?> getUser(String uid) async {
    try {
      User? user;
      await _firestore.collection(_users_collection).doc(uid).get().then((doc) {
        if (doc.data() != null) {
          user = User.fromJson(doc.data()!);
        } else {
          user = null;
        }
      });

      return user;
    } catch (e) {
      throw e;
    }
  }
}
