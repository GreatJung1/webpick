import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Webtoon {
  final String id;
  final String title;
  final String coverImageUrl;
  bool isSelected;

  Webtoon({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    this.isSelected = false,
  });
}

class PickABookWebtoonPage extends StatefulWidget {
  final String pickABookId; // PickABook 문서 ID

  PickABookWebtoonPage({required this.pickABookId});

  @override
  _PickABookWebtoonPageState createState() => _PickABookWebtoonPageState();
}

class _PickABookWebtoonPageState extends State<PickABookWebtoonPage> {
  final CollectionReference _pickABookCollection =
  FirebaseFirestore.instance.collection('pickabookDB');
  final CollectionReference _webtoonCollection =
  FirebaseFirestore.instance.collection('webtoonDB');

  List<Webtoon> _webtoons = [];
  List<Webtoon> _availableWebtoons = [];
  bool _isLoading = true;
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _fetchWebtoons();
  }

  // Firestore에서 웹툰 데이터 가져오기
  Future<void> _fetchWebtoons() async {
    try {
      DocumentSnapshot pickABookSnapshot =
      await _pickABookCollection.doc(widget.pickABookId).get();

      if (pickABookSnapshot.exists) {
        Map<String, dynamic>? pickABookData =
        pickABookSnapshot.data() as Map<String, dynamic>?;

        List<dynamic> selectedWebtoonIds = pickABookData?['webtoons'] ?? [];

        List<Webtoon> selectedWebtoons = [];
        List<Webtoon> availableWebtoons = [];

        QuerySnapshot webtoonSnapshot = await _webtoonCollection.get();

        for (var doc in webtoonSnapshot.docs) {
          Map<String, dynamic> webtoonData =
          doc.data() as Map<String, dynamic>;
          String webtoonId = doc.id;

          Webtoon webtoon = Webtoon(
            id: webtoonId,
            title: webtoonData['title'] ?? '제목 없음',
            coverImageUrl: webtoonData['image'] ??
                'assets/icons/Rectangle_grey.png', // 기본 이미지니까 여기 변경하면 될듯 소리
          );

          // 선택된 웹툰과 선택되지 않은 웹툰 분리
          if (selectedWebtoonIds.contains(webtoonId)) {
            selectedWebtoons.add(webtoon);
          } else {
            availableWebtoons.add(webtoon);
          }
        }

        setState(() {
          _webtoons = selectedWebtoons;
          _availableWebtoons = availableWebtoons;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('웹툰 데이터를 불러오는 중 오류 발생: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 선택된 웹툰 추가
  void _addWebtoons(List<Webtoon> selectedWebtoons) async {
    setState(() {
      _webtoons.addAll(selectedWebtoons);
      _availableWebtoons.removeWhere(
              (webtoon) => selectedWebtoons.contains(webtoon));
    });

    // Firestore 업데이트
    List<String> updatedWebtoonIds = _webtoons.map((webtoon) => webtoon.id).toList();
    await _pickABookCollection
        .doc(widget.pickABookId)
        .update({'webtoons': updatedWebtoonIds});
  }

  // 웹툰 삭제
  void _deleteSelectedWebtoons() async {
    setState(() {
      _webtoons.removeWhere((webtoon) => webtoon.isSelected);
    });

    // Firestore 업데이트
    List<String> updatedWebtoonIds = _webtoons.map((webtoon) => webtoon.id).toList();
    await _pickABookCollection
        .doc(widget.pickABookId)
        .update({'webtoons': updatedWebtoonIds});
  }

  // 추가 가능한 웹툰 선택 화면
  void _showAvailableWebtoonsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<Webtoon> selectedWebtoons = [];
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('웹툰 추가'),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: _availableWebtoons.length,
                  itemBuilder: (context, index) {
                    final webtoon = _availableWebtoons[index];
                    return CheckboxListTile(
                      title: Text(webtoon.title),
                      value: webtoon.isSelected,
                      onChanged: (isChecked) {
                        setState(() {
                          webtoon.isSelected = isChecked ?? false;
                          if (isChecked == true) {
                            selectedWebtoons.add(webtoon);
                          } else {
                            selectedWebtoons.remove(webtoon);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    _addWebtoons(selectedWebtoons);
                    Navigator.of(context).pop();
                  },
                  child: Text('추가'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('픽카북 웹툰 목록'),
        actions: [
          if (!_isSelectionMode)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showAvailableWebtoonsDialog,
            ),
          if (_isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedWebtoons,
            ),
          IconButton(
            icon: Icon(_isSelectionMode ? Icons.cancel : Icons.select_all),
            onPressed: () {
              setState(() {
                _isSelectionMode = !_isSelectionMode;
                if (!_isSelectionMode) {
                  _webtoons.forEach((webtoon) {
                    webtoon.isSelected = false;
                  });
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _webtoons.isEmpty
          ? Center(child: Text('등록된 웹툰이 없습니다.'))
          : ListView.builder(
        itemCount: _webtoons.length,
        itemBuilder: (context, index) {
          final webtoon = _webtoons[index];
          return ListTile(
            leading: Image.network(
              webtoon.coverImageUrl,
              width: 50,
              height: 75,
              fit: BoxFit.cover,
            ),
            title: Text(webtoon.title),
            onTap: _isSelectionMode
                ? () {
              setState(() {
                webtoon.isSelected = !webtoon.isSelected;
              });
            }
                : null,
            selected: webtoon.isSelected,
          );
        },
      ),
    );
  }
}

