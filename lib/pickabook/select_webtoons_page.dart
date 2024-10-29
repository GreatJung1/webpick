import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectWebtoonsPage extends StatefulWidget {
  final String pickaBookId;

  SelectWebtoonsPage({required this.pickaBookId});

  @override
  _SelectWebtoonsPageState createState() => _SelectWebtoonsPageState();
}

class _SelectWebtoonsPageState extends State<SelectWebtoonsPage> {
  final CollectionReference _webtoonCollection = FirebaseFirestore.instance.collection('webtoonDB');
  List<String> _selectedWebtoons = [];

  void _saveSelectedWebtoons() async {
    if (_selectedWebtoons.isNotEmpty) {
      try {
        // 문서가 존재하지 않으면 새로 생성
        await FirebaseFirestore.instance
            .collection('pickabookDB')
            .doc(widget.pickaBookId)
            .set({
          'webtoons': _selectedWebtoons,
        }, SetOptions(merge: true)); // merge 옵션을 사용해 기존 필드와 병합

        Navigator.pop(context); // 저장 후 이전 화면으로 돌아감
      } catch (e) {
        print('Error updating PickaBook: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('웹툰을 저장하는 중 오류가 발생했습니다.')),
        );
      }
    } else {
      print('선택된 웹툰이 없습니다.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('적어도 하나의 웹툰을 선택해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('웹툰 선택'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSelectedWebtoons,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _webtoonCollection.snapshots(), // 실시간 데이터 스트림
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는데 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('웹툰 데이터가 없습니다.'));
          }

          final webtoons = snapshot.data!.docs;

          return ListView.builder(
            itemCount: webtoons.length,
            itemBuilder: (context, index) {
              var webtoon = webtoons[index].data() as Map<String, dynamic>;
              var webtoonId = webtoons[index].id;

              print("Webtoon ID: $webtoonId, Selected: ${_selectedWebtoons.contains(webtoonId)}");

              return CheckboxListTile(
                title: Text(webtoon['title'] ?? '제목 없음'),
                subtitle: Text('${webtoon['writer']} - ${webtoon['platform']}'),
                value: _selectedWebtoons.contains(webtoonId),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedWebtoons.add(webtoonId);
                      print('Added $webtoonId');
                    } else {
                      _selectedWebtoons.remove(webtoonId);
                      print('Removed $webtoonId');
                    }
                    print('Selected Webtoons: $_selectedWebtoons');
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}