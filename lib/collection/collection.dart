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
  final List<String> genres = ['장르1', '장르2', '장르3', '장르4', '장르5']; // 예시 장르 목록

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 50,
        flexibleSpace: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      _toggleSearchMode(false); // 일반 검색 모드로 전환
                    },
                    child: Text(
                      '장르',
                      style: TextStyle(
                        color: _isTagSearch ? Colors.grey : Colors.black, // 선택 상태에 따라 색상 변경
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _toggleSearchMode(true); // 태그 검색 모드로 전환
                    },
                    child: Text(
                      '요일',
                      style: TextStyle(
                        color: _isTagSearch ? Colors.black : Colors.grey, // 선택 상태에 따라 색상 변경
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
