import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WebtoonListPage extends StatefulWidget {
  @override
  _WebtoonListPageState createState() => _WebtoonListPageState();
}

class _WebtoonListPageState extends State<WebtoonListPage> {
  final CollectionReference _webtoonCollection =
  FirebaseFirestore.instance.collection('webtoonDB');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('웹툰 리스트'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _webtoonCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는데 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('데이터가 없습니다.'));
          }

          final webtoons = snapshot.data!.docs;

          return ListView.builder(
            itemCount: webtoons.length,
            itemBuilder: (context, index) {
              var webtoon = webtoons[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(webtoon['title'] ?? '제목 없음'),
                subtitle: Text('${webtoon['writer']} - ${webtoon['platform']}'),
                trailing: Checkbox(
                  value: false,
                  onChanged: (value) {
                    // 체크박스를 클릭했을 때 동작 정의
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}