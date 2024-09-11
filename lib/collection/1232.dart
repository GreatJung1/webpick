import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget buildGenreWebtoonBody({
  required CollectionReference webtoonCollection,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 장르 섹션
        Column(
          children: [
            Container(
              height: 1.5,
              color: Colors.black,
            ),
            Row(
              children: [
                ...List.generate(5, (index) => _buildGenreCell('장르${index + 1}', index % 2 == 0))
              ],
            ),
            Container(
              height: 1.5,
              color: Colors.black,
            ),
          ],
        ),
        SizedBox(height: 8.0),

        // 네이버, 전체, 카카오 섹션
        Row(
          children: [
            _buildTextCell('네이버', EdgeInsets.only(left: 70)),
            _buildTextCell('전체'),
            _buildTextCell('카카오', EdgeInsets.only(right: 70)),
          ],
        ),
        SizedBox(height: 8.0),

        // 구분선
        Container(
          height: 1.5,
          color: Colors.black,
        ),

        // 기타 텍스트
        Row(
          children: List.generate(5, (index) => _buildTextCell('ㅇㄹ')),
        ),
        SizedBox(height: 30.0),

        // Firestore 데이터 표시 부분
        Container(
          height: MediaQuery.of(context).size.height * 0.36,
          child: StreamBuilder<QuerySnapshot>(
            stream: webtoonCollection.snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (streamSnapshot.hasError) {
                return Center(child: Text('오류 발생: ${streamSnapshot.error}'));
              }

              if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
                return Center(child: Text('데이터 없음'));
              }

              // 문서 목록을 가져와서 Column으로 표시
              return Column(
                children: streamSnapshot.data!.docs.map((doc) {
                  String title = doc['title'] ?? '제목 없음';
                  String writer = doc['writer'] ?? '작가 없음';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '제목: $title',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '작가: $writer',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// 장르 셀 위젯 생성
Widget _buildGenreCell(String genre, bool isLight) {
  return Flexible(
    flex: 1,
    child: Container(
      height: 40,
      color: isLight ? Color(0xFF76ABAE) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      alignment: Alignment.center,
      child: Text(
        genre,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
    ),
  );
}

// 텍스트 셀 위젯 생성
Widget _buildTextCell(String text, [EdgeInsetsGeometry? padding]) {
  return Flexible(
    flex: 1,
    child: Container(
      height: 40,
      padding: padding ?? EdgeInsets.zero,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.0,
        ),
      ),
    ),
  );
}
