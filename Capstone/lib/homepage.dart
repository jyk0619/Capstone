import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'imageupload.dart' as imgupload;
import 'closet.dart';
import 'mypage.dart';
import 'view/weather_screen.dart';

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

  final style=['캐주얼','스트릿','포멀'];
  var selectedStyle='캐주얼';
  var today = DateTime.now();
  var dataState = false;

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
                Text('서울',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),
                ),
              ],
            ),
          ),
          WeatherScreen(),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(10),
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
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),

                          ),
                          child: Image.asset('assets/images/fesample$i.png')
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