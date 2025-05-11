import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new user
  Future<void> addUser(String name, int age, String introduction) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'age': age,
      'introduction': introduction,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all users
  Stream<DocumentSnapshot> getUserDocSnapshotStream() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
