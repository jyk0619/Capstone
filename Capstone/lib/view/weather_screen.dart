// views/weather_screen.dart

import 'package:flutter/material.dart';
import 'package:fluttericon/meteocons_icons.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weather_view_model.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';



class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    // 데이터 로딩 중인지 확인
    if (weatherViewModel.dataState == false) {
      return Center(child: CircularProgressIndicator());
    }

    return
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
              final data = weatherViewModel.weatherData[i];

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
                    child: weather(tmx: data.tmx, tmn: data.tmn, sky: data.sky, i: i),
                  );
                },
              );
            }).toList(),
    )
      );
  }
}


class weather extends StatelessWidget {
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


  weather({super.key, required this.i ,required this.sky,required this.tmx,required this.tmn});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(

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
                Icon(weatherIcon(int.parse(sky))),
                Text(' ${weatherValue(int.parse(sky))}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${tmx}°C ' ,style: TextStyle(color:Colors.redAccent,fontSize: 20,fontWeight: FontWeight.bold)),
                Text(' / '),
                Text('${tmn}°C',style: TextStyle(color:Colors.lightBlue, fontSize: 20,fontWeight: FontWeight.bold))
              ],
            ),

          ],
        )
    );
  }
}

