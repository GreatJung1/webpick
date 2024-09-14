import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../individual_tag_detail/individual_tag_detail_page.dart';

class IndividualWebtoonDetailPage extends StatelessWidget {
  final String webtoonId;

  IndividualWebtoonDetailPage({Key? key, required this.webtoonId}) : super(key: key);

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
        future: webtoonCollection.doc(webtoonId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String webtoonUrl = data['link'] ?? '';
            final String title = data['title'] ?? '제목 없음';
            final String description = data['description'] ?? '';

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 0.5,
                        color: Colors.grey,
                        width: double.infinity,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 150.0,
                            height: 180.0,
                            margin: EdgeInsets.only(left: 36.0, right: 46.0, top: 32.0, bottom: 32.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF222831), width: 2.0),
                            ),
                          ),
                          Column(
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
                                    '${data['writer'] ?? '정보 없음'}/',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Pretendard',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${data['genre'] ?? '정보 없음'}/',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Pretendard',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${data['platform'] ?? '정보 없음'}',
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
                                    '${data['episode'] ?? '정보 없음'}화/',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Pretendard',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    data['end'] ? '완결' : '${data['weekday'] ?? '정보 없음'}요일',
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
                        ],
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 24),

                      FutureBuilder<QuerySnapshot>(
                        future: webtoonTagCollection.where('webtoon', isEqualTo: this.webtoonId).get(),
                        builder: (context, tagSnapshot) {
                          if (tagSnapshot.hasData) {
                            final tagIds = tagSnapshot.data!.docs
                                .map((doc)  => doc['tag'] as String)
                                .toList();

                            return FutureBuilder<List<String>>(
                              future: Future.wait(
                                tagIds.map((tagId) async {
                                  final tagDoc = await tagCollection.doc(tagId).get();
                                  final tagData = tagDoc.data() as Map<String, dynamic>;
                                  return tagData['name'] as String;
                                }).toList(),
                              ),
                              builder: (context, nameSnapshot) {
                                if (nameSnapshot.hasData) {
                                  final tagNames = nameSnapshot.data!;
                                  return Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: tagNames.length,
                                          itemBuilder: (context, index) {
                                            final tagName = tagNames[index];
                                            return GestureDetector(
                                              onTap: () {
                                                // 여기에 이동할 페이지의 클래스를 적어줍니다.
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => IndividualTagDetailPage(tagIds: (int.parse(tagIds[index]) ).toString()),
                                                    // TagDetailPage는 예시로 사용한 페이지 클래스입니다.
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF76ABAE),
                                                  borderRadius: BorderRadius.circular(4.0),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text(
                                                      '# $tagName',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 24), // 태그와 구분선 사이의 간격
                                      Container(
                                        height: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(16.0), // Container의 여백 설정
                                        decoration: BoxDecoration(
                                          color: Colors.white, // 배경색 설정
                                          borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 설정
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0), // Padding의 여백 설정
                                          child: Text(
                                            description, // description을 표시
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Pretendard',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                } else if (nameSnapshot.hasError) {
                                  return Center(child: Text('Error: ${nameSnapshot.error}'));
                                } else {
                                  return Center(child: CircularProgressIndicator());
                                }
                              },
                            );
                          } else if (tagSnapshot.hasError) {
                            return Center(child: Text('Error: ${tagSnapshot.error}'));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await canLaunch(webtoonUrl)) {
                        await launch(webtoonUrl);
                      } else {
                        throw 'Could not launch $webtoonUrl';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF76ABAE),
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(
                          color: Color(0xFF76ABAE),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '보러 가기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Color(0xFF76ABAE),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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