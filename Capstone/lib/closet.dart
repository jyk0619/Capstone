import 'dart:io';
import 'package:capstone/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class Closet extends StatefulWidget {
  Closet({super.key});

  @override
  State<Closet> createState() => _ClosetState();
}

class _ClosetState extends State<Closet> {
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
                  _buildStreamBuilder('전체'),
                  _buildStreamBuilder('상의'),
                  _buildStreamBuilder('하의'),
                  _buildStreamBuilder('아우터'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // StreamBuilder로 Firestore에서 실시간 데이터 가져오기
  Widget _buildStreamBuilder(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('item')
          .where('category', isEqualTo: category != '전체' ? category : null) // 카테고리별 필터링
          .snapshots(), // 실시간 데이터 스트림
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No items available.'));
        } else {
          List<QueryDocumentSnapshot> items = snapshot.data!.docs;
          return Grid(item: items);
        }
      },
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
        var data = item![index].data() as Map<String, dynamic>;
        String imageUrl = data['imageUrl'] ?? '';

        // 이미지 URL이 없으면 기본 이미지 설정
        if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
          imageUrl = 'https://via.placeholder.com/150';
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          width: 100,
          height: 100,
          child: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // 아이템 삭제
                      await item![index].reference.delete();
                    },
                  ),
                ],
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Image.network(imageUrl),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Image.network(imageUrl),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
