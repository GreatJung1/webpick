import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';
import './search_class_manager.dart';

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
  List<String> _selectedGenres = []; // 선택된 장르 목록
  //String _selectedGenre = '전체'; // 초기 선택된 장르
  String _selectedPlatform = '전체'; // 초기 선택된 플랫폼
  List<String> _tags = [];
  bool isitmore = false; //false는 웹툰 true는 피카북
  List<String> _imagePath = [];

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
      _selectedGenres = [];
      //_selectedGenre = '전체';
      _selectedPlatform = '전체';
    });
  }

  void _changeImage(int index) {
    setState(() {
      if (index >= 0 && index < _imagePath.length) {
        if (_imagePath[index] == 'assets/icons/like.png') {
          _imagePath[index] = 'assets/icons/Component 3.png'; // 클릭 후 변경될 이미지 경로
        } else {
          _imagePath[index] = 'assets/icons/like.png'; // 클릭 후 원래 이미지로 되돌리기
        }
      } else {
        print('Index out of range');
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
                            GenreSelectionButton(
                              genre: genre,
                              isSelected: _selectedGenres.contains(genre),
                              isMaxSelection: _selectedGenres.length == 3 && isitmore,
                              onGenreSelected: (selectedGenre) {
                                setState(() {
                                  if (_selectedGenres.contains(selectedGenre)) {
                                    _selectedGenres.remove(selectedGenre);
                                  } else {
                                    _selectedGenres.add(selectedGenre);
                                  }
                                });
                              },
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
                            GenreSelectionButton(
                              genre: genre,
                              isSelected: _selectedGenres.contains(genre),
                              isMaxSelection: _selectedGenres.length == 3 && isitmore,
                              onGenreSelected: (selectedGenre) {
                                setState(() {
                                  if (_selectedGenres.contains(selectedGenre)) {
                                    _selectedGenres.remove(selectedGenre);
                                  } else {
                                    _selectedGenres.add(selectedGenre);
                                  }
                                });
                              },
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
                            GenreSelectionButton(
                              genre: genre,
                              isSelected: _selectedGenres.contains(genre),
                              isMaxSelection: _selectedGenres.length == 3 && isitmore,
                              onGenreSelected: (selectedGenre) {
                                setState(() {
                                  if (_selectedGenres.contains(selectedGenre)) {
                                    _selectedGenres.remove(selectedGenre);
                                  } else {
                                    _selectedGenres.add(selectedGenre);
                                  }
                                });
                              },
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
                            GenreSelectionButton(
                              genre: genre,
                              isSelected: _selectedGenres.contains(genre),
                              isMaxSelection: _selectedGenres.length == 3 && isitmore,
                              onGenreSelected: (selectedGenre) {
                                setState(() {
                                  if (_selectedGenres.contains(selectedGenre)) {
                                    _selectedGenres.remove(selectedGenre);
                                  } else {
                                    _selectedGenres.add(selectedGenre);
                                  }
                                });
                              },
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
                            GenreSelectionButton(
                              genre: genre,
                              isSelected: _selectedGenres.contains(genre),
                              isMaxSelection: _selectedGenres.length == 3 && isitmore,
                              onGenreSelected: (selectedGenre) {
                                setState(() {
                                  if (_selectedGenres.contains(selectedGenre)) {
                                    _selectedGenres.remove(selectedGenre);
                                  } else {
                                    _selectedGenres.add(selectedGenre);
                                  }
                                });
                              },
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
                      _selectedGenres=[];
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
                  if (selected) {
                    if (!_selectedGenres.contains(tag)) {
                      // 선택된 경우 리스트에 추가
                      _selectedGenres.add(tag);
                    }
                  } else {
                    // 선택 해제된 경우 리스트에서 제거
                    _selectedGenres.remove(tag);
                  }
                });
              },
              selected: _selectedGenres.contains(tag), // 리스트에 포함 여부로 선택 상태 확인
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

          return (_selectedGenres.isEmpty || _selectedGenres.contains('전체') ||
              _selectedGenres.any((selectedGenre) => genre.toLowerCase().contains(selectedGenre.toLowerCase()))) &&
              (_selectedPlatform == '전체' || platform == _selectedPlatform.toLowerCase());
        }).toList();

        while (_imagePath.length <= filteredDocs.length) {
          _imagePath.add('assets/icons/like.png');
        }

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot documentSnapshot = filteredDocs[index];
            return WebtoonItem(
              webtoonId: documentSnapshot.id,
              documentSnapshot: documentSnapshot,
              onImageTap: () => _changeImage(index), // 익명 함수를 사용하여 함수 참조 전달
              imagePath: _imagePath[index],
            );
          },
        );
      },
    );
  }
}
