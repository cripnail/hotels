import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ImageSlideHome extends StatefulWidget {
  static const routeName = '/about';
  final item;

  const ImageSlideHome({Key key, @required this.item}) : super(key: key);

  @override
  _ImageSlideHomeState createState() => _ImageSlideHomeState();
}

class _ImageSlideHomeState extends State<ImageSlideHome> {
  Future<dynamic> fetchPost() async {
    final response = await http
        .get(Uri.parse('https://run.mocky.io/v3/${widget.item.uuid}'));
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return decoded;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
              future: fetchPost(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return function('assets/images/b&b_la_fontaine_', 8);
                } else if (snapshot.hasData) {
                  return function('assets/images/disney_dreams_', 6);
                } else if (snapshot.hasData) {
                  return function('assets/images/golden_ratio_', 8);
                } else if (snapshot.hasData) {
                  return function('assets/images/grand_orlando_resort_', 7);
                } else if (snapshot.hasData) {
                  return function('holiday_inn_&_suites_orlando_', 8);
                } else if (snapshot.hasData) {
                  return function('assets/images/motel_one_brussels_', 11);
                } else if (snapshot.hasData) {
                  return function('assets/images/new_rome_house_', 6);
                } else if (snapshot.hasData) {
                  return function('assets/images/oscar_hotel_', 6);
                } else if (snapshot.hasData) {
                  return function('assets/images/p_17_hotel_', 8);
                } else if (snapshot.hasData) {
                  return function('parkway_international_', 8);
                } else if (snapshot.hasData) {
                  return function('assets/images/stradom_apartments_', 10);
                } else if (snapshot.hasData) {
                  return function(
                      'assets/images/upon_lisbon_prime_residences_', 8);
                }
                // While fetching, I show a loading spinner.
                return CircularProgressIndicator();
              }),
          FutureBuilder(
              future: fetchPost(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  // Data fetched successfully, I display my data here
                  return Column(
                    children: <Widget>[
                      Text(snapshot.data['address']['city'].toString()),
                      Text(snapshot.data['price'].toString()),
                      Text(snapshot.data['rating'].toString()),
                      Text(snapshot.data['services'].toString()),
                    ],
                  );
                } else if (snapshot.hasError) {
                  // If something went wrong
                  return Text('Something went wrong...');
                }

                // While fetching, I show a loading spinner.
                return CircularProgressIndicator();
              }),
        ],
      ),
    );
  }

  Container function(String host, int repeat) {
    List<Widget> list = [];

    for (int i = 1; i <= 8; i++) {
      list.add(Image.asset('$host$i.jpg'));
    }
    return Container(
      height: 200,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: list,
        autoplay: false,
        // animationCurve: Curves.fastOutSlowIn,
        //  animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 6.0,
        dotBgColor: Colors.transparent,
      ),
    );
  }
}
