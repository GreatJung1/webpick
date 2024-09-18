import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';



//웹툰 카드 한 장
class WebtoonCard extends StatelessWidget {
  final String title;
  final String webtoonId;
  final String platformImage;
  final String imageUrl;

  WebtoonCard({
    required this.title,
    required this.webtoonId,
    required this.platformImage,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndividualWebtoonDetailPage(
                webtoonId: webtoonId,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 73,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 16, // 아이콘의 너비
                    height: 16, // 아이콘의 높이
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(platformImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // 이미지와 제목 간의 간격
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0, // 텍스트 크기 설정
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222831),
                ),
                overflow: TextOverflow.ellipsis, // 줄임표 설정
                maxLines: 1, // 최대 줄 수 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}