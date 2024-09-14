import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './view_webtoon_detail.dart';
import './view_pickabook_detail.dart';

Widget buildGeneralSearchBody({
  required TextEditingController searchController,
  required String searchQuery,
  required CollectionReference webtoonCollection,
  required void Function(String) onSearchChange,
  required BuildContext context,
  required CollectionReference webtoonTagCollection,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 0.5,
        color: Colors.grey,
      ),
      Container(
        padding: const EdgeInsets.only(left: 16.0, right: 6.0),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChange,
          decoration: InputDecoration(
            hintText: '제목, 작가 이름 검색',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'Pretendard',),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0), // 상하 패딩 조정
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 8.0), // 아이콘과 텍스트 사이의 여백
              child: Image.asset(
                'assets/icons/Search.png', // assets 폴더의 이미지 파일
                width: 40.0, // 원하는 너비
                height: 40.0, // 원하는 높이
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0), // 아이콘과 텍스트 사이의 여백
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/Dell_duotone.png', // assets 폴더의 이미지 파일
                  width: 24.0, // 원하는 너비
                  height: 24.0, // 원하는 높이
                ),
                onPressed: () {
                  // 아이콘 클릭 시 동작 추가
                  print('Suffix icon pressed');
                  searchController.clear(); // 입력 필드 비우기
                },
              ),
            ),
          ),
        ),
      ),
      Container(
        height: 1.0,
        width: double.infinity,
        color: Color(0xFF222831),
      ),
      Container(
        padding: EdgeInsets.only(left: 15.0, top: 0.0, right: 10.0, bottom: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: webtoonCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final writer = doc['writer'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase()) ||
                        writer.contains(searchQuery.toLowerCase());
                  }).toList();

                  return Text(
                    '웹툰 (${filteredDocs.length})',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14.0,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else if (streamSnapshot.hasError) {
                  return Text(
                    '웹툰 (0)',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    '웹툰 (0)',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13.0,
                      color: Colors.grey.shade200,
                    ),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                print("더보기 버튼 클릭됨");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewWebtoonDetailPage(searchQuery: searchQuery),
                  ),
                );
              },
              child: Text(
                '더보기 >',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.36,
        child: StreamBuilder<QuerySnapshot>(
          stream: webtoonCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                final title = doc['title'].toString().toLowerCase();
                final writer = doc['writer'].toString().toLowerCase();
                return title.contains(searchQuery.toLowerCase()) ||
                    writer.contains(searchQuery.toLowerCase());
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 위젯을 세로 방향으로 중앙 정렬
                    crossAxisAlignment: CrossAxisAlignment.center, // 위젯을 가로 방향으로 중앙 정렬
                    children: [
                      Text(
                        'webpick',
                        style: TextStyle(
                          fontFamily: 'Salad',
                          fontSize: 20.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10
                      ),
                      Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
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
                                  Stack(
                                    children: [
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
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Container(
                                          width: 14, // 아이콘의 너비
                                          height: 14, // 아이콘의 높이
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  documentSnapshot['platform']?.toString().toLowerCase() == '카카오'
                                                      ? 'assets/icons/Kakao.png'
                                                      : 'assets/icons/Naver.png'
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // 글 리스트 부분
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            documentSnapshot['title'],
                                            style: TextStyle(
                                              color: Color(0xFF222831),
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 19,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${documentSnapshot['writer']}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            documentSnapshot['end']
                                                ? '${documentSnapshot['genre']} ${documentSnapshot['episode']}화 완결'
                                                : '${documentSnapshot['genre']} ${documentSnapshot['episode']}화 ${documentSnapshot['weekday']}요일',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 23, // 첫 번째 이미지의 너비
                                    height: 20,
                                    margin: EdgeInsets.all(10), // 이미지와 텍스트 간의 간격 조정
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/icons/like.png'), // 첫 번째 이미지 경로
                                        fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                                      ),
                                    ),
                                  ),
                                  // 두 번째 이미지
                                  Container(
                                    width: 24, // 두 번째 이미지의 너비
                                    height: 17,
                                    margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/icons/box.png'), // 두 번째 이미지 경로
                                        fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
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
      Container(
        height: 0.5,
        width: double.infinity,
        color: Colors.grey.shade600,
      ),
      //피카북
      Container(
        padding: EdgeInsets.only(left: 15.0, top: 0.0, right: 10.0, bottom: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: webtoonCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final writer = doc['writer'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase()) ||
                        writer.contains(searchQuery.toLowerCase());
                  }).toList();

                  return Text(
                    '피카북 (${filteredDocs.length})',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14.0,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else if (streamSnapshot.hasError) {
                  return Text(
                    '피카북 (0)',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    '피카북 (0)',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13.0,
                      color: Colors.grey.shade200,
                    ),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                print("더보기 버튼 클릭됨");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPickabookDetailPage(searchQuery: searchQuery),
                  ),
                );
              },
              child: Text(
                '더보기 >',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        //height: MediaQuery.of(context).size.height * 0.36,
        child: StreamBuilder<QuerySnapshot>(
          stream: webtoonCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                final title = doc['title'].toString().toLowerCase();
                final writer = doc['writer'].toString().toLowerCase();
                return title.contains(searchQuery.toLowerCase()) ||
                    writer.contains(searchQuery.toLowerCase());
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 위젯을 세로 방향으로 중앙 정렬
                    crossAxisAlignment: CrossAxisAlignment.center, // 위젯을 가로 방향으로 중앙 정렬
                    children: [
                      Text(
                        'webpick',
                        style: TextStyle(
                          fontFamily: 'Salad',
                          fontSize: 20.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                          height: 10
                      ),
                      Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
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
  );
}
