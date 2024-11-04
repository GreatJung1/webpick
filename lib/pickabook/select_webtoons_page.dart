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
  final TextEditingController _searchController = TextEditingController(); // 검색 텍스트 컨트롤러
  String _searchText = ""; // 검색 텍스트 상태

  void _saveSelectedWebtoons() async {
    if (_selectedWebtoons.isNotEmpty) {
      try {
        DocumentReference pickaBookRef = FirebaseFirestore.instance.collection('pickabookDB').doc(widget.pickaBookId);

        /*DocumentReference pickaBookRef = FirebaseFirestore.instance.collection('pickabooks').doc(widget.pickaBookId);*/
        final docSnapshot = await pickaBookRef.get();
        List<String> existingWebtoons = [];
        if (docSnapshot.exists) {
          existingWebtoons = List<String>.from(docSnapshot['webtoons'] ?? []);
        } else {
          await pickaBookRef.set({
            'webtoons': [],
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        List<String> newWebtoons = _selectedWebtoons.where((id) => !existingWebtoons.contains(id)).toList();

        await pickaBookRef.update({
          'webtoons': FieldValue.arrayUnion(newWebtoons),
        });

        for (String webtoonId in newWebtoons) {
          await _webtoonCollection.doc(webtoonId).update({
            'pickednum': FieldValue.increment(1),
          });
        }

        Navigator.pop(context);
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
      body: Column(
        children: [
          // 검색창 추가
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '웹툰 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase(); // 검색 텍스트를 소문자로 설정
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _webtoonCollection.snapshots(), // 실시간 데이터 스트림
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('데이터를 불러오는데 오류가 발생했습니다.'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('웹툰 데이터가 없습니다.'));
                }

                // 웹툰 목록 필터링
                final webtoons = snapshot.data!.docs.where((doc) {
                  var title = (doc['title'] ?? '').toString().toLowerCase();
                  return title.contains(_searchText);
                }).toList();

                return ListView.builder(
                  itemCount: webtoons.length,
                  itemBuilder: (context, index) {
                    var webtoon = webtoons[index].data() as Map<String, dynamic>;
                    var webtoonId = webtoons[index].id;

                    return CheckboxListTile(
                      title: Text(webtoon['title'] ?? '제목 없음'),
                      subtitle: Text('${webtoon['writer']} - ${webtoon['platform']}'),
                      value: _selectedWebtoons.contains(webtoonId),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedWebtoons.add(webtoonId);
                          } else {
                            _selectedWebtoons.remove(webtoonId);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
