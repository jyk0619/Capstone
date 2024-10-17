import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'imginfo.dart'as imginfo;
import 'package:flutter_spinkit/flutter_spinkit.dart';



class imgupload extends StatefulWidget {
  const imgupload({super.key});

  @override
  State<imgupload> createState() => _imguploadState();
}
var userImage=File('');

isImage(){
  if(userImage.toString()=="File: ''")
    return Text('이미지 없음');
  else
    return Image.file(userImage);
}
class _imguploadState extends State<imgupload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            title: Text('이미지 업로드'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        ),
        body:Column(
          children: [
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.all(5),
                    width: 100,
                    height: 100,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child:IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () async{
                        var image = await ImagePicker().pickImage(source: ImageSource.camera);
                        if(image!=null)
                        {
                          setState(() {
                            userImage = File(image.path);
                          });
                        }
                        },
                    )
                ),
                Container(
                    margin: const EdgeInsets.all(5),
                    width: 100,
                    height: 100,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child:IconButton(
                      icon: const Icon(Icons.add_to_photos),
                      onPressed: () async{
                        var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if(image!=null)
                        {
                          setState(() {
                            userImage = File(image.path);
                          });
                        }
                      },
                    )
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 400,
              height: 400,
              child:isImage(),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    showLoadingScreen(context);

                  },
                  child: Text('업로드'),
                ),
                ElevatedButton(
                  onPressed: (){setState(() {
                    userImage=File('');
                  });},
                  child: Text('취소'),
                ),
              ],
            )],

        )
    );
  }
}
void showLoadingScreen(BuildContext context) {
  // 로딩 다이얼로그를 표시
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: SpinKitWave( // FadingCube 모양 사용
          color: Colors.lightBlueAccent, // 색상 설정
          size: 50.0, // 크기 설정
          duration: Duration(seconds: 2), //속도 설정
        ), // 로딩 스피너
      );
    },
  );
  // 비동기 작업을 시뮬레이션 (여기에 실제 비동기 작업을 넣어야 함)
  Future.delayed(Duration(seconds: 2), () {
    // 로딩 화면을 닫고 imginfo 화면으로 이동
    Navigator.of(context).pop(); // 로딩 화면 닫기
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => imginfo.imginfo(file:userImage)),
    );
  });
}

