import 'package:flutter/material.dart';

// 로또 공 위치 설정
class LottoNumberBalls extends StatelessWidget {
  final List<int> numbers;

  const LottoNumberBalls({super.key, required this.numbers});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    // LottoNumberBalls(numbers: lottoNumbers)
    // numbers = lottoNumbers
    // numbers.length = 7
    for (int i = 0; i < numbers.length; i++) {
      children.add(LottoBalls(number: numbers[i]));
      if (i < numbers.length - 2) {
        children.add(const SizedBox(
          width: 8,
          height: 60,
        ));
      }
      if (i == numbers.length - 2) {
        children.add(const SizedBox(width: 4));
        children.add(const Icon(
          Icons.add,
          size: 30,
          color: Color.fromRGBO(331, 333, 338, 1),
        ));
        children.add(const SizedBox(width: 4));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

// 로또 볼 디자인
class LottoBalls extends StatelessWidget {
  final int number;
  const LottoBalls({super.key, required this.number});

  Color _getBallColor(int number) {
    if (number <= 10) return const Color.fromRGBO(233, 185, 71, 1);
    if (number <= 20) return const Color.fromRGBO(76, 113, 167, 1);
    if (number <= 30) return const Color.fromRGBO(205, 86, 41, 1);
    if (number <= 40) return const Color.fromRGBO(146, 149, 163, 1);
    return const Color.fromRGBO(88, 187, 90, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 43,
          height: 48,
          decoration: BoxDecoration(
            color: _getBallColor(number),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(5, 3),
              ),
            ],
            border: Border.all(color: Colors.transparent),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   height: 8,
        //   width: 47,
        // )
      ],
    );
  }
}
