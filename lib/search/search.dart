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
  final TextEditingController _searchController = TextEditingController();
  final List<String> genres = ['장르1', '장르2', '장르3', '장르4', '장르5'];
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
                      print("일반 검색 버튼 클릭됨");
                      _toggleSearchMode(false); // 일반 검색 모드로 전환
                    },
                    child: Text(
                      '일반 검색',
                      style: TextStyle(
                        color: _isTagSearch ? Colors.grey : Colors.black, // 선택 상태에 따라 색상 변경
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print("태그 검색 버튼 클릭됨");
                      _toggleSearchMode(true); // 태그 검색 모드로 전환
                    },
                    child: Text(
                      '태그 검색',
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
            ? GenreWebtoonPage(webtoonCollection : webtoonCollection,
            genres : genres)
            : buildGeneralSearchBody(
          searchController: _searchController,
          searchQuery: _searchQuery,
          webtoonCollection: webtoonCollection,
          onSearchChange: onSearchChange,
          context: context,
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
