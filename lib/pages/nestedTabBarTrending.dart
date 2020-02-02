import 'package:flutter/material.dart';
import 'package:gittrend/pages/trendingDaily.dart';
import 'package:gittrend/pages/trendingMonthly.dart';
import 'package:gittrend/pages/trendingWeekly.dart';

class NestedTabBarTrending extends StatefulWidget {
  @override
  _NestedTabBarTrendingState createState() => _NestedTabBarTrendingState();
}

class _NestedTabBarTrendingState extends State<NestedTabBarTrending>
    with TickerProviderStateMixin {
  TabController _nestedTabController;

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Daily",
            ),
            Tab(
              text: "Weekly",
            ),
            Tab(
              text: "Monthly",
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.70,
          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0),
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              TrendingDaily(),
              TrendingWeekly(),
              TrendingMonthly()
            ],
          ),
        )
      ],
    );
  }
}
