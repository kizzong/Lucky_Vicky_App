import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:my_lotto_app/lotto_number_balls.dart';
import 'package:my_lotto_app/pages/sentence_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 랜덤으로 추출된 7개의 번호를 int형태로 저장한 List
  List<int> lottoNumbers = [];

  // 1. 기기 안에 있는 고정 메모리에 저장된 번호들
  List<List<int>> savedNumbers = [];

  bool hasGenerated = false; // 로또 번호가 [생성] 되었나?
  bool hasSaved = false; // 로또 번호가 [저장] 되었나?
  bool showLottie = false;

  String userName = '';

  final Uri _url = Uri.parse('https://www.instagram.com/');

  final PageController _controller = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    _getNumbers();
    _getUserName(); // 사용자 이름 불러오기
  }

  Future<void> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User';
    });
  }

  // 2. (set) 로또 번호 저장 함수
  Future<void> _setNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStrings = savedNumbers.map((list) => list.join(',')).toList();
    await prefs.setStringList('savedNumbers', savedStrings);
  }

  // 3. (get) 저장된 로또 번호 불러오는 함수
  Future<void> _getNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStrings = prefs.getStringList('savedNumbers') ?? [];
    setState(() {
      savedNumbers = savedStrings
          .map((str) => str.split(',').map(int.parse).toList())
          .toList();
    });
  }

  // 4. 생성된 번호 저장 함수
  void saveGeneratedNumbers() {
    if (hasSaved) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('경고'),
            content: const Text('생성된 번호를 이미 저장했습니다. 다시 번호를 생성해 주세요.'),
            actions: [
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      savedNumbers.add(List.from(lottoNumbers));
      _setNumbers();
      hasSaved = true;
    });

    Fluttertoast.showToast(
      msg: "번호가 저장되었습니다.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //
  // 랜덤 숫자 출력 함수

  // void generateLottoNumbers() {
  //   setState(() {
  //     lottoNumbers.clear();
  //     hasSaved = false;
  //     while (lottoNumbers.length < 7) {
  //       int randomNumber = Random().nextInt(45) + 1;
  //       if (!lottoNumbers.contains(randomNumber)) {
  //         lottoNumbers.add(randomNumber);
  //       }
  //     }
  //     lottoNumbers.sort();
  //   });
  // }

  void generateLottoNumbers() {
    setState(() {
      lottoNumbers.clear();
      hasSaved = false;
      showLottie = true; // Lottie 애니메이션 표시

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          while (lottoNumbers.length < 7) {
            int randomNumber = Random().nextInt(45) + 1;
            if (!lottoNumbers.contains(randomNumber)) {
              lottoNumbers.add(randomNumber);
            }
          }
          lottoNumbers.sort();
          showLottie = false; // 애니메이션이 끝나면 false로 설정
        });
      });
    });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset(
              'lib/assets/images/logo.svg',
              semanticsLabel: 'Logo',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 17),
            const Text('Lucky Vicky'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    '  Event',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _launchUrl,
                    icon: Image.asset(
                      'lib/assets/images/instagram.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: PageView(
                  controller: _controller,
                  children: [
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 8),
                    //   decoration: BoxDecoration(
                    //     color: const Color.fromARGB(40, 255, 255, 255),
                    //     borderRadius: BorderRadius.circular(30),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Lottie.asset(
                    //             'lib/assets/images/chicken3.json',
                    //             width: 90,
                    //             height: 90,
                    //           ),
                    //           const Text(
                    //             '1,2,3 등 = 치킨 기프티콘',
                    //             style: TextStyle(
                    //               fontSize: 22,
                    //               fontWeight: FontWeight.bold,
                    //               color: Color.fromARGB(255, 255, 244, 149),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           const Text(
                    //             ' 4,5 등 = 스벅 기프티콘',
                    //             style: TextStyle(
                    //               fontSize: 25,
                    //               fontWeight: FontWeight.bold,
                    //               color: Color.fromARGB(255, 255, 230, 0),
                    //             ),
                    //           ),
                    //           Lottie.asset(
                    //             'lib/assets/images/coffee.json',
                    //             width: 80,
                    //             height: 80,
                    //           ),
                    //         ],
                    //       ),
                    //       const Text('자세한 내용은 인스타 확인')
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 255, 255, 255),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '  Motivate You    ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          SentencePage(),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 255, 255, 255),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Take the Gift !!!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 230, 0),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Lottie.asset(
                            'lib/assets/images/give_money.json',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SmoothPageIndicator(
                controller: _controller,
                count: 2,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 4,
                ),
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  Text(
                    '  Hi, $userName',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(40, 255, 255, 255),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      '$userName\'s',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Text(
                      '번호 생성하기',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: generateLottoNumbers,
                      child: const Text('번호 생성'),
                    ),
                    const SizedBox(height: 60),
                    if (lottoNumbers.isEmpty) ...[
                      const Text('버튼을 클릭하시면, 번호가 나옵니다.'),
                      Lottie.asset(
                        // 'lib/assets/images/Animation - 1722424630039.json',
                        'lib/assets/images/gift_box.json',
                        repeat: true,
                        // reverse: true,
                      )
                    ] else ...[
                      LottoNumberBalls(numbers: lottoNumbers),
                      const SizedBox(height: 23),
                      ElevatedButton(
                          onPressed: saveGeneratedNumbers,
                          child: const Text('저장하기'))
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              // const SizedBox(height: 35),
              // const Row(
              //   children: [
              //     Text(
              //       '  오늘의 운세 체크',
              //       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 10),
              // Container(
              //   height: 100,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: const Color.fromARGB(40, 255, 255, 255),
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   child: Column(
              //     children: [
              //       const SizedBox(height: 12),
              //       const Text('Testing Lucky Day'),
              //       const SizedBox(height: 15),
              //       ElevatedButton(
              //         onPressed: () {},
              //         child: const Text('Click'),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
