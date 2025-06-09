import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

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
    final String name = _nameController.text.trim();
    final int? age = int.tryParse(_ageController.text.trim());
    final String introduction = _introductionController.text.trim();
    if (name.isNotEmpty && age != null) {
      _firestoreService.addUser(name, age, introduction);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF9D6BFF);
    const Color backgroundColor = Color(0xFFF6F8FA);
    const double borderRadius = 16.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '간단한 자기소개',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionTitle("자기소개에 쓰면 좋은 주제예요"),
            const SizedBox(height: 12),
            _buildHintIcons(),
            const SizedBox(height: 24),
            _buildInputCard(primaryColor, borderRadius),
            const SizedBox(height: 24),
            _buildUserInfoCard(borderRadius),
            const SizedBox(height: 80), // 버튼 공간 확보
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            onPressed: _addUser,
            child: const Text(
              '수정하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildHintIcons() {
    final hints = [
      {'icon': Icons.help_outline, 'label': '성격/가치관'},
      {'icon': Icons.palette_outlined, 'label': '취미/관심사'},
      {'icon': Icons.emoji_emotions_outlined, 'label': '외적 특징'},
      {'icon': Icons.headphones, 'label': '인생 영화/음악'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          hints.map((hint) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFF0F2F5),
                  child: Icon(
                    hint['icon'] as IconData,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hint['label'] as String,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildInputCard(Color primaryColor, double borderRadius) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          _buildTextField(_nameController, '이름'),
          const SizedBox(height: 12),
          _buildTextField(
            _ageController,
            '나이',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _introductionController,
            '자기소개',
            minLines: 5,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(double borderRadius) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestoreService.getUserDocSnapshotStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('데이터 불러오기 오류');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final name = data['name'] ?? 'Unknown';
        final age = data['age']?.toString() ?? 'N/A';
        final intro = data['introduction'] ?? 'No introduction';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FB),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이름: $name', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('나이: $age', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Text('자기소개', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(intro, style: const TextStyle(fontSize: 14, height: 1.4)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int? minLines,
    int? maxLines,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
      ),
    );
  }
}
