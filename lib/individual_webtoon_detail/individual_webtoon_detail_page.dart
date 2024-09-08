import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndividualWebtoonDetailPage extends StatelessWidget {
  final String webtoonId;

  IndividualWebtoonDetailPage({Key? key, required this.webtoonId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webtoonCollection = FirebaseFirestore.instance.collection("webtoonDB");

    return Scaffold(
      appBar: AppBar(
        title: Text('웹툰 상세보기',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: webtoonCollection.doc(webtoonId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] ?? '제목 없음',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '작가: ${data['writer'] ?? '정보 없음'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '플랫폼: ${data['platform'] ?? '정보 없음'}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
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
