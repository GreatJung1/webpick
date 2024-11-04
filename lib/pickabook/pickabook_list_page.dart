import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_pickabook_page.dart';
import 'select_webtoons_page.dart';

class PickaBookListPage extends StatefulWidget {
  @override
  _PickaBookListPageState createState() => _PickaBookListPageState();
}

class _PickaBookListPageState extends State<PickaBookListPage> {
  final CollectionReference _pickaBookCollection =
  FirebaseFirestore.instance.collection('pickabookDB');

  void _deletePickaBook(String pickaBookId) {
    _pickaBookCollection.doc(pickaBookId).delete();
  }

  void _editPickaBook(String pickaBookId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectWebtoonsPage(pickaBookId: pickaBookId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 픽카북'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePickaBookPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pickaBookCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는데 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('픽카북이 없습니다.'));
          }

          final pickaBooks = snapshot.data!.docs;
          print(pickaBooks);

          return ListView.builder(
            itemCount: pickaBooks.length,
            itemBuilder: (context, index) {
              var pickaBook = pickaBooks[index].data() as Map<String, dynamic>;
              var pickaBookId = pickaBooks[index].id;
              return ListTile(
                title: Text(pickaBook['title'] ?? '제목 없음'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editPickaBook(pickaBookId),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deletePickaBook(pickaBookId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}