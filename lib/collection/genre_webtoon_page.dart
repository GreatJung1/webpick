import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

class GenreWebtoonPage extends StatefulWidget {
  final CollectionReference webtoonCollection;
  final List<String> genres; // 장르 리스트
  final List<String> platforms; // 플랫폼 리스트

  GenreWebtoonPage({
    required this.webtoonCollection,
    required this.genres,
    required this.platforms,
  });

  @override
  _GenreWebtoonPageState createState() => _GenreWebtoonPageState();
}

class _GenreWebtoonPageState extends State<GenreWebtoonPage> {
  String _selectedGenre = '학원'; // 초기 선택된 장르
  String _selectedPlatform = '전체'; // 초기 선택된 플랫폼

  String GenreNend = '1'; // 장르 변수
  bool isPressed = false; // 버튼 클릭 상태를 관리하는 변수
  bool excludeHiatus = false; // '휴재 제외' 버튼 상태
  bool excludeCompleted = false; // '완결 제외' 버튼 상태

  int? selectedNumber;
  final List<int> numberOptions = [50, 100, 150, 200];
  bool isitmore = false; //false는 미만 true 이상


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 장르 버튼들
          Column(
            children: [
              Container(
                height: 1,
                color: Color(0xFF222831),
              ),
              Row(
                children: [
                  for (var genre in widget.genres.take(5))
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 40,
                        color: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.white,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedGenre = genre;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: _selectedGenre == genre ? Colors.white : Color(0xFF222831),
                            backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
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
                    ),
                ],
              ),
              Container(
                height: 0.5,
                color: Colors.grey,
              ),
              Row(
                children: [
                  for (var genre in widget.genres.sublist(5, 10))
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 40,
                        color: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.white,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedGenre = genre;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: _selectedGenre == genre ? Colors.white : Color(0xFF222831),
                            backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
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
                    ),
                ],
              ),
              Container(
                height: 0.5,
                color: Colors.grey,
              ),
              Row(
                children: [
                  for (var genre in widget.genres.sublist(10, 13))
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 40,
                        color: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.white,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedGenre = genre;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: _selectedGenre == genre ? Colors.white : Color(0xFF222831),
                            backgroundColor: _selectedGenre == genre ? Color(0xFF76ABAE) : Colors.transparent,
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
                    ),
                ],
              ),
              Container(
                height: 1,
                color: Color(0xFF222831),
              ),
            ],

          ),
          Row(
            children: [
              for (var platform in widget.platforms)
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 70,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPlatform = platform;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _selectedPlatform == platform ? Colors.white : Colors.grey,
                        backgroundColor: _selectedPlatform == platform ? Color(0xFF76ABAE) : Colors.transparent,
                      ),
                      child: Text(
                        platform,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            height: 1,
            color: Color(0xFF222831),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPressed = !isPressed; // 클릭 상태를 토글
                    });
                    print('Circle button pressed');
                  },
                child: Container(
                  width: 16.0, // 버튼의 너비
                  height: 16.0, // 버튼의 높이
                  decoration: BoxDecoration(
                  shape: BoxShape.circle, // 원형 모양으로 설정
                  color: Colors.transparent, // 배경색을 투명으로 설정
                  border: Border.all( // 테두리 설정
                    color: Colors.grey, // 테두리 색상
                  width: 0.5, // 테두리 두께
                ),
              ),
              child: Stack(
                alignment: Alignment.center, // Stack 안의 아이템을 가운데 정렬
                children: [
                  if (isPressed) // 클릭 상태일 때만 작은 원을 추가
                    Container(
                      width: 8.0, // 작은 원의 너비
                      height: 8.0, // 작은 원의 높이
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // 원형 모양으로 설정
                        color: Colors.grey, // 작은 원의 색상
                      ),
                    ),
                  ],
                ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10), // 오른쪽에 여백 추가
                child: DropdownButton<int>(
                  value: selectedNumber,
                  items: numberOptions.map((int number) {
                    return DropdownMenuItem<int>(
                      value: number,
                      child: Text(number.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.grey
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedNumber = newValue;
                      });
                    }
                  },
                ),
              ),
              DropdownButton<bool>(
                value: isitmore,
                items: [
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text(
                      '미만',
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
                      '이상',
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
              // 휴재 제외 버튼
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      excludeHiatus = !excludeHiatus; // 휴재 제외 토글
                    });
                    print('Circle button pressed');
                  },
                  child: Container(
                    width: 16.0, // 버튼의 너비
                    height: 16.0, // 버튼의 높이
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 원형 모양으로 설정
                      color: Colors.transparent, // 배경색을 투명으로 설정
                      border: Border.all( // 테두리 설정
                        color: Colors.grey, // 테두리 색상
                        width: 0.5, // 테두리 두께
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center, // Stack 안의 아이템을 가운데 정렬
                      children: [
                        if (excludeHiatus) // 클릭 상태일 때만 작은 원을 추가
                          Container(
                            width: 8.0, // 작은 원의 너비
                            height: 8.0, // 작은 원의 높이
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // 원형 모양으로 설정
                              color: Colors.grey, // 작은 원의 색상
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.only(left: 6.0),
                alignment: Alignment.center,
                  child: Text(
                    "휴재 제외",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.grey
                    ),
                  ),
                ),
              // 완결 제외 버튼
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      excludeCompleted = !excludeCompleted; // 완결 제외 토글
                    });
                    print('Circle button pressed');
                  },
                  child: Container(
                    width: 16.0, // 버튼의 너비
                    height: 16.0, // 버튼의 높이
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 원형 모양으로 설정
                      color: Colors.transparent, // 배경색을 투명으로 설정
                      border: Border.all( // 테두리 설정
                        color: Colors.grey, // 테두리 색상
                        width: 0.5, // 테두리 두께
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center, // Stack 안의 아이템을 가운데 정렬
                      children: [
                        if (excludeCompleted) // 클릭 상태일 때만 작은 원을 추가
                          Container(
                            width: 8.0, // 작은 원의 너비
                            height: 8.0, // 작은 원의 높이
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // 원형 모양으로 설정
                              color: Colors.grey, // 작은 원의 색상
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.only(right: 20.0, left: 6.0),
                alignment: Alignment.center,
                  child: Text(
                    "완결 제외",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.grey
                    ),
                  ),
                ),
            ],
          ),

          // 웹툰 항목들
          Container(
            height: MediaQuery.of(context).size.height * 0.36,
            child: StreamBuilder<QuerySnapshot>(
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
                  final genre = doc['genre']?.toString().toLowerCase() ?? ''; // 장르 필드
                  final platform = doc['platform']?.toString().toLowerCase() ?? ''; // 플랫폼 필드
                  final hiatusNend = doc['hiatusNend']?.toString() ?? '';
                  final episode = doc['episode'] as int?;

                  // 휴재 제외 필터링
                  if (excludeHiatus && hiatusNend == '2') {
                    return false; // 휴재인 경우 제외
                  }

                  // 완결 제외 필터링
                  if (excludeCompleted && hiatusNend == '3') {
                    return false; // 완결인 경우 제외
                  }

                  if (isitmore == false && selectedNumber != null && episode != null && selectedNumber! < episode) {
                    return false;
                  }
                  if (isitmore == true && selectedNumber != null && episode != null && selectedNumber! > episode) {
                    return false;
                  }

                  return genre.contains(_selectedGenre.toLowerCase()) &&
                      (platform == _selectedPlatform.toLowerCase() || _selectedPlatform.toLowerCase() == '전체');
                }).toList();

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    String title = doc['title'] ?? '제목 없음';

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualWebtoonDetailPage(
                                webtoonId: doc.id,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 120,  // 직접 크기 지정
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/icons/Naver_Line_Webtoon_logo.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    width: 16, // 아이콘의 너비
                                    height: 16, // 아이콘의 높이
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: doc['platform']?.toString().toLowerCase() == '카카오'
                                            ? AssetImage('assets/icons/Kakao.png')
                                            : AssetImage('assets/icons/Naver.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8), // 이미지와 제목 간의 간격
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18.0, // 텍스트 크기 설정
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF222831),
                                ),
                                overflow: TextOverflow.ellipsis, // 줄임표 설정
                                maxLines: 1, // 최대 줄 수 설정
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}