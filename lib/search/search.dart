import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './tag_search_page.dart';
import './general_search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 목표사항 : 새로 고침할때 초기 화면이 되도록 변경

class SearchBarPage extends StatefulWidget {
  const SearchBarPage({Key? key}) : super(key: key);

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  final CollectionReference webtoonCollection = FirebaseFirestore.instance.collection("webtoonDB");
  final CollectionReference webtoonTagCollection = FirebaseFirestore.instance.collection("webtoon_tagDB");
  final TextEditingController _searchController = TextEditingController();
  final List<String> genres = ['학원', '판타지', '일상', '로맨스', '개그','액션','드라마','공포','스릴러','무협','미스터리/추리','로맨스 판타지','성인',//13
    '현대물','서양풍','동양풍',//16
    '검정 머리','보라 머리','천재','사이다',//20
    '2등신','5등신','8등신','실사','반실사',//25
    '네이버','카카오','연재','휴재','완결','20화 이하','20~50화','50~100화','100~250화','250화 이상'];
  List<String> _searchHistory = [];

  String _searchQuery = '';
  bool _isTagSearch = false;

  void onSearchChange(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _toggleSearchMode(bool isTagSearch) {
    setState(() {
      _isTagSearch = isTagSearch;
    });
  }

  Future<void> _refresh() async {

    setState(() {
      _searchQuery = '';
    });
    await Future.delayed(Duration(seconds: 1)); // 테스트를 위해 1초 동안 대기
  }

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();  // 앱 시작 시 검색 기록 불러오기
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];  // 저장된 검색 기록 불러오기
    });
  }

  Future<void> _addSearchTerm(String term) async {
    if (term.isNotEmpty && !_searchHistory.contains(term)) {
      setState(() {
        _searchHistory.add(term);  // 검색어를 리스트에 추가
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('searchHistory', _searchHistory);  // 검색 기록 저장
    }
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');  // 검색 기록 삭제
    setState(() {
      _searchHistory.clear();  // 검색 기록 리스트 초기화
    });
  }

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
                      print("일반 검색 버튼 클릭됨");
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
                      '일반 검색',
                      style: TextStyle(
                        fontSize: 16.0, // 텍스트 크기 설정
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        color: _isTagSearch ? Colors.grey : Color(0xFF76ABAE), // 선택 상태에 따라 색상 변경
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      print("태그 검색 버튼 클릭됨");
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
                      '태그 검색',
                      style: TextStyle(
                        fontSize: 16.0, // 텍스트 크기 설정
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        color: _isTagSearch ? Color(0xFF76ABAE) : Colors.grey, // 선택 상태에 따라 색상 변경
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
            ? GenreWebtoonPage(webtoonCollection : webtoonCollection,
            genres : genres)
            : SearchBodyWidget(
          searchController: _searchController,
          searchQuery: _searchQuery,
          webtoonCollection: webtoonCollection,
          onSearchChange: onSearchChange,
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SearchBarPage(),
  ));
}
