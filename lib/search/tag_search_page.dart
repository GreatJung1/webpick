import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

class GenreWebtoonPage extends StatefulWidget {
  final CollectionReference webtoonCollection;
  final List<String> genres;

  GenreWebtoonPage({
    required this.webtoonCollection,
    required this.genres,
  });

  @override
  _GenreWebtoonPageState createState() => _GenreWebtoonPageState();
}

class _GenreWebtoonPageState extends State<GenreWebtoonPage> {
  String _selectedGenre = '전체'; // 초기 선택된 장르
  String _selectedPlatform = '전체'; // 초기 선택된 플랫폼
  List<String> _tags = [];
  bool isitmore = false; //false는 웹툰 true는 피카북
  String _imagePath = 'assets/icons/like.png';

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  void _fetchTags() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tags').get();
    setState(() {
      _tags = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedGenre = '전체';
      _selectedPlatform = '전체';
    });
  }

  void _changeImage() {
    setState(() {
      // 클릭 시 이미지 경로를 변경
      if (_imagePath == 'assets/icons/like.png') {
        _imagePath =  'assets/icons/fillheart.png'; // 클릭 후 변경될 이미지 경로
      } else {
        _imagePath = 'assets/icons/like.png'; // 클릭 후 원래 이미지로 되돌리기
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _resetFilters();
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 장르 버튼들
            _buildGenreButtons(),

            // 태그 필터 (가로 스크롤)
            _buildTagFilter(),

            // 웹툰 항목들
            Expanded(
              child: _buildWebtoonGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreButtons() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Color(0xFF222831),
        ),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Column 내의 요소들을 왼쪽으로 정렬
                children: [
                Row(
                  children: [
                    Container(
                      color: Colors.grey.shade200, // 배경색 설정
                      width: 160,
                      height: 40,
                      alignment: Alignment.center, // 상하 좌우 중앙 정렬
                      child: Text(
                        '장르',
                        style: TextStyle(
                          color: Color(0xFF222831), // 텍스트 색상 설정
                          fontFamily: 'Pretendard', // 폰트 패밀리 설정
                          fontWeight: FontWeight.w700, // 폰트 굵기 설정
                          fontSize: 16.0, // 폰트 크기 설정
                        ),
                      ),
                    ),
                    for (var genre in widget.genres.take(13))
                      Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 4.0), // 좌우 마진
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedGenre = genre;
                            });
                          },
                          style: TextButton.styleFrom(
                            //backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
                            foregroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.grey, // 텍스트 색상 변경

                          ),
                          child: Text(
                            genre,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                  Container(
                    height: 0.5,
                    //width: double.infinity,
                    color: Colors.grey,
                  ),
                Row(
                  children: [
                    Container(
                      color: Colors.grey.shade200, // 배경색 설정
                      width: 160,
                      height: 40,
                      alignment: Alignment.center, // 상하 좌우 중앙 정렬
                      child: Text(
                        '소재/배경',
                        style: TextStyle(
                          color: Color(0xFF222831), // 텍스트 색상 설정
                          fontFamily: 'Pretendard', // 폰트 패밀리 설정
                          fontWeight: FontWeight.w700, // 폰트 굵기 설정
                          fontSize: 16.0, // 폰트 크기 설정
                        ),
                      ),
                    ),
                    for (var genre in widget.genres.sublist(13, 16))
                      Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 4.0), // 좌우 마진
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedGenre = genre;
                            });
                          },
                          style: TextButton.styleFrom(
                            //backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
                            foregroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.grey, // 텍스트 색상 변경

                          ),
                          child: Text(
                            genre,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                  Container(
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade200, // 배경색 설정
                        width: 160,
                        height: 40,
                        alignment: Alignment.center, // 상하 좌우 중앙 정렬
                        child: Text(
                          '주인공',
                          style: TextStyle(
                            color: Color(0xFF222831), // 텍스트 색상 설정
                            fontFamily: 'Pretendard', // 폰트 패밀리 설정
                            fontWeight: FontWeight.w700, // 폰트 굵기 설정
                            fontSize: 16.0, // 폰트 크기 설정
                          ),
                        ),
                      ),
                      for (var genre in widget.genres.sublist(16, 20))
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4.0), // 좌우 마진
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedGenre = genre;
                              });
                            },
                            style: TextButton.styleFrom(
                              //backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
                              foregroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.grey, // 텍스트 색상 변경

                            ),
                            child: Text(
                              genre,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade200, // 배경색 설정
                        width: 160,
                        height: 40,
                        alignment: Alignment.center, // 상하 좌우 중앙 정렬
                        child: Text(
                          '작화',
                          style: TextStyle(
                            color: Color(0xFF222831), // 텍스트 색상 설정
                            fontFamily: 'Pretendard', // 폰트 패밀리 설정
                            fontWeight: FontWeight.w700, // 폰트 굵기 설정
                            fontSize: 16.0, // 폰트 크기 설정
                          ),
                        ),
                      ),
                      for (var genre in widget.genres.sublist(20, 25))
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4.0), // 좌우 마진
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedGenre = genre;
                              });
                            },
                            style: TextButton.styleFrom(
                              //backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
                              foregroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.grey, // 텍스트 색상 변경

                            ),
                            child: Text(
                              genre,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade200, // 배경색 설정
                        width: 160,
                        height: 40,
                        alignment: Alignment.center, // 상하 좌우 중앙 정렬
                        child: Text(
                          '기타',
                          style: TextStyle(
                            color: Color(0xFF222831), // 텍스트 색상 설정
                            fontFamily: 'Pretendard', // 폰트 패밀리 설정
                            fontWeight: FontWeight.w700, // 폰트 굵기 설정
                            fontSize: 16.0, // 폰트 크기 설정
                          ),
                        ),
                      ),
                      for (var genre in widget.genres.sublist(25))
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4.0), // 좌우 마진
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedGenre = genre;
                              });
                            },
                            style: TextButton.styleFrom(
                              //backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
                              foregroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.grey, // 텍스트 색상 변경

                            ),
                            child: Text(
                              genre,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  ]
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          color: Color(0xFF222831),
        ),
        SizedBox(height: 4),
        Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백을 20.0으로 설정
                child: Text(
                  'nn개',
                  style: TextStyle(
                    color: Colors.grey.shade400, // 텍스트 색상
                    fontFamily: 'Pretendard', // 폰트 패밀리
                    fontWeight: FontWeight.w500, // 폰트 굵기
                    fontSize: 14.0, // 폰트 크기
                  ),
                ),
              ),
              SizedBox(width: 260),
              DropdownButton<bool>(
                value: isitmore,
                items: [
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text(
                      '웹툰',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.grey
                      ),),
                  ),
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text(
                      '피카북',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.grey
                      ),),
                  ),
                ],
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    setState(() {
                      isitmore = newValue;
                    });
                  }
                },
              ),
            ]
        )
      ],
    );
  }


  Widget _buildTagFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tags.map((tag) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilterChip(
              label: Text(tag),
              onSelected: (bool selected) {

                setState(() {
                  _selectedGenre = selected ? tag : '전체';
                });
              },
              selected: _selectedGenre == tag,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWebtoonGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.webtoonCollection.snapshots(),
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

        // 데이터 필터링
        final filteredDocs = streamSnapshot.data!.docs.where((doc) {
          final genre = doc['genre']?.toString().toLowerCase() ?? '';
          final platform = doc['platform']?.toString().toLowerCase() ?? '';

          return (_selectedGenre == '전체' || genre.contains(_selectedGenre.toLowerCase())) &&
              (_selectedPlatform == '전체' || platform == _selectedPlatform.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot documentSnapshot = filteredDocs[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Material(
                color: Colors.white,
                child: Column(
                  children: [
                    // 기존 Row 위젯
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // 상하 중앙 정렬
                      children: [
                        // 사진 부분
                        Stack(
                          children: [
                            Container(
                              width: 80, // 원하는 사진의 너비
                              height: 80, // 원하는 사진의 높이
                              margin: EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
                                image: DecorationImage(
                                  image: AssetImage('assets/icons/Naver_Line_Webtoon_logo.png'),
                                  fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                width: 14, // 아이콘의 너비
                                height: 14, // 아이콘의 높이
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        documentSnapshot['platform']?.toString().toLowerCase() == '카카오'
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
                        // 글 리스트 부분
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
                        InkWell(
                          onTap: _changeImage,
                          child: Container(
                            width: 23, // 첫 번째 이미지의 너비
                            height: 20,
                            margin: EdgeInsets.all(10), // 이미지와 텍스트 간의 간격 조정
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(_imagePath), // 첫 번째 이미지 경로
                                fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                              ),
                            ),
                          ),
                        ),
                        // 두 번째 이미지
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min, // 콘텐츠에 맞게 크기 조정
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '+ 새로 만들기',
                                              style: TextStyle(
                                                  color: Color(0xFF76ABAE),
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center, // 상하 중앙 정렬
                                            children: [
                                              Container(
                                                width: 30, // 박스의 너비
                                                height: 30, // 박스의 높이
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/icons/Group 43.png'), // 이미지 경로
                                                    fit: BoxFit.cover, // 이미지가 박스를 꽉 채우도록 설정
                                                  ),
                                                ),
                                              ),
                                              Text('   내가 좋아요 한 웹툰',
                                                  style: TextStyle(
                                                    color: Color(0xFF222831),
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  )
                                              ),
                                              Spacer(),
                                              Container(
                                                margin: EdgeInsets.only(right: 10.0),
                                                width: 30, // 박스의 너비
                                                height: 30, // 박스의 높이
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/icons/Lock.png'), // 이미지 경로
                                                    //fit: BoxFit.cover, // 이미지가 박스를 꽉 채우도록 설정
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 0.5,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 30, // 박스의 너비
                                                height: 30, // 박스의 높이
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/icons/Group 43.png'), // 이미지 경로
                                                    fit: BoxFit.cover, // 이미지가 박스를 꽉 채우도록 설정
                                                  ),
                                                ),
                                              ),
                                              Text('   내가 좋아요 한 웹툰',
                                                  style: TextStyle(
                                                    color: Color(0xFF222831),
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  )
                                              ),
                                              Spacer(),
                                              Container(
                                                margin: EdgeInsets.only(right: 10.0),
                                                width: 30, // 박스의 너비
                                                height: 30, // 박스의 높이
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/icons/Lock.png'), // 이미지 경로
                                                    //fit: BoxFit.cover, // 이미지가 박스를 꽉 채우도록 설정
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          TextButton(
                                            child: Text('Pick a Book에 추가하기',
                                                style: TextStyle(
                                                  color: Color(0xFF76ABAE),
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                )
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 24, // 첫 번째 이미지의 너비
                            height: 17, // 첫 번째 이미지의 높이
                            margin: EdgeInsets.only(left: 10.0, right: 20.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/box.png'), // 첫 번째 이미지 경로
                                fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 새로운 요소 추가
                    Container(
                      height: 0.5,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
