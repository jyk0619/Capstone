import  'package:flutter/material.dart';

class closet extends StatefulWidget {
  closet({super.key});

  @override
  State<closet> createState() => _closetState();
}
var tab=0;
var selected=0;


class _closetState extends State<closet> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: '전체',),
                Tab(text: '상의',),
                Tab(text: '하의',),
                Tab(text: '아우터',),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  grid(),
                  grid(),
                  grid(),
                  grid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class grid extends StatelessWidget {
  const grid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            width: 100,
            height: 100,
            child: Column(
              children: [
                Text('옷$index'),
              ],
            )
        );
      },
    );
  }
}
