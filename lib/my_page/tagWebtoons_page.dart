import 'package:flutter/material.dart';

class TagWebtoonsPage extends StatefulWidget {
  @override
  _TagWebtoonsPageState createState() => _TagWebtoonsPageState();
}

class _TagWebtoonsPageState extends State<TagWebtoonsPage> {
  // 임시 데이터 (백엔드 연동 시 이 부분 교체)
  List<Map<String, dynamic>> webtoons = [
    {
      'title': '웹툰 1',
      'tags': ['#로맨스', '#드라마', '#판타지', '#감동'],
      'imageUrl': 'https://via.placeholder.com/70x100.png?text=Webtoon+1',
    },
    {
      'title': '웹툰 2',
      'tags': ['#액션', '#모험', '#코미디'],
      'imageUrl': 'https://via.placeholder.com/70x100.png?text=Webtoon+2',
    },
    {
      'title': '웹툰 3',
      'tags': ['#스릴러', '#미스터리', '#공포'],
      'imageUrl': 'https://via.placeholder.com/70x100.png?text=Webtoon+3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'webpick',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard-Light',
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: webtoons.length,
        itemBuilder: (context, index) {
          var webtoon = webtoons[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        webtoon['imageUrl'],
                        height: 100,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            webtoon['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard-Light',
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: webtoon['tags']
                                .map<Widget>((tag) => Text(
                              tag,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // 좋아요 버튼 기능 추가
                      },
                      icon: Icon(Icons.favorite_border),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


