/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homework/Pick_A_Book/select_webtoons_page.dart';

import 'create_pickabook_page.dart'; // 파이어베이스 추가

class PickABookWebtoonPage extends StatefulWidget {
  @override
  _PickABookPageState createState() => _PickABookPageState();
}

class _PickABookPageState extends State<PickABookPage> {
  final CollectionReference _pickaBookCollection = FirebaseFirestore.instance.collection('pickabookDB');

  void _deletePickABook(String pickaBookId) async {
    try {
      await _pickaBookCollection.doc(pickaBookId).delete();
      print('픽카북 삭제됨: $pickaBookId');
    } catch (e) {
      print('픽카북 삭제 중 오류 발생: $e');
    }
  }

  void _editPickABook(String pickaBookId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectWebtoonsPage(pickaBookId: pickaBookId), // 웹툰 선택 페이지로 이동
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 픽카북'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePickaBookPage()), // 새 픽카북 생성 페이지로 이동
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pickaBookCollection.snapshots(), // Firestore의 컬렉션의 실시간 스트림을 구독
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('픽카북이 없습니다.'));
          }

          final pickaBooks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pickaBooks.length,
            itemBuilder: (context, index) {
              var pickaBook = pickaBooks[index].data() as Map<String, dynamic>;
              var pickaBookId = pickaBooks[index].id;

              return ListTile(
                title: Text(pickaBook['title'] ?? '제목 없음'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editPickABook(pickaBookId), // 편집 버튼 클릭 시 동작
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deletePickABook(pickaBookId), // 삭제 버튼 클릭 시 동작
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import '../search/search.dart'; // 미리 만들어 놓은 검색 페이지 클래스

class Webtoon {
  String title;
  String coverImageUrl;
  bool isSelected;

  Webtoon({
    required this.title,
    required this.coverImageUrl,
    this.isSelected = false,
  });
}

class PickABookWebtoonPage extends StatefulWidget {
  final Webtoon? webtoon; // 선택적 웹툰 매개변수

  PickABookWebtoonPage({this.webtoon});

  @override
  _PickABookWebtoonPageState createState() => _PickABookWebtoonPageState();
}

class _PickABookWebtoonPageState extends State<PickABookWebtoonPage> {
  List<Webtoon> _webtoons = [
    Webtoon(title: '웹툰 1', coverImageUrl: 'assets/icons/Rectangle_grey.png'), //구현 확인 위해 이미지로 바꿔놓음 원래는 경로
    Webtoon(title: '웹툰 2', coverImageUrl: 'assets/icons/Rectangle_grey.png'), //구현 확인 위해 이미지로 바꿔놓음 원래는 경로
    // 추가 웹툰 데이터
  ];

  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.webtoon != null) {
      // 전달받은 웹툰이 있으면 리스트에 추가
      _webtoons.add(widget.webtoon!);
    }
  }

  void _toggleSelection(Webtoon webtoon) {
    setState(() {
      webtoon.isSelected = !webtoon.isSelected;
    });
  }

  void _deleteSelectedWebtoons() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('선택한 웹툰을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _webtoons.removeWhere((webtoon) => webtoon.isSelected);
                });
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('삭제'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _addWebtoon() async {
    // 검색 페이지로 이동하여 새로운 웹툰 추가
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchBarPage(), // 미리 만들어 놓은 검색 페이지로 이동
      ),
    );

    if (result != null && result is Webtoon) {
      setState(() {
        _webtoons.add(result); // 검색 페이지에서 반환된 웹툰 추가
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('웹툰 목록'),
        actions: [
          if (!_isSelectionMode)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addWebtoon,
            ),
          if (_isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedWebtoons,
            ),
          IconButton(
            icon: Icon(_isSelectionMode ? Icons.cancel : Icons.select_all),
            onPressed: () {
              setState(() {
                _isSelectionMode = !_isSelectionMode;
                if (!_isSelectionMode) {
                  // 선택 모드 해제 시 모든 선택 해제
                  _webtoons.forEach((webtoon) {
                    webtoon.isSelected = false;
                  });
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _webtoons.length,
        itemBuilder: (context, index) {
          final webtoon = _webtoons[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 웹툰 제목 간의 간격
            child: ListTile(
              leading: Stack(
                children: [
                  Image.asset(
                    webtoon.coverImageUrl,
                    width: 100,
                    height: 150,
                  ),
                  if (webtoon.isSelected)
                    Positioned(
                      right: 0,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
              title: Text(
                webtoon.title,
                style: TextStyle(
                  fontSize: 18, // 글씨 크기 설정// 글씨 두께 설정
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // 간격 설정
              onTap: _isSelectionMode ? () => _toggleSelection(webtoon) : null,
              selected: webtoon.isSelected,
            ),
          );
        },
      ),
    );
  }
}