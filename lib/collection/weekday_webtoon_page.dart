import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';
import './collection_class_manager.dart';

class WeekdayWebtoonPage extends StatefulWidget {
  final CollectionReference webtoonCollection;

  WeekdayWebtoonPage({required this.webtoonCollection});

  @override
  _WeekdayWebtoonPageState createState() => _WeekdayWebtoonPageState();
}

class _WeekdayWebtoonPageState extends State<WeekdayWebtoonPage> {
  String _searchWeekday = '월'; // 초기 선택된 요일
  bool isPressed = false; // 버튼 클릭 상태를 관리하는 변수
  bool excludeHiatus = false; // '휴재 제외' 버튼 상태
  bool excludeCompleted = false; // '완결 제외' 버튼 상태

  int? selectedNumber;
  final List<int> numberOptions = [50, 100, 150, 200];
  bool isitmore = false; //false는 미만 true 이상

  @override
  void initState() {
    super.initState();
    selectedNumber = numberOptions.isNotEmpty ? numberOptions.last : null;
  }
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 요일 버튼들
        Container(
          height: 0.5,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 모든 자식 요소를 균등하게 배치
          children: [
            for (var weekday in ['월', '화', '수', '목', '금', '토', '일','완결'])
              Expanded(
                child: SizedBox(
                  height: 40, // 높이를 40으로 고정
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _searchWeekday = weekday;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: _searchWeekday == weekday ? Colors.white : Color(0xFF222831),
                      backgroundColor: _searchWeekday == weekday ? Color(0xFF76ABAE) : Colors.transparent,
                      minimumSize: Size(double.infinity, 40), // 버튼의 최소 높이 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // 모서리를 직각으로 설정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown, // 텍스트를 컨테이너에 맞게 축소
                      child: Text(
                        weekday,
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
              ),
          ],
        ),
        Container(
          height: 1,
          color: Color(0xFF222831),
        ),
        // 필터 버튼들
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
        SizedBox(
          height: 30,
        ),
        Expanded(
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
                final weekday = doc['weekday']?.toString().toLowerCase() ?? '';
                final hiatusNend = doc['hiatusNend']?.toString() ?? '';
                final episode = doc['episode'] as int?;

                if (excludeHiatus && hiatusNend == '2') {
                  return false; // 휴재인 경우 제외
                }

                if (excludeCompleted && hiatusNend == '3') {
                  return false; // 완결인 경우 제외
                }

                if (isitmore == false && selectedNumber != null && episode != null && selectedNumber! < episode) {
                  return false;
                }
                if (isitmore == true && selectedNumber != null && episode != null && selectedNumber! > episode) {
                  return false;
                }

                return weekday.contains(_searchWeekday.toLowerCase());
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

                  return WebtoonCard(
                    title: title,
                    webtoonId: doc.id,
                    platformImage: doc['platform']?.toString().toLowerCase() == '카카오'
                        ? 'assets/icons/Kakao.png'
                        : 'assets/icons/Naver.png',
                    imageUrl: 'assets/icons/like.png',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Expanded(
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            onChanged(!value);
          },
          style: TextButton.styleFrom(
            foregroundColor: value ? Colors.white : Color(0xFF222831),
            backgroundColor: value ? Color(0xFF76ABAE) : Colors.transparent,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
