import 'dart:io';

import 'package:capstone/imageupload.dart';
import 'package:flutter/material.dart';

class imginfo extends StatefulWidget {
   imginfo({super.key, required this.file});
   final file;

  @override
  State<imginfo> createState() => _imginfoState();
}
class _imginfoState extends State<imginfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('이미지 정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
        ListView(
          children: [
            Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child:
                    Image.file(userImage)
                    ),
            FormWidget(name:'스타일', option:['기본','캐주얼','스트릿','포멀']),
            FormWidget(name:'카테고리', option:['상의','하의','아우터']),
            FormWidget(name:'색상', option:['Black','White','Red','Blue','Yellow','Green','Pink','Purple','Orange','Brown','Grey']),
            FormWidget(name:'계절', option:['봄','여름','가을','겨울']),
            FormWidget(name:'패턴', option:['Solid','Printing','Stripe','Check','Dot','Floral']),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Respond to button press
                  },
                  child: const Text('저장'),
                ),
              ],
      ),
    ],
    ),
    );
  }
}


class FormWidget extends StatefulWidget {
  final List<String> option;
  final String name;

  FormWidget({super.key, required this.name, required this.option});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  late String selectedOption; // late를 사용하여 초기화 지연
  late List<String> options; // late를 사용하여 초기화 지연
  late String title;

  @override
  void initState() {
    super.initState();
    setOptions(); // initState에서 옵션 설정
  }

  void setOptions() {
    options = widget.option;
    selectedOption = options[0]; // 첫 번째 옵션으로 초기화
    title = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Container(
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              value: selectedOption,
              items: options.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value!; // 새 선택 옵션으로 업데이트
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
