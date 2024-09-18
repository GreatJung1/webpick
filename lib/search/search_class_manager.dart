import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../individual_webtoon_detail/individual_webtoon_detail_page.dart';



//태그 한 줄
class GenreSelectionButton extends StatefulWidget {
  final String genre;
  final Function(String) onGenreSelected;
  final bool isSelected;
  final bool isMaxSelection;

  const GenreSelectionButton({
    Key? key,
    required this.genre,
    required this.onGenreSelected,
    required this.isSelected,
    required this.isMaxSelection,
  }) : super(key: key);

  @override
  _GenreSelectionButtonState createState() => _GenreSelectionButtonState();
}
class _GenreSelectionButtonState extends State<GenreSelectionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 4.0), // 좌우 마진
      child: TextButton(
        onPressed: () {
          if (widget.isSelected) {
            widget.onGenreSelected(widget.genre); // 이미 선택된 경우 제거
          } else if (!widget.isMaxSelection) {
            widget.onGenreSelected(widget.genre); // 선택되지 않은 경우 추가
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 둥글기 정도 조절
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min, // Column의 높이를 내용에 맞게 조절
                    children: [
                      Image.asset(
                        'assets/icons/Group 55.png', // 이미지 경로
                        height: 50, // 이미지의 높이
                        width: 50, // 이미지의 너비
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 30), // 이미지와 텍스트 사이의 간격
                      Text(
                        '피카북 검색시 태그는\n최대 3개까지 선택할 수 있습니다.',
                        style: TextStyle(
                          color: Color(0xFF222831), // 텍스트 색상 설정
                          fontFamily: 'Pretendard', // 폰트 패밀리 설정
                          fontWeight: FontWeight.w500, // 폰트 굵기 설정
                          fontSize: 18.0, // 폰트 크기 설정
                        ),
                        textAlign: TextAlign.center, // 텍스트 가운데 정렬
                      ),
                    ],
                  ),
                  actions: [
                    // 버튼을 포함한 Row 위젯 사용
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 버튼을 중앙에 정렬
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                          child: Text(
                            '확인',
                            style: TextStyle(
                              color: Color(0xFF76ABAE), // 텍스트 색상 설정
                              fontFamily: 'Pretendard', // 폰트 패밀리 설정
                              fontWeight: FontWeight.w500, // 폰트 굵기 설정
                              fontSize: 16.0, // 폰트 크기 설정
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: widget.isSelected ? Color(0xFF76ABAE) : Colors.grey,
        ),
        child: Text(
          widget.genre,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}



// 픽카북 만들기 팝업창
class PickaBookMakeWidget extends StatefulWidget {
  @override
  _PickaBookMakeWidgetState createState() => _PickaBookMakeWidgetState();
}

class _PickaBookMakeWidgetState extends State<PickaBookMakeWidget> {
  bool _isToggled1 = false; // 첫 번째 아이콘의 상태
  bool _isToggled2 = false; // 두 번째 아이콘의 상태

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 콘텐츠에 맞게 크기 조정
        children: <Widget>[
          Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '+ 새로 만들기',
                  style: TextStyle(
                    color: Color(0xFF76ABAE),
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildRow(
                context,
                '   내가 좋아요 한 웹툰',
                _isToggled1 ? 'assets/icons/Component 2.png' : 'assets/icons/Group 43.png',
                'assets/icons/Lock.png',
                    () {
                  setState(() {
                    _isToggled1 = !_isToggled1; // 클릭 시 상태 반전
                  });
                },
              ),
              SizedBox(height: 10),
              Container(
                height: 0.5,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              _buildRow(
                context,
                '   내가 좋아요 한 웹툰',
                _isToggled2 ? 'assets/icons/Component 2.png' : 'assets/icons/Group 43.png',
                'assets/icons/Lock.png',
                    () {
                  setState(() {
                    _isToggled2 = !_isToggled2; // 클릭 시 상태 반전
                  });
                },
              ),
              SizedBox(height: 12),
              TextButton(
                child: Text(
                  'Pick a Book에 추가하기',
                  style: TextStyle(
                    color: Color(0xFF76ABAE),
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String text, String iconPath1, String iconPath2, VoidCallback onTap) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 상하 중앙 정렬
      children: [
        GestureDetector(
          onTap: onTap, // 아이콘 클릭 시 실행될 함수
          child: Container(
            width: 30, // 박스의 너비
            height: 30, // 박스의 높이
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
              image: DecorationImage(
                image: AssetImage(iconPath1), // 첫 번째 이미지 경로
                fit: BoxFit.cover, // 이미지가 박스를 꽉 채우도록 설정
              ),
            ),
          ),
        ),
        SizedBox(width: 10), // 텍스트와 첫 번째 아이콘 사이의 여백
        Text(
          text,
          style: TextStyle(
            color: Color(0xFF222831),
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.only(right: 10.0),
          width: 30, // 박스의 너비
          height: 30, // 박스의 높이
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
            image: DecorationImage(
              image: AssetImage(iconPath2), // 두 번째 이미지 경로
              fit: BoxFit.cover, // 이미지가 박스를 꽉 채우도록 설정
            ),
          ),
        ),
      ],
    );
  }
}



//검색 결과 웹툰 한 줄
class WebtoonItem extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final Function() onImageTap;
  final imagePath;
  final String webtoonId;

  WebtoonItem({
    required this.documentSnapshot,
    required this.onImageTap,
    required this.imagePath,
    required this.webtoonId,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            // 기존 Row 위젯
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 상하 중앙 정렬
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualWebtoonDetailPage(
                          webtoonId: webtoonId, // webtoonId 전달
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 80, // 원하는 사진의 너비
                        height: 80, // 원하는 사진의 높이
                        margin: EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
                          image: DecorationImage(
                            image: AssetImage('assets/icons/Naver_Line_Webtoon_logo.png'),
                            fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          width: 14, // 아이콘의 너비
                          height: 14, // 아이콘의 높이
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  documentSnapshot['platform']?.toString().toLowerCase() == '카카오'
                                      ? 'assets/icons/Kakao.png'
                                      : 'assets/icons/Naver.png'
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 글 리스트 부분
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          documentSnapshot['title'],
                          style: TextStyle(
                            color: Color(0xFF222831),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${documentSnapshot['writer']}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          documentSnapshot['end']
                              ? '${documentSnapshot['genre']} ${documentSnapshot['episode']}화 완결'
                              : '${documentSnapshot['genre']} ${documentSnapshot['episode']}화 ${documentSnapshot['weekday']}요일',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => onImageTap(), // 함수 참조를 전달
                  child: Container(
                    width: 23, // 첫 번째 이미지의 너비
                    height: 20,
                    margin: EdgeInsets.all(10), // 이미지와 텍스트 간의 간격 조정
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath), // 첫 번째 이미지 경로
                        fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                      ),
                    ),
                  ),
                ),
                // 두 번째 이미지
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return PickaBookMakeWidget();
                      },
                    );
                  },
                  child: Container(
                    width: 24, // 두 번째 이미지의 너비
                    height: 17, // 두 번째 이미지의 높이
                    margin: EdgeInsets.only(left: 10.0, right: 20.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/box.png'), // 첫 번째 이미지 경로
                        fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 새로운 요소 추가
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}



//검색 결과 픽카북 한 줄
class PickaBookItem extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final Function() onImageTap;
  final imagePath;

  PickaBookItem({
    required this.documentSnapshot,
    required this.onImageTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage('assets/icons/Naver_Line_Webtoon_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                documentSnapshot['title'],
                                style: TextStyle(
                                  color: Color(0xFF222831),
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => onImageTap(), // 함수 참조를 전달
                              child: Container(
                                width: 23, // 첫 번째 이미지의 너비
                                height: 20,
                                margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(imagePath),
                                    fit: BoxFit.cover, // 사진이 박스에 맞게 채워지도록 설정
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 22,
                              width: 74,
                              decoration: BoxDecoration(
                                color: Color(0xFF76ABAE),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Center(
                                child: Text(
                                  '# ${documentSnapshot['writer']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 18),
                            Container(
                              height: 22,
                              width: 74,
                              decoration: BoxDecoration(
                                color: Color(0xFF76ABAE),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Center(
                                child: Text(
                                  '# ${documentSnapshot['writer']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 18),
                            Container(
                              height: 22,
                              width: 74,
                              decoration: BoxDecoration(
                                color: Color(0xFF76ABAE),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Center(
                                child: Text(
                                  '# ${documentSnapshot['writer']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
