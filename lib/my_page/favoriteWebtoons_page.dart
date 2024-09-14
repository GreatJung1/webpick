import 'package:flutter/material.dart';

class FavoriteWebtoonsPage extends StatefulWidget {
  @override
  _FavoriteWebtoonsPageState createState() => _FavoriteWebtoonsPageState();
}

class _FavoriteWebtoonsPageState extends State<FavoriteWebtoonsPage> {
  List<bool> isLiked = [false, false, false, false];  // 좋아요 상태 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내가 좋아요 한 웹툰',
      style: TextStyle(
    fontFamily: 'Pretendard-Light',
      ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // 한 줄에 두 개씩 표시
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: isLiked.length,  // 웹툰 개수
          itemBuilder: (context, index) {
            return Stack(
              children: [
                // 이미지 추가
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],  // 이미지가 없는 경우 대체 색상
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/webtoon_$index.png',  // 웹툰 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
                // 하트 아이콘
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked[index] = !isLiked[index];  // 좋아요 상태 변경
                      });
                    },
                    child: Icon(
                      isLiked[index] ? Icons.favorite : Icons.favorite_border,
                      color: isLiked[index] ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}