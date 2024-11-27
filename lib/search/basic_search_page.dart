import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './view_webtoon_detail.dart';
import './view_pickabook_detail.dart';
import './search_class_manager.dart';
import './search.dart';
import './general_search_page.dart';

// BasicSearchBodyWidget 정의
class BasicSearchBodyWidget extends StatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final CollectionReference webtoonCollection;
  final CollectionReference pickabookCollection;
  final void Function(String) onSearchChange;
  final Future<void> Function(String) addSearchTerm; // 콜백 함수 타입
  List<String> searchHistory;

  BasicSearchBodyWidget({
    required this.searchController,
    required this.searchQuery,
    required this.webtoonCollection,
    required this.pickabookCollection,
    required this.onSearchChange,
    required this.addSearchTerm,
    required this.searchHistory,
  });


  @override
  _BasicSearchBodyWidgetState createState() => _BasicSearchBodyWidgetState();
}

// SearchBodyWidget의 상태를 관리하는 클래스
class _BasicSearchBodyWidgetState extends State<BasicSearchBodyWidget> {

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
                        await widget.addSearchTerm(searchTerm);  // 비동기적으로 _addSearchTerm 호출
                        widget.onSearchChange(searchTerm);
                        widget.searchController.clear();  // 검색어 초기화

                        // SearchBodyWidget을 새로운 페이지로 푸시
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchBodyWidget(
                              searchController: widget.searchController,
                              searchQuery: searchTerm,
                              webtoonCollection: widget.webtoonCollection,
                              pickabookCollection: widget.pickabookCollection,
                              onSearchChange: widget.onSearchChange,
                            ),
                          ),
                        );
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
          //width: double.infinity,  // 화면 가득 차게 하기
          //height: double.infinity, // 화면 가득 차게 하기
          padding: const EdgeInsets.only(left: 15.0, top: 0.0, right: 10.0, bottom: 0.0),
          child: widget.searchHistory.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true, // 높이를 ListView의 내용에 맞게 설정
            itemCount: widget.searchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,  // 왼쪽 정렬
                  children: [
                    // 텍스트와 이미지가 위아래로 배치되는 부분
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 양쪽 끝 정렬
                      children: [
                        Text(
                          widget.searchHistory[index],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        Image.asset(
                          'assets/icons/Group 60.png',
                          width: 12.0,
                          height: 12.0,
                        ),
                      ],
                    ),
                  ],
                )
              );
            },
          )
              : Align(
            alignment: Alignment.center,  // 화면의 정중앙에 배치
            child: const Text(
              'webpick',
              style: TextStyle(
                fontFamily: 'Salad',
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }
}
