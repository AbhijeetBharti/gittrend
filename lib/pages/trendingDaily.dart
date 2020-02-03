import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrendingDaily extends StatefulWidget {
  @override
  _TrendingDailyState createState() => _TrendingDailyState();
}

class _TrendingDailyState extends State<TrendingDaily> {
  List data;
  List fetchData;

  Future getData() async {
    http.Response response = await http.get(
        "https://github-trending-api.now.sh/repositories?language=&since=daily");
    fetchData = json.decode(response.body);
    setState(() {
      data = fetchData;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: InkWell(
            onTap: () {
              _launchURL(data[index]["url"]);
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: 15, top: 15, right: 15, bottom: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(data[index]["avatar"]),
                        ),
                      ),
                      Text(
                          "${data[index]["author"]}" +
                              "/" +
                              "${data[index]["name"]}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  Container(
                      width: 170,
                      height: 30,
                      margin: const EdgeInsets.only(left: 65),
                      decoration: new BoxDecoration(
                          color: Colors.teal[100],
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.star,
                                color: Colors.teal,
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 5),
                            child: Text(
                              "${data[index]["currentPeriodStars"]}",
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text("Stars Today",
                                style: TextStyle(color: Colors.teal)),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 5),
                    child: Text("${data[index]["description"]}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 15,
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 20,
                          width: 20,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                              color: hexToColor(data[index]["languageColor"]),
                              shape: BoxShape.circle),
                        ),
                        Text("${data[index]["language"]}"),
                        Container(
                            margin: EdgeInsets.only(
                                left: 15, top: 10, bottom: 10, right: 10),
                            child: Icon(
                              Icons.star,
                              color: Colors.black,
                            )),
                        Text("${data[index]["stars"]}"),
                        Container(
                          width: 25,
                          height: 25,
                          margin: EdgeInsets.only(
                              left: 15, top: 10, bottom: 10, right: 10),
                          child: Image.asset('assets/f2.png'),
                        ),
                        Text("${data[index]["forks"]}")
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Built By :",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
//                        Container(
//                          child: ListView.builder(
//                            shrinkWrap: true,
//                            itemCount: builtBy.length,
//                            itemBuilder: (BuildContext context, int index) {
//                              print(builtBy[index]["username"]);
//                              return Text("");
//                            },
//                          ),
//                        ),
                        Container(
                          margin: EdgeInsets.only(left: 188),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.bookmark_border),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Color hexToColor(String code) {
    if (code != null) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }
  }
}
