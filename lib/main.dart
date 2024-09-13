import 'package:flutter/material.dart';
import 'package:my_lotto_app/pages/profile_page.dart';
import 'package:my_lotto_app/pages/home_page.dart';
import 'package:my_lotto_app/user_name_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp()); // MyApp을 최상위 위젯으로 설정
}

class MyApp extends StatelessWidget {
  // 새로운 MyApp 클래스 추가
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 80, 200, 120),
        scaffoldBackgroundColor: const Color.fromARGB(255, 15, 15, 15),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 80, 200, 120),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w800),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Colors.black,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const InitialPage(), // InitialPage를 home으로 설정
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool _isUserNameSaved = false;

  @override
  void initState() {
    super.initState();
    _checkUserName();
  }

  Future<void> _checkUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    setState(() {
      _isUserNameSaved = userName != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isUserNameSaved ? const MainPage() : const UserNamePage();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool isUserNameSaved = false;

  @override
  void initState() {
    super.initState();
    _checkUserName();
  }

  Future<void> _checkUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    setState(() {
      isUserNameSaved = userName != null;
    });
  }

  List<Widget> bodyPages = [
    const HomePage(),
    // const GamePage(),
    const ProfilePage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.animateToPage(
      selectedIndex,
      duration: const Duration(milliseconds: 70),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: bodyPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          // BottomNavigationBarItem(
          //   label: 'Game',
          //   icon: Icon(Icons.games_outlined),
          // ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
