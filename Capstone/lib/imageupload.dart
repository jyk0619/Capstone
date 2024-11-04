import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '/view/imginfo.dart' as imginfo;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'viewmodel/imginfo_view_model.dart'; // ViewModel 임포트

class Imgupload extends StatefulWidget {
  const Imgupload({super.key});

  @override
  State<Imgupload> createState() => _ImguploadState();
}

var userImage = File('');

bool isImage() {
  return userImage.path.isNotEmpty;
}

class _ImguploadState extends State<Imgupload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('이미지 업로드'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                    var image = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        userImage = File(image.path);
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_to_photos),
                  onPressed: () async {
                    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        userImage = File(image.path);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: 400,
            height: 400,
            child: isImage() ? Image.file(userImage) : Text('이미지 없음'),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 로딩 팝업을 표시하고 이미지 업로드 시작
                  showLoadingDialog(context);
                  _uploadImage(context, userImage).then((responseBody) {
                    Navigator.of(context).pop(); // 로딩 팝업 닫기

                    if (responseBody != null) {
                      // 이미지 업로드 후 성공적으로 응답을 받으면 imginfo 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => imginfo.ImgInfo(file: userImage)),
                      );
                    } else {
                      // 실패 시 메시지 또는 알림 처리
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이미지 업로드 실패')),
                      );
                    }
                  });
                },
                child: Text('업로드'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    userImage = File('');
                  });
                },
                child: Text('취소'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 로딩 다이얼로그 함수
void showLoadingDialog(BuildContext context) {
  showDialog(

    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              color: Colors.lightBlueAccent,
              size: 50.0,
              duration: Duration(seconds: 2),
            ),
            SizedBox(width: 20),
            Text('이미지 분석중...', style: TextStyle(fontSize: 15, color: Colors.lightBlue)),
          ],
        ),
      );
    },
  );
}

// _uploadImage 메서드 추가
Future<String?> _uploadImage(BuildContext context, File image) async {
  final viewModel = Provider.of<ImgInfoViewModel>(context, listen: false);
  await viewModel.uploadImage(context, image);
  return viewModel.classification; // 업로드 후 분류 결과 반환
}
