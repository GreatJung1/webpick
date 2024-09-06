import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';

class GenreWebtoonPage extends StatefulWidget {
  final CollectionReference webtoonCollection;
  final List<String> genres;

  GenreWebtoonPage({
    required this.webtoonCollection,
    required this.genres,
  });

  @override
  _GenreWebtoonPageState createState() => _GenreWebtoonPageState();
}

class _GenreWebtoonPageState extends State<GenreWebtoonPage> {
  String _selectedGenre = '전체'; // 초기 선택된 장르
  String _selectedPlatform = '전체'; // 초기 선택된 플랫폼
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  void _fetchTags() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tags').get();
    setState(() {
      _tags = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedGenre = '전체';
      _selectedPlatform = '전체';
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _resetFilters();
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 장르 버튼들
            _buildGenreButtons(),

            // 태그 필터 (가로 스크롤)
            _buildTagFilter(),

            // 웹툰 항목들
            Expanded(
              child: _buildWebtoonGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreButtons() {
    return Column(
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
                      foregroundColor: _selectedGenre == genre ? Colors.white : Colors.black, // 텍스트 색상 변경
                      backgroundColor: _selectedGenre == genre ? Colors.blue : Colors.transparent, // 배경 색상 변경
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
    );
  }


  Widget _buildTagFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tags.map((tag) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilterChip(
              label: Text(tag),
              onSelected: (bool selected) {
                setState(() {
                  _selectedGenre = selected ? tag : '전체';
                });
              },
              selected: _selectedGenre == tag,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWebtoonGrid() {
    return StreamBuilder<QuerySnapshot>(
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
          final genre = doc['genre']?.toString().toLowerCase() ?? '';
          final platform = doc['platform']?.toString().toLowerCase() ?? '';

          return (_selectedGenre == '전체' || genre.contains(_selectedGenre.toLowerCase())) &&
              (_selectedPlatform == '전체' || platform == _selectedPlatform.toLowerCase());
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
                        builder: (context) => IndividualWebtoonDetailPage(webtoonId: doc.id),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
