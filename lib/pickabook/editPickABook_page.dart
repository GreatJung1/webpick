import 'package:flutter/material.dart';
import 'pickABook_page.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위한 패키지
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // 파이어베이스 추가

class EditPickABookPage extends StatefulWidget {
  final PickABook pickABook;
  final String documentId; // 추가: Firestore 문서 ID

  EditPickABookPage({required this.pickABook, required this.documentId}); // 문서 ID를 전달받도록 수정

  @override
  _EditPickABookPageState createState() => _EditPickABookPageState();
}

class _EditPickABookPageState extends State<EditPickABookPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _coverImage;
  late bool _isPublic;

  @override
  void initState() {
    super.initState();
    _title = widget.pickABook.title;
    _coverImage = widget.pickABook.coverImage;
    _isPublic = widget.pickABook.isPublic;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = pickedFile.path;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Firestore에서 PickaBook 데이터 업데이트
        await FirebaseFirestore.instance
            .collection('pickabookDB')
            .doc(widget.documentId) // 적절한 문서 ID 사용
            .update({
          'title': _title,
          'coverImage': _coverImage,
          'isPublic': _isPublic,
        });

        Navigator.pop(context, {'title': _title, 'coverImage': _coverImage, 'isPublic': _isPublic});
      } catch (e) {
        print('Error updating PickaBook: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('픽카북 수정 중 오류가 발생 했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('픽카북 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _coverImage.startsWith('assets/')
                          ? AssetImage(_coverImage)
                          : FileImage(File(_coverImage)) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.black),//grey 원색
                  ),
                  child: _coverImage.startsWith('assets/')
                      ? null
                      : Icon(Icons.edit, color: Colors.white),
                ),
              ),
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: '제목'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력하세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('공개 설정'),
                  Switch(
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value; // 공개/비공개 상태 변경
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}