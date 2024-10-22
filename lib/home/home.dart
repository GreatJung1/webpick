import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text('웹툰 목록'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/banner.png'), // 광고 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4),
            SectionTitle(title: '좋아요 많은 웹툰'),
            WebtoonGrid(
              webtoonCollection: FirebaseFirestore.instance
                  .collection('webtoonDB')
                  .orderBy('likeCount', descending: true),
            ),

            SizedBox(height: 4),
            SectionTitle(title: 'Pick a Book에 많이 들어간 웹툰'),
            WebtoonGrid(
              webtoonCollection: FirebaseFirestore.instance
                  .collection('webtoonDB')
                  .orderBy('pickCount', descending: true),
            ),

            SizedBox(height: 4),
            SectionTitle(title: '좋아요 많은 Pick a Book'),
            PickABookList(), // 임의로 고정된 리스트

            SizedBox(height: 4),
            SectionTitle(title: '# 추천 태그'),
            TagsGrid(), // 임의로 고정된 태그 리스트

            SizedBox(height: 4),
            SectionTitle(title: 'AI 웹툰 추천'),
            WebtoonGrid(
              webtoonCollection: FirebaseFirestore.instance
                  .collection('webtoonDB')
                  .where('aiRecommended', isEqualTo: true),
            ),

            SizedBox(height: 4),
            SectionTitle(title: 'AI Pick a Book 추천'),
            PickABookList(),

            SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          color: Color(0xFF222831),
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
        height: 120,
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
                  imageUrl: 'assets/icons/like.png',
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// 픽카북 리스트 위젯
class PickABookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 80,
                color: Colors.grey[300],
                child: Icon(Icons.book, size: 40, color: Colors.grey[700]),
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 73,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(platformImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
