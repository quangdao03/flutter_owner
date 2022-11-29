import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ui/home.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> fetchAlbum() async {
  final headers = {
    'Content-type': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOLFJPTEVfRFJJVkVSLFJPTEVfVVNFUiIsImV4cCI6MTY2OTgxODkwOH0.bF2GH5508NMrlCjGyUeVa0BVWHtD4LVGo0YS0CE23iqPf2nczMtODk2CskDAS7CsVu--ZzWw8PX_AqH2I6B3yg',
  };
  final response = await http.get(
      Uri.parse(
          'http://a64fcdd91dec34a9fbcfcdd93f10c495-2057221956.ap-southeast-1.elb.amazonaws.com/services/batteryservice/api/bss/bss_v1.0_0001/batteries'),
      headers: headers);

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<Album> post =
        body.map((dynamic item) => Album.fromJson(item)).toList();

    return post;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String serialNumber;

  const Album({
    required this.serialNumber,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      serialNumber: json['serialNumber'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Album>> futureAlbum;
  List<Album> data = [];
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Danh sách pin'),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),

          // child: FutureBuilder<List<Album>>(
          //   future: futureAlbum,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       data = snapshot.data!;

          //       return _screen(context);
          //     } else if (snapshot.hasError) {
          //       return Text('${snapshot.error}');
          //     }

          //     // By default, show a loading spinner.
          //     return const CircularProgressIndicator();
          //   },
          // ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              // backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Business',
              //backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'School',
              //backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              //backgroundColor: Colors.pink,
            ),
          ],
          currentIndex: _selectedIndex,
          //selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _screen(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(primary: false, slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(6),
            sliver: SliverGrid.count(
              childAspectRatio: 0.9,
              crossAxisCount: 2,
              children: [
                ...List.generate(
                    data.length,
                    (index) => Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 4))
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('${data[index].serialNumber}',
                                  style: TextStyle(color: Colors.lightBlue)),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Image.asset(
                                  'assets/images/pin 3.png',
                                  fit: BoxFit.fill,
                                  height: 80,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Số chu kỳ sạc:',
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  Text('200',
                                      style:
                                          TextStyle(color: Colors.lightBlue)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Dung lượng:',
                                      style:
                                          TextStyle(color: Colors.lightBlue)),
                                  Text('19 mAh',
                                      style:
                                          TextStyle(color: Colors.lightBlue)),
                                ],
                              ),
                            )
                          ],
                        )))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
