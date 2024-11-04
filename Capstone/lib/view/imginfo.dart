import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone/viewmodel/imginfo_view_model.dart';
class ImgInfo extends StatefulWidget {
  final File file;

  ImgInfo({super.key, required this.file});

  @override
  State<ImgInfo> createState() => _ImgInfoState();
}

class _ImgInfoState extends State<ImgInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ImgInfoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('이미지 정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            height: 400,
            child: Image.file(widget.file),
          ),
          // FormWidget 추가
          FormWidget(
            name: '스타일',
            option: ['기본', '캐주얼', '스트릿', '포멀'],
            selectedOption: viewModel.selectedOptions.style,
            onOptionSelected: (value) {
              viewModel.updateOption('스타일', value);
            },
          ),
          FormWidget(
            name: '카테고리',
            option: ['상의', '하의', '아우터'],
            selectedOption: viewModel.selectedOptions.category,
            onOptionSelected: (value) {
              viewModel.updateOption('카테고리', value);
            },
          ),
          FormWidget(
            name: '클래스',
            option: ['shirts', 'short_sleeve', 'denim'],
            selectedOption: viewModel.selectedOptions.classname,
            onOptionSelected: (value) {
              viewModel.updateOption('클래스', value);
            },
          ),
          FormWidget(
            name: '색상',
            option: [
              'Black', 'White', 'Red', 'Blue', 'Yellow',
              'Green', 'Pink', 'Purple', 'Orange', 'Brown', 'Grey'
            ],
            selectedOption: viewModel.selectedOptions.color,
            onOptionSelected: (value) {
              viewModel.updateOption('색상', value);
            },
          ),
          FormWidget(
            name: '계절',
            option: ['봄', '여름', '가을', '겨울'],
            selectedOption: viewModel.selectedOptions.season,
            onOptionSelected: (value) {
              viewModel.updateOption('계절', value);
            },
          ),
          FormWidget(
            name: '패턴',
            option: ['None','solid', 'printin', 'stripe', 'check', 'dot', 'floral'],
            selectedOption: viewModel.selectedOptions.pattern,
            onOptionSelected: (value) {
              viewModel.updateOption('패턴', value);
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await viewModel.saveSelectedOptions(); // Firestore에 저장
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('데이터가 저장되었습니다.')),
              );
              Navigator.pop(context);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  final List<String> option;  // 드롭다운 메뉴의 옵션 리스트
  final String name;           // 드롭다운의 이름 (레이블)
  final String selectedOption; // 선택된 옵션
  final ValueChanged<String> onOptionSelected; // 옵션 선택 시 호출되는 콜백

  FormWidget({
    super.key,
    required this.name,
    required this.option,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)), // 아래쪽 경계선
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name), // 드롭다운 레이블
          DropdownButton<String>(
            value: selectedOption, // 현재 선택된 값
            items: option.map((value) {
              return DropdownMenuItem<String>(
                value: value, // 각 드롭다운 아이템의 값
                child: Text(value), // 각 드롭다운 아이템의 텍스트
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onOptionSelected(value); // 값이 변경되면 콜백 호출
              }
            },
          ),
        ],
      ),
    );
  }
}