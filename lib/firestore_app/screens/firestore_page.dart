import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({super.key});

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();

  void _addUser() {
    final String name = _nameController.text;
    final int? age = int.tryParse(_ageController.text);
    final String introduction = _introductionController.text;
    if (name.isNotEmpty && age != null) {
      _firestoreService.addUser(name, age, introduction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Example')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _introductionController,
                    decoration: const InputDecoration(
                      labelText: 'Introduction',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 3,
                  ),
                  ElevatedButton(
                    onPressed: _addUser,
                    child: const Text('Add User'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          StreamBuilder<DocumentSnapshot>(
            stream: _firestoreService.getUserDocSnapshotStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error loading data');
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const CircularProgressIndicator();
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown';
              final age = data['age']?.toString() ?? 'N/A';
              final introduction = data['introduction'] ?? 'No introduction';

              return ListTile(
                title: Text('Name: $name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Age: $age'),
                    const SizedBox(height: 4),
                    Text('Intro: $introduction'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(title: 'Login Page'),
            ),
          );
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
