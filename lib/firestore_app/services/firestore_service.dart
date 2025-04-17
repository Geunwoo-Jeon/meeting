import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  // Add a new user
  Future<void> addUser(String name, int age) async {
    await users.add({
      'name': name,
      'age': age,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all users
  Stream<QuerySnapshot> getUsers() {
    return users.orderBy('createdAt', descending: true).snapshots();
  }
}
