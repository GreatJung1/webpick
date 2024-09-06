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
  String _selectedGenre = '장르1'; // 초기 선택된 장르
  String _selectedPlatform = '전체'; // 초기 선택된 플랫폼

  String GenreNend = '1'; // 장르 변수
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
                height: 1.5,
                color: Colors.black,
              ),
              Row(
                children: [
                  for (var genre in widget.genres)
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 40,
                        color: _selectedGenre == genre ? Colors.grey.shade200 : Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedGenre = genre;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: _selectedGenre == genre ? Colors.white : Colors.black,
                            backgroundColor: _selectedGenre == genre ? Colors.blue : Colors.transparent,
                          ),
                          child: Text(
                            genre,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                height: 1.5,
                color: Colors.black,
              ),

            ],
          ),
          Row(
            children: [
              for (var platform in widget.platforms)
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPlatform = platform;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _selectedPlatform == platform ? Colors.white : Colors.black,
                        backgroundColor: _selectedPlatform == platform ? Colors.blue : Colors.transparent,
                      ),
                      child: Text(
                        platform,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            height: 1.5,
            color: Colors.black,
          ),
          Row(
            children: [
              // 휴재 제외 버튼
              Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        excludeHiatus = !excludeHiatus; // 휴재 제외 토글
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: excludeHiatus ? Colors.white : Colors.black,
                      backgroundColor: excludeHiatus ? Colors.blue : Colors.transparent,
                    ),
                    child: Text(
                      "휴재 제외",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ),
              // 완결 제외 버튼
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        excludeCompleted = !excludeCompleted; // 완결 제외 토글
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: excludeCompleted ? Colors.white : Colors.black,
                      backgroundColor: excludeCompleted ? Colors.blue : Colors.transparent,
                    ),
                    child: Text(
                      "완결 제외",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ),

              DropdownButton<int>(
                value: selectedNumber,
                items: numberOptions.map((int number) {
                  return DropdownMenuItem<int>(
                    value: number,
                    child: Text(number.toString()),
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
              DropdownButton<bool>(
                value: isitmore,
                items: [
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text('미만'),
                  ),
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text('이상'),
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
            ],
          ),
          Container(
            height: 1.5,
            color: Colors.black,
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
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    String title = doc['title'] ?? '제목 없음';
                    String hiatusNend = doc['hiatusNend'] ?? '1';

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: Material(
                        color: Colors.grey.shade300,
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
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  hiatusNend == '1' ? '연재 작품'
                                      : hiatusNend == '2' ? '휴재 작품'
                                      : hiatusNend == '3' ? '완결 작품'
                                      : '알 수 없음',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
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