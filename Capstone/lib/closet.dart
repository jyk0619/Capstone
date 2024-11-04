import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class Closet extends StatefulWidget {
  Closet({super.key});

  @override
  State<Closet> createState() => _ClosetState();
}

class _ClosetState extends State<Closet> {
  int? itemCount; // null 초기화로 준비 상태를 나타냄
  bool isLoading = true; // 로딩 상태
  List<QueryDocumentSnapshot>? allItems; // 전체 아이템
  List<QueryDocumentSnapshot>? topItems; // 상의 아이템
  List<QueryDocumentSnapshot>? bottomItems; // 하의 아이템
  List<QueryDocumentSnapshot>? outerItems; // 아우터 아이템

  @override
  void initState() {
    super.initState();
    getData(); // initState에서 getData를 호출
  }

  // Firestore에서 데이터 가져오기
  Future<void> getData() async {
    var item = await firestore.collection('item').get();

    setState(() {
      itemCount = item.docs.length;
      allItems = item.docs; // 전체 아이템 저장
      // 카테고리별로 필터링
      topItems = item.docs.where((doc) => doc['category'] == '상의').toList();
      bottomItems = item.docs.where((doc) => doc['category'] == '하의').toList();
      outerItems = item.docs.where((doc) => doc['category'] == '아우터').toList();
      isLoading = false; // 데이터 로딩 완료 후 로딩 상태를 false로 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: '전체'),
                Tab(text: '상의'),
                Tab(text: '하의'),
                Tab(text: '아우터'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  isLoading ? Center(child: SizedBox(child: CircularProgressIndicator())) : Grid(item: allItems),
                  isLoading ? Center(child: SizedBox(child: CircularProgressIndicator())) : Grid(item: topItems),
                  isLoading ? Center(child: SizedBox(child: CircularProgressIndicator())): Grid(item: bottomItems),
                  isLoading ? Center(child: SizedBox(child: CircularProgressIndicator())) : Grid(item: outerItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Grid extends StatelessWidget {
  final List<QueryDocumentSnapshot>? item;

  Grid({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: item?.length ?? 0, // 아이템 개수
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          width: 100,
          height: 100,
          child: Column(
            children: [
              Text('아이템 $index'), // 아이템 번호 표시
              Expanded(
                child: Container(
                  child: Text(item![index].data().toString()), // 각 아이템의 데이터 표시
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
