import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import './genre_webtoon_page.dart';
import './weekday_webtoon_page.dart';

class Collection extends StatefulWidget {
  const Collection({Key? key}) : super(key: key);

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  final CollectionReference webtoonCollection = FirebaseFirestore.instance.collection("webtoonDB");
  bool _isTagSearch = false;
  final List<String> platforms = ['네이버', '전체', '카카오'];
  final List<String> genres = ['학원', '판타지', '일상', '로맨스', '개그','액션','드라마','공포','스릴러','무협','미스터리/추리','로맨스 판타지','성인']; // 예시 장르 목록

  void _toggleSearchMode(bool isTagSearch) {
    setState(() {
      _isTagSearch = isTagSearch;
    });
  }

  Future<void> _refresh() async {
    setState(() {
    });
    await Future.delayed(Duration(seconds: 1)); // 테스트용
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        flexibleSpace: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _toggleSearchMode(false); // 일반 검색 모드로 전환
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 둥근 모서리 설정
                      ),
                      side: BorderSide(
                        color: _isTagSearch ? Colors.grey : Color(0xFF76ABAE), // 선택 상태에 따라 테두리 색상 변경
                      ),
                    ),
                    child: Text(
                      '장르',
                      style: TextStyle(
                        fontSize: 16.0, // 텍스트 크기 설정
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        color: _isTagSearch ? Colors.grey : Color(0xFF76ABAE), // 선택 상태에 따라 텍스트 색상 변경
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _toggleSearchMode(true); // 태그 검색 모드로 전환
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 둥근 모서리 설정
                      ),
                      side: BorderSide(
                        color: _isTagSearch ? Color(0xFF76ABAE) : Colors.grey, // 선택 상태에 따라 테두리 색상 변경
                      ),
                    ),
                    child: Text(
                      '요일',
                      style: TextStyle(
                        fontSize: 16.0, // 텍스트 크기 설정
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        color: _isTagSearch ? Color(0xFF76ABAE) : Colors.grey, // 선택 상태에 따라 텍스트 색상 변경
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _isTagSearch
            ? WeekdayWebtoonPage(webtoonCollection : webtoonCollection,)
            : GenreWebtoonPage(
            genres : genres,
            platforms : platforms,
          webtoonCollection: webtoonCollection),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Collection(),
  ));
}
