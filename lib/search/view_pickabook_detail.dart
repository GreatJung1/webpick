import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

class ViewPickabookDetailPage extends StatelessWidget {
  final CollectionReference pickabookCollection = FirebaseFirestore.instance.collection("webtoonDB");//pickabook으로 변경해야..
  final String searchQuery;

  ViewPickabookDetailPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 원하는 배경색으로 설정
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // AppBar의 높이를 70으로 설정
        child: AppBar(
          title: Text(
            "' $searchQuery ' 로 검색한 결과입니다.",
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
              stream: pickabookCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final writer = doc['writer'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase()) ||
                        writer.contains(searchQuery.toLowerCase());
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
              stream: pickabookCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final writer = doc['writer'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase()) ||
                        writer.contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(child: Text('검색 결과가 없습니다'));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = filteredDocs[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Material(
                          color: Colors.white,
                          child: Column(
                            children: [
                              // 기존 Row 위젯
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center, // 상하 중앙 정렬
                                children: [
                                  // 사진 부분
                                  Container(
                                    width: 80, // 원하는 사진의 너비
                                    height: 80, // 원하는 사진의 높이
                                    margin: EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
                                      image: DecorationImage(
                                        image: AssetImage('assets/icons/Naver_Line_Webtoon_logo.png'),
                                        fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                                      ),
                                    ),
                                  ),
                                  // 글 리스트 부분
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  documentSnapshot['title'],
                                                  style: TextStyle(
                                                    color: Color(0xFF222831),
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 23, // 첫 번째 이미지의 너비
                                                height: 20,
                                                margin: EdgeInsets.only(left: 10.0, right: 20.0), // 이미지와 텍스트 간의 간격 조정
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/icons/like.png'), // 첫 번째 이미지 경로
                                                    fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                              children: [
                                                Container(
                                                  height: 22,
                                                  width: 74,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF76ABAE), // 배경색 설정
                                                    borderRadius: BorderRadius.circular(4.0), // 모서리를 둥글게 설정
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '# ${documentSnapshot['writer']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        overflow: TextOverflow.ellipsis, // 줄임표 설정
                                                      ),
                                                      textAlign: TextAlign.center, // 텍스트 자체를 중앙 정렬
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 18,
                                                ),
                                                Container(
                                                  height: 22,
                                                  width: 74,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF76ABAE), // 배경색 설정
                                                    borderRadius: BorderRadius.circular(4.0), // 모서리를 둥글게 설정
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '# ${documentSnapshot['writer']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        overflow: TextOverflow.ellipsis, // 줄임표 설정
                                                      ),
                                                      textAlign: TextAlign.center, // 텍스트 자체를 중앙 정렬
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 18,
                                                ),
                                                Container(
                                                  height: 22,
                                                  width: 74,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF76ABAE), // 배경색 설정
                                                    borderRadius: BorderRadius.circular(4.0), // 모서리를 둥글게 설정
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '# ${documentSnapshot['writer']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        overflow: TextOverflow.ellipsis, // 줄임표 설정
                                                      ),
                                                      textAlign: TextAlign.center, // 텍스트 자체를 중앙 정렬
                                                    ),
                                                  ),
                                                )
                                              ]
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // 새로운 요소 추가
                              Container(
                                height: 0.5,
                                width: double.infinity,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
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