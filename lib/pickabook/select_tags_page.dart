import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'select_webtoons_page.dart'; // 웹툰 선택 페이지 import

class SelectTagsPage extends StatefulWidget {
  final String pickaBookId;

  SelectTagsPage({required this.pickaBookId});

  @override
  _SelectTagsPageState createState() => _SelectTagsPageState();
}

class _SelectTagsPageState extends State<SelectTagsPage> {
  final CollectionReference _tagCollection = FirebaseFirestore.instance.collection('tagDB');
  List<String> _selectedTags = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  void _saveSelectedTags() async {
    if (_selectedTags.isNotEmpty) {
      try {
        DocumentReference pickaBookRef = FirebaseFirestore.instance.collection('pickabookDB').doc(widget.pickaBookId);

        // 태그 정보 업데이트
        await pickaBookRef.update({
          'tags': _selectedTags,
        });

        // 선택된 태그들의 pickednum 값을 1씩 증가
        for (String tagId in _selectedTags) {
          DocumentReference tagRef = _tagCollection.doc(tagId);
          await tagRef.update({
            'pickednum': FieldValue.increment(1),
          });
        }

        // 태그 선택 후 웹툰 선택 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectWebtoonsPage(pickaBookId: widget.pickaBookId),
          ),
        ).then((_) {
          Navigator.pop(context); // 웹툰 선택이 끝나면 이전 화면으로 돌아갑니다.
        });
      } catch (e) {
        print('Error updating PickaBook with tags: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('태그를 저장하는 중 오류가 발생했습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('적어도 하나의 태그를 선택해주세요.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('태그 선택'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveSelectedTags,
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
                  labelText: '태그 검색',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _tagCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('데이터를 불러오는데 오류가 발생했습니다.'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('태그 데이터가 없습니다.'));
                  }

                  // 태그 목록 필터링
                  final tags = snapshot.data!.docs.where((doc) {
                    var tagName = (doc['name'] ?? '').toString().toLowerCase(); // 수정: 'name' 필드 사용
                    return tagName.contains(_searchText);
                  }).toList();

                  return ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      var tag = tags[index].data() as Map<String, dynamic>;
                      var tagId = tags[index].id;

                      return CheckboxListTile(
                        title: Text(tag['name'] ?? '태그 없음'), // 수정: 'name' 필드 사용
                        value: _selectedTags.contains(tagId),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedTags.add(tagId);
                            } else {
                              _selectedTags.remove(tagId);
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
        ));
  }
}
