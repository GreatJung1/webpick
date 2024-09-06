import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './view_webtoon_detail.dart';

Widget buildGeneralSearchBody({
  required TextEditingController searchController,
  required String searchQuery,
  required CollectionReference webtoonCollection,
  required void Function(String) onSearchChange,
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChange,
          decoration: InputDecoration(
            hintText: '제목, 작가 이름 검색',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                print('Search icon pressed');
              },
            ),
          ),
        ),
      ),
      Container(
        height: 1.0,
        width: double.infinity,
        color: Colors.grey.shade600,
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
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (streamSnapshot.hasError) {
                  return Text(
                    '웹툰 (0)',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    '웹툰 (0)',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
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
                  fontSize: 13.0,
                  color: Colors.blue,
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
                return Center(child: Text('검색 결과가 없습니다'));
              }

              return ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = filteredDocs[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          documentSnapshot['title'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          'Writer: ${documentSnapshot['writer']}\nPlatform: ${documentSnapshot['platform']}',
                          style: TextStyle(fontSize: 13),
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
      Container(
        height: 1.0,
        width: double.infinity,
        color: Colors.grey.shade600,
      ),
      Container(
        padding: EdgeInsets.all(12.0),
        child: Text(
          '피카북',
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    ],
  );
}
