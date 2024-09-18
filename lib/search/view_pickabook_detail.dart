import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';
import './search_class_manager.dart';

class ViewPickabookDetailPage extends StatefulWidget {
  final CollectionReference pickabookCollection = FirebaseFirestore.instance
      .collection("webtoonDB"); //pickabook으로 변경해야..
  final String searchQuery;

  ViewPickabookDetailPage({required this.searchQuery});

  @override
  _ViewPickabookDetailPage createState() => _ViewPickabookDetailPage();
}

class _ViewPickabookDetailPage extends State<ViewPickabookDetailPage> {
  final CollectionReference webtoonCollection = FirebaseFirestore.instance.collection("webtoonDB");
  List<String> _imagePath = [];

  void _changeImage(int index) {
    setState(() {
      if (index >= 0 && index < _imagePath.length) {
        if (_imagePath[index] == 'assets/icons/like.png') {
          _imagePath[index] = 'assets/icons/Component 3.png'; // 클릭 후 변경될 이미지 경로
        } else {
          _imagePath[index] = 'assets/icons/like.png'; // 클릭 후 원래 이미지로 되돌리기
        }
      } else {
        print('Index out of range');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 원하는 배경색으로 설정
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // AppBar의 높이를 70으로 설정
        child: AppBar(
          title: Text(
            "${widget.searchQuery}로 검색한 결과입니다.",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16.0,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true, // 제목을 중앙에 위치시키기 위해 추가
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 0.5,
            color: Colors.grey,
          ),
          // 검색 결과 개수 표시
          Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.pickabookCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final writer = doc['writer'].toString().toLowerCase();
                    return title.contains(widget.searchQuery.toLowerCase()) ||
                        writer.contains(widget.searchQuery.toLowerCase());
                  }).toList();

                  return Text(
                    '  ${filteredDocs.length}개',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else if (streamSnapshot.hasError) {
                  return Text(
                    '검색 결과 개수: 0',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    '검색 결과 개수: 0',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
          ),
          // 검색 결과 목록
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.pickabookCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final writer = doc['writer'].toString().toLowerCase();
                    return title.contains(widget.searchQuery.toLowerCase()) ||
                        writer.contains(widget.searchQuery.toLowerCase());
                  }).toList();

                  while (_imagePath.length <= filteredDocs.length) {
                    _imagePath.add('assets/icons/like.png');
                  }

                  if (filteredDocs.isEmpty) {
                    return Center(child: Text('검색 결과가 없습니다'));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = filteredDocs[index];
                      return PickaBookItem(
                        documentSnapshot: documentSnapshot,
                        onImageTap: () => _changeImage(index), // 익명 함수를 사용하여 함수 참조 전달
                        imagePath: _imagePath[index],
                      );
                    },
                  );
                } else if (streamSnapshot.hasError) {
                  return Center(child: Text('Error: ${streamSnapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}