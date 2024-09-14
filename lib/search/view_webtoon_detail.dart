import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

class ViewWebtoonDetailPage extends StatelessWidget {
  final CollectionReference webtoonCollection = FirebaseFirestore.instance.collection("webtoonDB");
  final String searchQuery;

  ViewWebtoonDetailPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
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
          centerTitle: true,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 0.5,
            color: Colors.grey,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
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

                  return Text(
                    '  ${filteredDocs.length}개',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else {
                  return Text('검색 결과 개수: 0');
                }
              },
            ),
          ),
          Expanded(
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
                    return Center(child: Text('검색 결과가 없습니다'));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = filteredDocs[index];
                      return GestureDetector(
                        onTap: () {
                          // 클릭하면 IndividualWebtoonDetailPage로 이동하고, 해당 웹툰 ID를 전달
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualWebtoonDetailPage(
                                webtoonId: documentSnapshot.id, // 웹툰 ID 전달
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Material(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          margin: EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: AssetImage('assets/icons/Naver_Line_Webtoon_logo.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    documentSnapshot['platform']?.toString().toLowerCase() == 'kakao'
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
                                      width: 23,
                                      height: 20,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/icons/like.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 17,
                                      margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/icons/box.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
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
