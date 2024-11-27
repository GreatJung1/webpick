import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webpick'),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'EF_cucumbersalad',
          color: Color(0xFF222831),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //start
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 1.0,  // 1.0은 높이와 너비를 같게 설정
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/banner.png'), // 광고 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center, //bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
            ),

            SizedBox(height: 6),
            SectionTitle(title: '좋아요 많은 웹툰'),
            WebtoonGrid(
              webtoonCollection: FirebaseFirestore.instance
                  .collection('webtoonDB')
                  .orderBy('likeCount', descending: true),
            ),

            SizedBox(height: 16),
            SectionTitle(title: 'Pick a Book에 많이 들어간 웹툰'),
            WebtoonGrid(
              webtoonCollection: FirebaseFirestore.instance
                  .collection('webtoonDB')
                  .orderBy('pickednum', descending: true),
            ),

            SizedBox(height: 16),
            SectionTitle(title: '좋아요 많은 Pick a Book'),
            PickABookList(), // 임의로 고정된 리스트

            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 4/1,  // 1.0은 높이와 너비를 같게 설정
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/mini banner.png'), // 광고 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center, //bottomLeft
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
            ),

            SizedBox(height: 16),
            SectionTitle(title: '# 추천 태그'),
            TagsGrid(), // 임의로 고정된 태그 리스트

            SizedBox(height: 20),
            SectionTitle(title: 'AI 웹툰 추천'),
            WebtoonGrid(
              webtoonCollection: FirebaseFirestore.instance
                  .collection('webtoonDB')
                  .where('aiRecommended', isEqualTo: true),
            ),

            SizedBox(height: 16),
            SectionTitle(title: 'AI Pick a Book 추천'),
            PickABookList(),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// 섹션 제목 위젯
class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16.0, // 텍스트 크기 설정
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            color: Color(0xFF222831)
        ),
      ),
    );
  }
}

// 웹툰 그리드 위젯
class WebtoonGrid extends StatelessWidget {
  final Query webtoonCollection;

  WebtoonGrid({required this.webtoonCollection});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 194,
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

            final docs = streamSnapshot.data!.docs;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                String title = doc['title'] ?? '제목 없음';

                return WebtoonCard(
                  title: title,
                  webtoonId: doc.id,
                  platformImage: doc['platform']?.toString().toLowerCase() == '카카오'
                      ? 'assets/icons/Kakao.png'
                      : 'assets/icons/Naver.png',
                  imageUrl: 'assets/icons/Rectangle_grey.png',
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class PickABookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 194,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pickabookDB')
              .orderBy('likes', descending: true)
              .limit(5) // 상위 5개
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                String title = doc['title'] ?? '제목 없음';

                return Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 10.0, 2.0, 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: 100,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.book,
                          size: 40,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 2.0, 3.0, 0.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}



// 태그 그리드 위젯
class TagsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tagDB')
            .orderBy('count', descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(docs.length, (index) {
              var tagData = docs[index].data() as Map<String, dynamic>;
              return Container(
                height: 22,
                width: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFF76ABAE),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Text(
                    '# ${tagData['name']}',  // Firestore의 태그 이름으로 대체
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// 웹툰 카드 위젯
class WebtoonCard extends StatelessWidget {
  final String title;
  final String webtoonId;
  final String platformImage;
  final String imageUrl;

  WebtoonCard({
    required this.title,
    required this.webtoonId,
    required this.platformImage,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 10.0, 2.0, 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndividualWebtoonDetailPage(
                webtoonId: webtoonId,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 100, // 너비를 150으로 제한
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.0, 2.0, 3.0, 0.0), // 여백 설정
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                  overflow: TextOverflow.ellipsis, // 말줄임표(...) 설정
                  maxLines: 1, // 최대 1줄까지만 표시
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
// 웹툰 상세 페이지 (예시로 추가)
class IndividualWebtoonDetailPage extends StatelessWidget {
  final String webtoonId;

  IndividualWebtoonDetailPage({required this.webtoonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('웹툰 상세 페이지'),
      ),
      body: Center(
        child: Text('웹툰 ID: $webtoonId'),
      ),
    );
  }
}
 */