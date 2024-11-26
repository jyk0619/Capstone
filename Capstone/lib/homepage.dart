import 'package:capstone/viewmodel/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'imageupload.dart' as imgupload;
import 'closet.dart';
import 'mypage.dart';
import 'view/weather_screen.dart';
import 'viewmodel/randomitem.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var tab = 0;
  final title = ['추천','옷장','마이페이지'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            title: Text(title[tab].toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
        ),
        body:[home() , Closet(), MyPage()][tab],
        bottomNavigationBar: BottomAppBar(
          color: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon:  Icon(Icons.home,color: tab==0? Colors.black : Colors.grey,),
                onPressed: () {
                  setState(() {
                    tab = 0;
                  });},
              ),
              IconButton(
                icon:  Icon(Icons.grid_on,color: tab==1? Colors.black : Colors.grey,),
                onPressed: () {setState(() {
                  tab = 1;
                });},
              ),
              IconButton(
                icon:  Icon(Icons.person,color: tab==2? Colors.black : Colors.grey,),
                onPressed: () {setState(() {
                  tab = 2;
                });},
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => imgupload.Imgupload()));
          },
          child: const Icon(Icons.add),
        )
    );
  }
}



class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}
class _homeState extends State<home> {
  final RandomItemService _randomItemService = RandomItemService();
  Map<String, dynamic>? selectedItem;
  Map<String, dynamic>? recommendationResponse;  // 추천 API 응답을 저장할 변수
  List<String> recommendImgs = []; // 추천된 이미지 URL들을 저장할 리스트
  var setSeason = '봄';

  Future<void> getRandomItem() async {
    Map<String, dynamic>? item = await _randomItemService.getRandomItem();

    setState(() {
      selectedItem = item;
    });

    if (item != null) {
      // 아이템을 추천 API로 보내고 응답 받기
      Map<String, dynamic> recommendation = await _randomItemService.sendItemToRecommendAPI(item, selectedStyle,setSeason);

      setState(() {
        recommendationResponse = recommendation;

        print('추천된것 : $recommendationResponse');
        // 'recommended_items'가 null이 아닌 경우 처리
        if (recommendation['recommended_items'] != null) {
          recommendImgs = List<String>.from(
            recommendation['recommended_items'].map((recommendedItem) {
              // 'imageUrl'이 null이 아니면 그 값을 사용, null이면 빈 문자열 처리
              return recommendedItem['item']['imageUrl'] != null
                  ? recommendedItem['item']['imageUrl'] as String
                  : '';
            }),
          );
        } else {
          recommendImgs = [];  // 'recommended_items'가 null이면 빈 리스트로 처리
        }
      });

      print('추천 결과: $recommendation');
    }
  }

  @override
  void initState() {
    super.initState();
    getRandomItem(); // 페이지 로드 시 실행
  }

  final style = ['캐주얼', '스트릿', '포멀'];
  var selectedStyle = '캐주얼';
  var today = DateTime.now();


  @override
  Widget build(BuildContext context) {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);

    // weatherData가 비어 있지 않은지 확인
    if (weatherViewModel.weatherData.isEmpty) {
      // 비어 있으면 로딩 인디케이터 또는 플레이스홀더를 표시
      return Center(child: CircularProgressIndicator());
    }
    final data = weatherViewModel.weatherData[0];
    final tmx = double.parse(data.tmx);
    final tmn = double.parse(data.tmn);
    final mid = (tmx+tmn)/2;
    print('tmx: $tmx, tmn: $tmn');
    if(mid>23){
      setSeason = '여름';
    }else if(mid<10){
      setSeason = '겨울';
    }else{
      setSeason = '봄';
    }
    print('setSeason: $setSeason');

    return Container(
      child: ListView(
        children: [
          Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: Text(
                today.toString(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.location_on_outlined),
                Text(
                  '서울',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          WeatherScreen(),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  '오늘의 코디',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.sunny, color: Colors.yellow),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: DropdownButton(
              value: selectedStyle,
              items: style.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStyle = value!;
                  getRandomItem(); // 스타일 변경 시 추천 아이템 재조회
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            height: 300,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
              ),
              items: recommendImgs.isEmpty
                  ? [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: CircularProgressIndicator()), // 로딩 중 처리
                )
              ]
                  : recommendImgs.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: imgUrl.isNotEmpty
                          ? Image.network(imgUrl)
                          : Center(child: CircularProgressIndicator()), // 로딩 중 처리
                    );
                  },
                );
              }).toList(),
            )

          )

        ],
      ),
    );
  }
}
