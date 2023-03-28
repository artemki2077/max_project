import 'package:flutter/material.dart';
import 'pages/basket.dart';
import 'pages/search.dart';
import 'glob.dart' as glob;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Max Project',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPage = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: glob.maindark,
      appBar: AppBar(
        backgroundColor: const Color(0xff5B04BC),
        toolbarHeight: 60,
        title: const Text('PC BUILD', style: TextStyle(
          fontSize: 30
        ),),
      ),
      body: [const Basket(), const Search()].elementAt(_selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.white,
        backgroundColor: glob.maindark,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_basket_outlined,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 40),
            label: '',
          ),
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.deepPurple,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
