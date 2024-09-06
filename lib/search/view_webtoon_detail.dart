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
      appBar: AppBar(
        title: Text("' $searchQuery ' 로 검색한 결과입니다.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 검색 결과 개수 표시
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
                      '웹툰 (${filteredDocs.length})',
                      style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
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
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              documentSnapshot['title'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: Text(
                              'Writer: ${documentSnapshot['writer']}\nPlatform: ${documentSnapshot['platform']}',
                              style: TextStyle(fontSize: 13),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndividualWebtoonDetailPage(
                                    webtoonId: documentSnapshot.id, // 웹툰의 ID 전달
                                  ),
                                ),
                              );
                            },
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
