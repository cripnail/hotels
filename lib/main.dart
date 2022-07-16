import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'models/hotel.dart';
import 'views/not_found_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          return NotFoundPage();
        });
      },
      routes: {
        '/': (BuildContext context) => MyHomePage(),
        '/about': (BuildContext context) => ImageSlideHome(
          item: 'assets/images/item',
        ),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  static const routeName = '/';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  bool hasError = false;
  List<HotelPreview> hotels;
  String errorMessage;
  Dio _dio = Dio();
  bool isGridViewOn = false;
  bool isListViewOn = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getDataDio();
  }

  getDataDio() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio
          .get('https://run.mocky.io/v3/ac888dc5-d193-4700-b12c-abb43e289301');
      var data = response.data;
      hotels = data
          .map<HotelPreview>(
              (hotelPreview) => HotelPreview.fromJson(hotelPreview))
          .toList();
    } on DioError catch (e) {
      setState(() {
        errorMessage = e.response.data['message'];
        hasError = false;
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white70,
        // resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Hotel Preview'),
          actions: [
            IconButton(
              icon: Icon(Icons.view_list),
              onPressed: () {
                setState(() {
                  isListViewOn = !isListViewOn;
                  isGridViewOn = !isGridViewOn;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.view_module),
              onPressed: () {
                setState(() {
                  isListViewOn = !isListViewOn;
                  isGridViewOn = !isGridViewOn;
                });
              },
            ),
          ],
        ),
        body: _buildBody(context));
  }

  // ignore: missing_return
  Widget _buildBody(BuildContext context) {
    if (isLoading) Center(child: CircularProgressIndicator());
    if (!isLoading && hasError) Center(child: Text('Page not found'));
    if (!isLoading && !hasError)
      return LayoutBuilder(
        // ignore: missing_return
        builder: (BuildContext context, BoxConstraints constraints) {
          if (isListViewOn && !isGridViewOn) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                var item = hotels[index];
                return Stack(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      color: Colors.white,
                      elevation: 10,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Image.asset('assets/images/${item.poster}'),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 4.0,
                      right: 8.0,
                      left: 8.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  (item.name),
                                  style: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 10),
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImageSlideHome(item: item),
                                          settings: RouteSettings(
                                            arguments: item,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("Подробнее"),
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          if (!isListViewOn && isGridViewOn) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2),
              padding: EdgeInsets.all(8),
              itemCount: hotels.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = hotels[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    child: Image.asset('assets/images/${item.poster}',
                        fit: BoxFit.cover),
                    footer: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // margin: EdgeInsets.symmetric(vertical: 5.0, horizontal:25.0),
                          padding: const EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Text(
                            (item.name),
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 25.0,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(5.0),
                          color: Colors.blue,
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ImageSlideHome(item: item),
                                  settings: RouteSettings(
                                    arguments: item,
                                  ),
                                ),
                              );
                            },
                            child: Text("Подробнее"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            minWidth: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      );
  }
}
