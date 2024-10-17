
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'imageupload.dart' as imgupload;
import 'closet.dart';
import 'package:fluttericon/meteocons_icons.dart';


void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.black, secondary: Colors.white, ),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: [Text('이번주 코디'),Text('옷장'),Text('마이페이지')][tab],
      ),
      body:[home() , closet(),Text('2')][tab],
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => imgupload.imgupload()));
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

  final style=['캐주얼','스트릿','포멀'];
  var selectedStyle='캐주얼';

  var tmx=[];
  var tmn=[];
  var sky=[];
  var dataState = false;

  String getToday(){
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMd');
    String strToday = formatter.format(now);
    return strToday;
  }


  getData()async{
    //var result = await http.get(Uri.parse('https://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst?serviceKey=%2FAWFYHmCe1YGFJbVpskX6WgKpkjvs3joL8rTZ24kja%2BfII%2FMX%2BvPbsTHx%2B8G7GHek5nHx8cRwusgBPpd0yaLKg%3D%3D&pageNo=1&numOfRows=10&dataType=JSON&regId=11B00000&tmFc='+getToday()+'0600'));
    //var result2 = jsonDecode(result.body);
    //var result3 = result2['response']['body']['items']['item'][0];
    //print(result3);

    var result4 = await http.get(Uri.parse('https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=%2FAWFYHmCe1YGFJbVpskX6WgKpkjvs3joL8rTZ24kja%2BfII%2FMX%2BvPbsTHx%2B8G7GHek5nHx8cRwusgBPpd0yaLKg%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&base_date='+getToday()+'&base_time=0200&nx=55&ny=127'));
    var result5 = jsonDecode(result4.body);
    var sky1 = result5['response']['body']['items']['item'][5]['fcstValue'];
    var sky2 = result5['response']['body']['items']['item'][295]['fcstValue'];
    var sky3 = result5['response']['body']['items']['item'][585]['fcstValue'];
    var tmx1 = result5['response']['body']['items']['item'][157]['fcstValue'];
    var tmx2 = result5['response']['body']['items']['item'][447]['fcstValue'];
    var tmx3 = result5['response']['body']['items']['item'][737]['fcstValue'];
    var tmn1 = result5['response']['body']['items']['item'][48]['fcstValue'];
    var tmn2 = result5['response']['body']['items']['item'][338]['fcstValue'];
    var tmn3 = result5['response']['body']['items']['item'][628]['fcstValue'];
    var pty1 = result5['response']['body']['items']['item'][6]['fcstValue'];
    var pty2 = result5['response']['body']['items']['item'][296]['fcstValue'];
    var pty3 = result5['response']['body']['items']['item'][586]['fcstValue'];


    setState(() {
      tmx = [tmx1,tmx2,tmx3];
      tmn = [tmn1,tmn2,tmn3];
      sky = [sky1,sky2,sky3];
      dataState = true;
    });
  }
  //날씨 api
//https://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst?serviceKey=%2FAWFYHmCe1YGFJbVpskX6WgKpkjvs3joL8rTZ24kja%2BfII%2FMX%2BvPbsTHx%2B8G7GHek5nHx8cRwusgBPpd0yaLKg%3D%3D&pageNo=1&numOfRows=10&dataType=JSON&regId=11B00000&tmFc=202410150600
// 기온 api
  //https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey=%2FAWFYHmCe1YGFJbVpskX6WgKpkjvs3joL8rTZ24kja%2BfII%2FMX%2BvPbsTHx%2B8G7GHek5nHx8cRwusgBPpd0yaLKg%3D%3D&pageNo=1&numOfRows=10&dataType=JSON&regId=11B10101&tmFc=202410150600

  //단기예보 api
  //https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=%2FAWFYHmCe1YGFJbVpskX6WgKpkjvs3joL8rTZ24kja%2BfII%2FMX%2BvPbsTHx%2B8G7GHek5nHx8cRwusgBPpd0yaLKg%3D%3D&pageNo=2&numOfRows=12&dataType=JSON&base_date=20241015&base_time=0500&nx=55&ny=127

  void initState(){
    super.initState();
    getData();

  }
var today = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
      children: [
        Container(
          width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: Text(today.toString(),style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),
            )
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.location_on_outlined),
              Text('위치',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          width: double.infinity,
          child:
              CarouselSlider(
                options: CarouselOptions(
                    height: 120.0,
                  enableInfiniteScroll: true,

                ),

                items: [0, 1, 2].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.symmetric(horizontal: 1.0),
                          padding: EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: dataState?weather(i:i, sky:sky,today:today.toString(),tmx:tmx,tmn:tmn):Text('기상정보 불러오는중'),
                      );
                    },
                  );
                }).toList(),
              )
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(5),
          child: Text('오늘의 코디',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                });
              },
            )
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
              items: [1, 2, 3].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                            color: Colors.grey
                        ),
                        child: Text(
                          'style $i', style: TextStyle(fontSize: 16.0),)
                    );
                  },
                );
              }).toList(),
            )
        )
      ],
    ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class weather extends StatelessWidget {
  final String today;
  final tmx;
  final tmn;
  final sky;
  final i;

  weatherValue(x){
    if (x==0)
      return '맑음';
    else if (x==1)
      return '구름조금';
    else if (x==3)
      return '구름많음';
    else if (x==4)
      return '흐림';
  }
  weatherIcon(x){
    if (x==0)
      return Meteocons.sun_inv;
    else if (x==1)
      return Meteocons.cloud_sun_inv;
    else if (x==3)
      return Meteocons.cloud_inv;
    else if (x==4)
      return Meteocons.clouds_inv;
  }


  Datenum(i) {
    var date = DateTime.now().add(Duration(days: i));
    return date;
  }

  date(i){
    var date = DateFormat('MM월 dd일').format(DateTime.now().add(Duration(days: i)));
    return date;
  }
  E(x){
    var E = DateFormat('(E)').format(x);
    return E;
  }


   weather({super.key, required this.i ,required this.sky,required this.today,required this.tmx,required this.tmn});

  @override
  Widget build(BuildContext context) {
    return Container(

        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey[50]
        ),
        margin: const EdgeInsets.all(5),
        width: 140,

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date(i).toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                Text(E(Datenum(i)).toString()),
                i==0 ?
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.pink[100],
                  ),
                  child:Text("오늘",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold)),
                )
                :SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(weatherIcon(int.parse(sky[i]))),
                Text(' ${weatherValue(int.parse(sky[i]))}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${tmx[i]}°C ' ,style: TextStyle(color:Colors.redAccent,fontSize: 20,fontWeight: FontWeight.bold)),
              Text(' / '),
              Text('${tmn[i]}°C',style: TextStyle(color:Colors.lightBlue, fontSize: 20,fontWeight: FontWeight.bold))
              ],
            ),

          ],
        )
    );
  }
}
