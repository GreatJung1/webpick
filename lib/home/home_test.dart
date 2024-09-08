import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter search term...',
              ),
              onSubmitted: (term) {
                _addSearchTerm(term);
                _searchController.clear();
              },
            ),
            const SizedBox(height: 20),
            const Text('Search History:'),
            Expanded(
              child: ListView.builder(
                itemCount: _searchHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchHistory[index]),
                    onTap: () {
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _clearSearchHistory,
              child: const Text('Clear Search History'),
            ),
          ],
        ),
      ),
    );
  }
}
