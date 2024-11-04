import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'viewmodel/weather_view_model.dart'; // WeatherViewModel 임포트
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'viewmodel/imginfo_view_model.dart'; // ImgInfoViewModel 임포트


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
    return MultiProvider( // MultiProvider 사용
      providers: [
        ChangeNotifierProvider(create: (context) => Store1()),
        ChangeNotifierProvider(create: (context) => WeatherViewModel()), // WeatherViewModel 추가
        ChangeNotifierProvider(create: (context)=>ImgInfoViewModel()), // ImgInfoViewModel 추가
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.light(primary: Colors.black, secondary: Colors.white),
          useMaterial3: true,
        ),
        home: MyHomePage(), // 이곳에서 MyHomePage를 호출
      ),
    );
  }
}

class Store1 extends ChangeNotifier {
  String imgPath = '';
  String iteminfo = '';

  void changeItemInfo(String info) {
    iteminfo = info;
    notifyListeners();
  }

  void changeImgPath(String path) {
    imgPath = path;
    notifyListeners();
  }
}
