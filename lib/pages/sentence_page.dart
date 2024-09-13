import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SentencePage extends StatefulWidget {
  const SentencePage({super.key});

  @override
  State<SentencePage> createState() => _SentencePageState();
}

class _SentencePageState extends State<SentencePage> {
  final List<String> sentences = [
    // "인생은 한방이다.\n\n- 김지홍 -",
    // "가즈아아아아ㅏㅏ~~~\n\n- 미상 -",
    // "너무 많이 응원하지 마라.\n다시 올꺼니까.\n\n- 대상혁 -",
    // "지구 숏 아니냐 이거..?\n\n- 랄X -",
    // "많이 울어...\n어른이 되면...\n속으로 울어야 돼\n\n- 미상 -",
    "가지가지 나뭇가지 한다.\n\n- 페이커 -",
    // "통계적으로 세 사람이 길을 걷는다면\n그 중 한사람은 게이이다.\n\n- 홍X천 -",
    // "아이유가 뭐하는 아이유?\n\n- 페이커 -",
    // "큰 나무는 바람을 많이 맞는 법입니다.\n\n- P.A.K.A -",
    // "자신의 인생을 남하고 비교하면서\n현타 오는 게 진짜 한심한거다.\n그 시간이 가장 아깝다.\n그시간에 뭐라도 해라.\n\n- 괴물X -",
    // "남탓을 할 수도 있다.\n우리는 남이니까.\n\n- 랄X -",
    // "낭만은 낭비를 해야한다고 봐요.\n효율적인 것과는 거리가 멀다고 생각합니다.\n낭만이란 그런거예요.\n\n- 김풍 -",
    // "7명의 CEO를 찾아가\n성공의 비결을 물어봤고,\n놀랍게도 모두가 똑같은 말을 했다.\n\n\"내 집엔 어떻게 들어온거냐\"\n\n- 작가 \"미상\" -",
    // "보이스피싱범은 최소한 너보단 더 성실하다.\n\n- 미상 -",
    // "월 200 벌려고 대학에\n4년의 시간과 수천을 쓰는 사람이 있다.\n\n- 미상 -",
    // "성공의 반대는 실패가 아니다.\n도전하지 않는 것이다.\n\n- 미상 -",
    // "세상에서 가장 불행한 사람은\n목표는 높은데 실천을 안하는 사람이다.\n이 사람은 평생 고통스럽게 살 것이다.\n\n- 강사. 정승제 -",
    // "노력은 내가 하고싶을 때만 하는 것이 아니다.\n하기 싫을 때도 해야 결과가 만들어진다.\n\n- 작가 \"미상\" -",
    // "인간이 5명이나 모이면\n반드시 한명은 쓰레기가 된다.\n\n- 잇칸자카 지로보 -",
    // "너 그렇게 흐리멍텅하게 하면 안 돼\n너가 여기까지 배우러 온 이유를 생각해봐 \n\n- 부산대장. 김건우 -",
    // "\"냐오오오오ㅗㅇㅇ옹\"\n\n- 고양이 -",
    // "이봐, 해봤어?\n\n- 정주영 - "
  ];

  late String todaySentence;

  @override
  void initState() {
    super.initState();
    int dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    todaySentence = sentences[dayOfYear % sentences.length];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          todaySentence,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
