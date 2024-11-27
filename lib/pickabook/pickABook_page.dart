/*
import 'package:flutter/material.dart';
import 'editPickABook_page.dart';
import 'pickABook_Webtoon_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_pickabook_page.dart';

class PickABook {
  String coverImage = 'assets/icons/Naver_Line_Webtoon_logo.png';
  final String title;
  bool isPublic;
  int likes; // 좋아요 필드 추가

  PickABook({this.coverImage = 'assets/icons/Naver_Line_Webtoon_logo.png', required this.title, this.isPublic = true, this.likes = 0});
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
/*
  void _createPickABook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePickaBookPage(),
      ),
    );
  }*/
  void _createPickABook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePickaBookPage(),
      ),
    ).then((_) {
      // 새로고침을 위해 상태를 업데이트하여 StreamBuilder가 Firestore의 변화를 감지하도록 함
      setState(() {});
    });
  }


  void _editPickABook(String documentId, PickABook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPickABookPage(pickABook: book, documentId: documentId),
      ),
    );
  }
/* 태그 추가 이전 ver
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
        // 1. 삭제할 픽카북 문서에서 웹툰 리스트 가져오기
        print("Attempting to get PickaBook document: $documentId");
        DocumentSnapshot docSnapshot = await _pickABookCollection.doc(documentId).get();

        if (docSnapshot.exists) {
          // docSnapshot.data()를 Map<String, dynamic>으로 캐스팅하고 webtoons 필드를 확인
          Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

          // webtoons 필드 확인 및 타입 출력
          if (data != null && data['webtoons'] != null) {
            print("Raw webtoons data: ${data['webtoons']}");
            print("Type of webtoons data: ${data['webtoons'].runtimeType}");

            // List<String>으로 변환
            List<dynamic> webtoonsDynamicList = data['webtoons'];
            List<String> webtoons = webtoonsDynamicList.map((e) => e.toString()).toList();
            print("Webtoons in PickaBook (after conversion): $webtoons");

            // 2. 각 웹툰의 pickednum 값을 1씩 감소시키기 (webtoonDB 컬렉션 참조)
            for (String webtoonId in webtoons) {
              DocumentReference webtoonRef = FirebaseFirestore.instance.collection('webtoonDB').doc(webtoonId);

              try {
                print("Attempting to decrease pickednum for Webtoon ID: $webtoonId");
                DocumentSnapshot webtoonSnapshot = await webtoonRef.get();
                if (webtoonSnapshot.exists) {
                  int currentPickedNum = webtoonSnapshot['pickednum'] ?? 0;
                  print("Current pickednum for Webtoon ID: $webtoonId is $currentPickedNum");
                  if (currentPickedNum > 0) {
                    await webtoonRef.update({
                      'pickednum': currentPickedNum - 1,
                    });
                    print("Decreased pickednum for Webtoon ID: $webtoonId to ${currentPickedNum - 1}");
                  } else {
                    print("Pickednum for Webtoon ID: $webtoonId is already 0, skipping decrement.");
                  }
                } else {
                  print("Webtoon ID: $webtoonId does not exist in webtoonDB.");
                }
              } catch (e) {
                print("Error updating pickednum for Webtoon ID: $webtoonId - $e");
              }
            }
          } else {
            print("No webtoons field found or webtoons field is empty in PickaBook document: $documentId");
          }
        } else {
          print("PickaBook document does not exist: $documentId");
        }

        // 3. 모든 pickednum 감소 후 픽카북 삭제 (pickabookDB 컬렉션에서)
        await _pickABookCollection.doc(documentId).delete();
        print('픽카북 삭제됨: $documentId');
      } catch (e) {
        print('Error deleting pickABook: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('픽카북 삭제 중 오류가 발생했습니다.')),
        );
      }
    }
  }*/
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
        // 기존의 웹툰 및 태그의 pickednum 감소 로직 그대로 유지
        DocumentSnapshot docSnapshot = await _pickABookCollection.doc(documentId).get();

        if (docSnapshot.exists) {
          Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
          List<dynamic> webtoonsDynamicList = data?['webtoons'] ?? [];
          List<String> webtoons = webtoonsDynamicList.map((e) => e.toString()).toList();

          for (String webtoonId in webtoons) {
            DocumentReference webtoonRef = FirebaseFirestore.instance.collection('webtoonDB').doc(webtoonId);
            DocumentSnapshot webtoonSnapshot = await webtoonRef.get();
            if (webtoonSnapshot.exists) {
              int currentPickedNum = webtoonSnapshot['pickednum'] ?? 0;
              if (currentPickedNum > 0) {
                await webtoonRef.update({
                  'pickednum': currentPickedNum - 1,
                });
              }
            }
          }

          List<dynamic> tagsDynamicList = data?['tags'] ?? [];
          List<String> tags = tagsDynamicList.map((e) => e.toString()).toList();

          for (String tagId in tags) {
            DocumentReference tagRef = FirebaseFirestore.instance.collection('tagDB').doc(tagId);
            DocumentSnapshot tagSnapshot = await tagRef.get();
            if (tagSnapshot.exists) {
              int currentPickedNum = tagSnapshot['pickednum'] ?? 0;
              if (currentPickedNum > 0) {
                await tagRef.update({
                  'pickednum': currentPickedNum - 1,
                });
              }
            }
          }
        }

        // 픽카북 문서 삭제
        await _pickABookCollection.doc(documentId).delete();
        print('픽카북 삭제됨: $documentId');

        // 삭제 후 상태 업데이트
        setState(() {}); // 화면을 새로고침하여 삭제된 항목이 반영되도록 함

      } catch (e) {
        print('Error deleting pickABook: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('픽카북 삭제 중 오류가 발생했습니다.')),
        );
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
            itemCount: pickABooks.length + 1, // 새로 만들기 버튼 포함
            itemBuilder: (context, index) {
              if (index == pickABooks.length) {
                return GestureDetector(
                  onTap: () {
                    _createPickABook();
                  },
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
                likes: pickaBookData['likes'] ?? 0, // Firestore에서 좋아요 값 반영
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickABookWebtoonPage(
                        webtoon: Webtoon(
                          title: pickABook.title,
                          coverImageUrl: 'assets/icons/Rectangle_grey.png',
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            // 하트 버튼 추가
                            IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Colors.red,
                              onPressed: () async {
                                // 좋아요 수 증가
                                await _updateLikeCount(documentId, pickABook.likes);
                              },
                            ),
                            // 좋아요 수 표시
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
*/
import 'package:flutter/material.dart';
import 'editPickABook_page.dart';
import 'pickABook_Webtoon_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_pickabook_page.dart';

class PickABook {
  String coverImage = 'assets/icons/Naver_Line_Webtoon_logo.png';
  final String title;
  bool isPublic;
  int likes;

  PickABook({this.coverImage = 'assets/icons/Naver_Line_Webtoon_logo.png', required this.title, this.isPublic = true, this.likes = 0});
}

class PickABookPage extends StatefulWidget {
  @override
  _PickABookPageState createState() => _PickABookPageState();
}

class _PickABookPageState extends State<PickABookPage> {
  final CollectionReference _pickABookCollection = FirebaseFirestore.instance.collection('pickabookDB');

  void _createPickABook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePickaBookPage(),
      ),
    ).then((_) {
      // 돌아왔을 때 새로고침
      setState(() {});
    });
  }

  Future<void> _updateLikeCount(String documentId, int currentLikes) async {
    await _pickABookCollection.doc(documentId).update({
      'likes': currentLikes + 1,
    });
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
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      try {
        // 1. 삭제할 픽카북 문서에서 웹툰 및 태그 리스트 가져오기
        DocumentSnapshot docSnapshot = await _pickABookCollection.doc(documentId).get();

        if (docSnapshot.exists) {
          Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

          // 웹툰 리스트 감소
          List<dynamic> webtoonsDynamicList = data?['webtoons'] ?? [];
          List<String> webtoons = webtoonsDynamicList.map((e) => e.toString()).toList();

          for (String webtoonId in webtoons) {
            DocumentReference webtoonRef = FirebaseFirestore.instance.collection('webtoonDB').doc(webtoonId);
            DocumentSnapshot webtoonSnapshot = await webtoonRef.get();
            if (webtoonSnapshot.exists) {
              int currentPickedNum = webtoonSnapshot['pickednum'] ?? 0;
              if (currentPickedNum > 0) {
                await webtoonRef.update({
                  'pickednum': currentPickedNum - 1,
                });
              }
            }
          }

          // 태그 리스트 감소
          List<dynamic> tagsDynamicList = data?['tags'] ?? [];
          List<String> tags = tagsDynamicList.map((e) => e.toString()).toList();

          for (String tagId in tags) {
            DocumentReference tagRef = FirebaseFirestore.instance.collection('tagDB').doc(tagId);
            DocumentSnapshot tagSnapshot = await tagRef.get();
            if (tagSnapshot.exists) {
              int currentPickedNum = tagSnapshot['pickednum'] ?? 0;
              if (currentPickedNum > 0) {
                await tagRef.update({
                  'pickednum': currentPickedNum - 1,
                });
              }
            }
          }
        }

        // 픽카북 문서 삭제
        await _pickABookCollection.doc(documentId).delete();
        print('픽카북 삭제됨: $documentId');

        // 삭제 후 새로고침
        setState(() {});

      } catch (e) {
        print('Error deleting pickABook: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('픽카북 삭제 중 오류가 발생했습니다.')),
        );
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
        stream: _pickABookCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는데 오류가 발생했습니다.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
            itemCount: pickaBooks.length + 1,
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
                      child: Icon(Icons.add, size: 40, color: Colors.black),
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
                /*onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickABookWebtoonPage(
                        webtoon: Webtoon(
                          title: pickABook.title,
                          coverImageUrl: 'assets/icons/Rectangle_grey.png',
                        ),
                      ),
                    ),
                  );
                },*/
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickABookWebtoonPage(
                        pickABookId: documentId, // PickABook 문서 ID를 전달
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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