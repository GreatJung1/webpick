import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

class WeekdayWebtoonPage extends StatefulWidget {
  final CollectionReference webtoonCollection;

  WeekdayWebtoonPage({required this.webtoonCollection});

  @override
  _WeekdayWebtoonPageState createState() => _WeekdayWebtoonPageState();
}

class _WeekdayWebtoonPageState extends State<WeekdayWebtoonPage> {
  String _searchWeekday = '월'; // 초기 선택된 요일
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
          height: 1.5,
          color: Colors.black,
        ),
        Row(
          children: [
            for (var weekday in ['월', '화', '수', '목', '금', '토', '일'])
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _searchWeekday = weekday;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: _searchWeekday == weekday ? Colors.white : Colors.black,
                    backgroundColor: _searchWeekday == weekday ? Colors.blue : Colors.transparent,
                  ),
                  child: Text(
                    weekday,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                  ),
                ),
              ),
          ],
        ),
        Container(
          height: 1.5,
          color: Colors.black,
        ),
        // 필터 버튼들
        Row(
          children: [
            _buildFilterButton(
              label: '휴재 제외',
              value: excludeHiatus,
              onChanged: (newValue) {
                setState(() {
                  excludeHiatus = newValue;
                });
              },
            ),
            _buildFilterButton(
              label: '완결 제외',
              value: excludeCompleted,
              onChanged: (newValue) {
                setState(() {
                  excludeCompleted = newValue;
                });
              },
            ),
            SizedBox(width: 16), // 버튼 간의 간격
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
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];
                  String title = doc['title'] ?? '제목 없음';

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
                          title: Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            foregroundColor: value ? Colors.white : Colors.black,
            backgroundColor: value ? Colors.blue : Colors.transparent,
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
