import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

class IndividualTagDetailPage extends StatelessWidget {
  final String tagIds;  // tagIds를 전달받는 변수

  IndividualTagDetailPage({Key? key, required this.tagIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webtoonCollection = FirebaseFirestore.instance.collection("webtoonDB");
    final webtoonTagCollection = FirebaseFirestore.instance.collection("webtoon_tagDB");
    final tagCollection = FirebaseFirestore.instance.collection("tagDB");

    return Scaffold(
      backgroundColor: Colors.white, // 전체 화면 배경색 설정
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 30.0), // 왼쪽 마진을 설정
          child: Text(
            'webpick',
            style: TextStyle(
              fontFamily: 'Salad',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70, // AppBar의 높이를 70으로 설정
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: tagCollection.doc(this.tagIds).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String name = data['name'] ?? '';


            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 48),
                      Center(
                        child: IntrinsicWidth(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF76ABAE),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0), // 세로 간격 조절 가능
                                child: Text(
                                  '# $name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),//여기에 좋아요 싫어요
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Stack(
                          alignment: Alignment.center, // 텍스트와 배경을 중앙 정렬
                          children: [
                            // 검은색 박스 배경
                            Positioned(
                              child: Container(
                                width: 330,
                                height : 90,
                                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800, // 배경색
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: double.infinity, // 최대 너비를 무한대로 설정
                                  minWidth: 0, // 최소 너비를 0으로 설정
                                ),
                              ),
                            ),
                            // 텍스트

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
                              child: Text(
                                '이 태그를 가지고 있는 \n           웹툰들을 보여줄게요 !',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Pretendard',
                                  color: Color(0xFF76ABAE), // 내부 텍스트 색상
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),

                      FutureBuilder<QuerySnapshot>(
                        future: webtoonTagCollection.where('tag', isEqualTo: this.tagIds).get(),
                        builder: (context, tagSnapshot) {
                          if (tagSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: Text(''));
                          } else if (tagSnapshot.hasError) {
                            return Center(child: Text('Error: ${tagSnapshot.error}'));
                          } else if (!tagSnapshot.hasData || tagSnapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No webtoons found for this tag'));
                          } else {
                            final webtoonIds = tagSnapshot.data!.docs
                                .map((doc) => doc['webtoon'] as String)
                                .toList();

                            return FutureBuilder<List<DocumentSnapshot>>(
                              future: Future.wait(
                                webtoonIds.map((webtoonId) async {
                                  final webtoonDoc = await webtoonCollection.doc(webtoonId).get();
                                  return webtoonDoc;
                                }).toList(),
                              ),
                              builder: (context, webtoonSnapshot) {
                                if (webtoonSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (webtoonSnapshot.hasError) {
                                  return Center(child: Text('Error: ${webtoonSnapshot.error}'));
                                } else if (!webtoonSnapshot.hasData || webtoonSnapshot.data!.isEmpty) {
                                  return Center(child: Text('No webtoon details found'));
                                } else {
                                  final webtoonData = webtoonSnapshot.data!;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 24), // 태그와 구분선 사이의 간격
                                      ...webtoonData.map((doc) {
                                        final data = doc.data() as Map<String, dynamic>;
                                        final title = data['title'] ?? '제목 없음';
                                        final writer = data['writer'] ?? '정보 없음';
                                        final genre = data['genre'] ?? '정보 없음';
                                        final platform = data['platform'] ?? '정보 없음';
                                        final episode = data['episode'] ?? '정보 없음';
                                        final end = data['end'] ? '완결' : '${data['weekday'] ?? '정보 없음'}요일';
                                        final webtoonId = doc.id; // 웹툰 ID를 추출

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => IndividualWebtoonDetailPage(
                                                  webtoonId: webtoonId, // 웹툰 ID 전달
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 150.0,
                                                  height: 180.0,
                                                  margin: EdgeInsets.only(left: 36.0, right: 16.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Color(0xFF222831), width: 2.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(data['imageUrl'] ?? ''),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        title,
                                                        style: TextStyle(
                                                          color: Color(0xFF222831),
                                                          fontFamily: 'Pretendard',
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '$writer/',
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            '$genre/',
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            platform,
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '$episode화/',
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            end,
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 40),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/icons/like.png',
                                                            width: 25,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Image.asset(
                                                            'assets/icons/box.png',
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),





                    ],
                  ),
                ),

              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}