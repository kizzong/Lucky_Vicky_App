import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
import 'package:my_lotto_app/lotto_number_balls.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'sentence_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 1. 기기 안에 있는 고정 메모리에 저장된 번호들
  List<List<int>> savedNumbers = [];

  String _userName = "";

  @override
  void initState() {
    super.initState();
    _getNumbers();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "";
    });
  }

  Future<void> _saveUserName(String newUserName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = newUserName;
    });
    await prefs.setString('userName', newUserName);
  }

  void _showEditNameDialog() {
    TextEditingController nameController =
        TextEditingController(text: _userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter your name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveUserName(nameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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

  // 번호 삭제 함수
  void _deleteNumberSet(int index) {
    setState(() {
      savedNumbers.removeAt(index);
      _setNumbers(); // 업데이트된 번호 저장
    });
  }

  // 번호 추가 함수
  void _addNumbers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<TextEditingController> controllers =
            List.generate(7, (index) => TextEditingController());

        return AlertDialog(
          title: const Text('번호 입력'),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: SizedBox(
                    width: 40,
                    child: TextField(
                      controller: controllers[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // 숫자만 입력
                      decoration: InputDecoration(labelText: '${index + 1}'),
                    ),
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                List<int> manualNumbers = [];
                bool isValid = true;
                Set<int> uniqueNumbers = {};

                for (var controller in controllers) {
                  if (controller.text.isNotEmpty) {
                    int number = int.parse(controller.text);
                    if (number < 1 ||
                        number > 45 ||
                        uniqueNumbers.contains(number)) {
                      isValid = false;
                      break;
                    }
                    uniqueNumbers.add(number);
                    manualNumbers.add(number);
                  }
                }

                if (manualNumbers.length != 7 || !isValid) {
                  // 경고 메시지 표시
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('경고'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('- 1부터 45 사이의 번호를 입력했는지 확인해주세요.'),
                            Text('- 중복된 숫자가 있는지 확인해 주세요.')
                          ],
                        ),
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
                } else {
                  manualNumbers.sort(); // 번호 정렬
                  setState(() {
                    savedNumbers.add(manualNumbers);
                    _setNumbers(); // 저장된 번호를 업데이트
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('  Profile'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    '  $_userName 님',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _showEditNameDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(20, 255, 255, 255),
                    ),
                    child: const Text('프로필 수정'),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const SizedBox(height: 10),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 8),
              //   decoration: BoxDecoration(
              //     color: const Color.fromARGB(40, 255, 255, 255),
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   width: double.infinity,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const SizedBox(height: 20),
              //       const Text(
              //           '당첨금 확인하dㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ기'),
              //       const SizedBox(height: 50),
              //       IconButton(
              //         onPressed: () {},
              //         icon: Image.asset('lib/assets/images/qrcode.json'),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(height: 35),
              Row(
                children: [
                  const Text(
                    '  구매할 번호',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: _addNumbers,
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 290,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(40, 255, 255, 255),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(15),
                // 저장한 번호 불러오는 코드
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (savedNumbers.isEmpty)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('저장된 번호가 없습니다.'),
                        ],
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true, // 내부 ListView 사용 시 필요
                          // physics:
                          //     const NeverScrollableScrollPhysics(), // 스크롤 방지
                          itemCount: savedNumbers.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '   ${index + 1} 번째 번호',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteNumberSet(index);
                                      },
                                    ),
                                  ],
                                ),
                                LottoNumberBalls(numbers: savedNumbers[index]),
                                const SizedBox(height: 10), // 간격 조정
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
