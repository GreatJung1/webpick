import 'package:flutter/material.dart';
import 'editPickABook_page.dart';
import 'pickABook_Webtoon_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_pickabook_page.dart';

class PickABook {
  String coverImage = 'assets/icons/Component 4.png';
  final String title;
  bool isPublic;
  int likes; // 좋아요 필드 추가

  PickABook({
    this.coverImage = 'assets/icons/Component 4.png',
    required this.title,
    this.isPublic = true,
    this.likes = 0});
}

class PickABookPage extends StatefulWidget {
  @override
  _PickABookPageState createState() => _PickABookPageState();
}

class _PickABookPageState extends State<PickABookPage> {
  final CollectionReference _pickABookCollection = FirebaseFirestore.instance.collection('pickabookDB');
  List<PickABook> pickABooks = [];

  @override
  void initState() {
    super.initState();
    _fetchPickABooks();
  }

  void _fetchPickABooks() async {
    QuerySnapshot querySnapshot = await _pickABookCollection.get();
    setState(() {
      pickABooks = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        return PickABook(
          title: data['title'] ?? '제목 없음',
          coverImage: data['coverImage'] ?? 'assets/icons/Rectangle_grey.png',
          isPublic: data['isPublic'] ?? true,
          likes: data['likes'] ?? 0, // Firestore에서 좋아요 값 가져오기
        );
      }).toList();
    });
  }

  // 좋아요 수 업데이트 메소드
  Future<void> _updateLikeCount(String documentId, int currentLikes) async {
    await _pickABookCollection.doc(documentId).update({
      'likes': currentLikes + 1, // 좋아요 수 증가
    });
  }

  void _createPickABook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePickaBookPage(),
      ),
    );
  }

  void _editPickABook(String documentId, PickABook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPickABookPage(pickABook: book, documentId: documentId),
      ),
    );
  }

  void _deletePickABook(String documentId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('선택한 픽카북을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(false); // 취소하면 false 반환
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop(true); // 삭제하면 true 반환
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      try {
        await _pickABookCollection.doc(documentId).delete();
        print('픽카북 삭제됨: $documentId');
      } catch (e) {
        print('Error deleting pickABook: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'webpick',
          style: TextStyle(
            fontFamily: 'EF_cucumbersalad',
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pickABookCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는데 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('픽카북이 없습니다.'));
          }

          final pickaBooks = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 30,
              childAspectRatio: 3 / 5,
            ),
            itemCount: pickaBooks.length + 1, // 새로 만들기 버튼 포함
            itemBuilder: (context, index) {
              if (index == pickaBooks.length) {
                return GestureDetector(
                  onTap: _createPickABook,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }

              var pickaBookData = pickaBooks[index].data() as Map<String, dynamic>;
              var documentId = pickaBooks[index].id;
              var pickABook = PickABook(
                title: pickaBookData['title'] ?? '제목 없음',
                coverImage: pickaBookData['coverImage'] ?? 'assets/icons/Rectangle_grey.png',
                isPublic: pickaBookData['isPublic'] ?? true,
                likes: pickaBookData['likes'] ?? 0,
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickABookWebtoonPage(
                        webtoon: Webtoon(
                          title: pickABook.title,
                          coverImageUrl: pickABook.coverImage,
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(pickABook.coverImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pickABook.title,
                            style: TextStyle(
                              fontFamily: 'Pretendard-Light.otf',
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Colors.red,
                              onPressed: () async {
                                await _updateLikeCount(documentId, pickABook.likes);
                              },
                            ),
                            Text('${pickABook.likes}'),
                          ],
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editPickABook(documentId, pickABook);
                            } else if (value == 'delete') {
                              _deletePickABook(documentId);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('수정'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('삭제'),
                              ),
                            ];
                          },
                        ),
                      ],
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
