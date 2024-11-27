import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './view_webtoon_detail.dart';
import './view_pickabook_detail.dart';
import './search_class_manager.dart';

// SearchBodyWidget 정의
class SearchBodyWidget extends StatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final CollectionReference webtoonCollection;
  final CollectionReference pickabookCollection;
  final void Function(String) onSearchChange;

  SearchBodyWidget({
    required this.searchController,
    required this.searchQuery,
    required this.webtoonCollection,
    required this.pickabookCollection,
    required this.onSearchChange,
  });

  @override
  _SearchBodyWidgetState createState() => _SearchBodyWidgetState();
}

// SearchBodyWidget의 상태를 관리하는 클래스
class _SearchBodyWidgetState extends State<SearchBodyWidget> {
  List<String> _imagePath_w = []; // 첫 번째 리스트
  List<String> _imagePath_p = [];  // 두 번째 리스트

  final firebaseStorage = FirebaseStorage.instance;
  List<String> _imageUrls = [];

  bool _isLoading= false;

  List<String> get imageUrls => _imageUrls;
  bool get isLoaing => _isLoading;



  void _changeImage_w(int index) {
    setState(() {
      if (index >= 0 && index < _imagePath_w.length) {
        if (_imagePath_w[index] == 'assets/icons/like.png') {
          _imagePath_w[index] = 'assets/icons/Component 3.png'; // 클릭 후 변경될 이미지 경로
        } else {
          _imagePath_w[index] = 'assets/icons/like.png'; // 클릭 후 원래 이미지로 되돌리기
        }
      } else {
        print('Index out of range');
      }
    });
  }

  void _changeImage_p(int index) {
    setState(() {
      if (index >= 0 && index < _imagePath_p.length) {
        if (_imagePath_p[index] == 'assets/icons/like.png') {
          _imagePath_p[index] = 'assets/icons/Component 3.png'; // 클릭 후 변경될 이미지 경로
        } else {
          _imagePath_p[index] = 'assets/icons/like.png'; // 클릭 후 원래 이미지로 되돌리기
        }
      } else {
        print('Index out of range');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 0.5,
          color: Colors.grey,
        ),
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 6.0),
          child: TextField(
            controller: widget.searchController,
            onChanged: widget.onSearchChange,
            decoration: InputDecoration(
              hintText: '제목, 작가 이름 검색',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'Pretendard',
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                child: IconButton(
                    icon: Image.asset(
                      'assets/icons/Search.png',
                      width: 40.0,
                      height: 40.0,
                    ),
                    onPressed: () async {
                      String searchTerm = widget.searchController.text;

                      if (searchTerm.isNotEmpty) {
                        //await _addSearchTerm(searchTerm);  // 비동기적으로 _addSearchTerm 호출
                        widget.onSearchChange(searchTerm);
                        widget.searchController.clear();  // 검색어 초기화
                      }
                    }
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: IconButton(
                  icon: Image.asset(
                    'assets/icons/Dell_duotone.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  onPressed: () {
                    widget.searchController.clear();
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 1.0,
          width: double.infinity,
          color: Color(0xFF222831),
        ),

        //웹툰
        Container(
          padding: EdgeInsets.only(left: 15.0, top: 0.0, right: 10.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: widget.webtoonCollection.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                      final title = doc['title'].toString().toLowerCase();
                      final writer = doc['writer'].toString().toLowerCase();
                      return title.contains(widget.searchQuery.toLowerCase()) ||
                          writer.contains(widget.searchQuery.toLowerCase());
                    }).toList();

                    while (_imagePath_w.length <= filteredDocs.length) {
                      _imagePath_w.add('assets/icons/like.png');
                    }

                    return Text(
                      '웹툰 (${filteredDocs.length})',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14.0,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  } else if (streamSnapshot.hasError) {
                    return Text(
                      '웹툰 (0)',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.0,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text(
                      '웹툰 (0)',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.0,
                        color: Colors.grey.shade200,
                      ),
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewWebtoonDetailPage(searchQuery: widget.searchQuery),
                    ),
                  );
                },
                child: Text(
                  '더보기 >',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.36,
          child: StreamBuilder<QuerySnapshot>(
            stream: widget.webtoonCollection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {

                final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                  final title = doc['title'].toString().toLowerCase();
                  final writer = doc['writer'].toString().toLowerCase();
                  return title.contains(widget.searchQuery.toLowerCase()) ||
                      writer.contains(widget.searchQuery.toLowerCase());
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'webpick',
                          style: TextStyle(
                            fontFamily: 'Salad',
                            fontSize: 20.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredDocs.length > 3 ? 3 : filteredDocs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = filteredDocs[index];
                    final imagePath = documentSnapshot['image']; // Firebase Storage URL
                    print(imagePath);

                    return WebtoonItem(
                      webtoonId: documentSnapshot.id,
                      documentSnapshot: documentSnapshot,
                      onImageTap: () => _changeImage_w(index),
                      imagePath: imagePath,  // 이미지를 전달
                    );
                  },
                  physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
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
          height: 0.5,
          width: double.infinity,
          color: Colors.grey.shade600,
        ),

        SizedBox(
          height: 2,
        ),
        //픽카북
        Container(
          padding: EdgeInsets.only(left: 15.0, top: 0.0, right: 10.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: widget.pickabookCollection.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                      final title = doc['title'].toString().toLowerCase();

                      final searchQuery = widget.searchQuery.toLowerCase();

                      // title 또는 배열 'tag' 중 하나라도 검색어를 포함하는지 확인
                      return title.contains(searchQuery);
                    }).toList();

                    while (_imagePath_p.length <= filteredDocs.length) {
                      _imagePath_p.add('assets/icons/like.png');
                    }

                    return Text(
                      '피카북 (${filteredDocs.length})',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14.0,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  } else if (streamSnapshot.hasError) {
                    return Text(
                      '피카북 (0)',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.0,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text(
                      '피카북 (0)',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.0,
                        color: Colors.grey.shade200,
                      ),
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPickabookDetailPage(searchQuery: widget.searchQuery),
                    ),
                  );
                },
                child: Text(
                  '더보기 >',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: widget.pickabookCollection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                  final title = doc['title'].toString().toLowerCase();
                  final searchQuery = widget.searchQuery.toLowerCase();

                  // title 또는 배열 'tag' 중 하나라도 검색어를 포함하는지 확인
                  return title.contains(searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'webpick',
                          style: TextStyle(
                            fontFamily: 'Salad',
                            fontSize: 20.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredDocs.length > 3 ? 3 : filteredDocs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = filteredDocs[index];
                    return PickaBookItem(
                      documentSnapshot: documentSnapshot,
                      onImageTap: () => _changeImage_p(index), // 익명 함수를 사용하여 함수 참조 전달
                      imagePath: _imagePath_p[index],
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
    );
  }
}
