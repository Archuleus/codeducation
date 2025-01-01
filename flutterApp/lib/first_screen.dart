import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // FadeInUp için animate_do paketini eklemeyi unutmayın

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  // Test soruları ve cevapları
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "Bir program, 1 ile 100 arasındaki tüm tek sayıların toplamını hesaplıyor. Bu program için doğru algoritma nedir?",
      "options": [
        "A) Başla -> 1 ile 100 arasındaki sayıları listele -> Tümünü topla -> Sonucu yazdır -> Bitir ",
        "B) Başla -> 1 ile 100 arasındaki tek sayıları listele -> Döngü ile tek sayıları topla -> Sonucu yazdır -> Bitir",
        "C) Başla -> 1 ile 100 arasındaki çift sayıları listele -> Tümünü topla -> Sonucu yazdır -> Bitir",
        "D) Başla -> 1 ile 100 arasındaki tüm sayıları topla -> Çift olanları çıkar -> Sonucu yazdır -> Bitir",
        "E) 100’den geriye doğru say ve hepsini topla"
      ],
      "correct": 1, // Doğru cevabın indeksini belirtir (0 tabanlı)
    },
    {
      "question": "Bir program, 2 boyutlu bir matrisin her satırındaki sayıların toplamını buluyor. Bu programın akışında hangi döngü yapısı daha uygundur?",
      "options": [
        "A) Tek bir for döngüsü ile satırları sırayla gezmek",
        "B) İç içe for döngüleri kullanarak her elemanı sırayla toplamak",
        "C) Sadece bir while döngüsü ile matrisin tüm elemanlarını toplamak",
        "D) İlk satırı topla, diğerlerini göz ardı et",
        "E) Matrisin tüm elemanlarını bir listeye çevir ve listeyi sırala"
      ],
      "correct": 1,
    },
  ];

  void onStarPressed(BuildContext context, int index) {
    if (index == 3) {
      // Üçüncü yıldız eşleştirme sorusu için.
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MatchScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenQuestion(
            questionData: _questions[index - 1],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Üstteki görsel
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/aliyeat.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Yıldız butonları ve içerik
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.zero,
                              border: Border.all(
                                color: Color.fromRGBO(143, 148, 251, 1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(3, (index) {
                                // İlk 3 yıldızı oluştur.
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                                  child: ElevatedButton(
                                    onPressed: () => onStarPressed(context, index + 1),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(), // Butonu yuvarlak yapmak için
                                      padding: EdgeInsets.all(20), // Buton boyutu
                                      backgroundColor: Colors.white, // Butonun arka plan rengi
                                    ),
                                    child: Icon(
                                      Icons.star, // Yıldız simgesi
                                      size: 30,
                                      color: Colors.purple, // Yıldız rengi mor
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenQuestion extends StatelessWidget {
  final Map<String, dynamic> questionData;

  FullScreenQuestion({required this.questionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Soru
              Text(
                questionData["question"],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Şıklar
              ...List.generate(questionData["options"].length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (index == questionData["correct"]) {
                        // Doğru cevap
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Doğru!"),
                              content: Text("Tebrikler, doğru cevabı seçtiniz."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Tamam"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Yanlış cevap
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Yanlış!"),
                              content: Text("Maalesef, yanlış cevap."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Tamam"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      questionData["options"][index],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final leftTerms = ['int', 'float', 'bool', 'string'];
  final rightTerms = ['tam sayı', 'ondalıklı sayı', 'mantıksal kapı', 'karakter'];
  final correctPairs = {
    'int': 'tam sayı',
    'float': 'ondalıklı sayı',
    'bool': 'mantıksal kapı',
    'string': 'karakter',
  };

  String? selectedLeft;
  String? selectedRight;

  void checkMatch() {
    if (selectedLeft != null && selectedRight != null) {
      if (correctPairs[selectedLeft] == selectedRight) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Doğru Eşleşme!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Yanlış Eşleşme!")),
        );
      }
      setState(() {
        selectedLeft = null;
        selectedRight = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Eşleştirme Sorusu")),
      body: Row(
        children: [
          // Sol kolon
          Expanded(
            child: ListView.builder(
              itemCount: leftTerms.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLeft = leftTerms[index];
                    });
                    checkMatch();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: selectedLeft == leftTerms[index]
                        ? Colors.blue
                        : Colors.grey[200],
                    margin: EdgeInsets.all(10),
                    child: Text(
                      leftTerms[index],
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          // Sağ kolon
          Expanded(
            child: ListView.builder(
              itemCount: rightTerms.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRight = rightTerms[index];
                    });
                    checkMatch();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: selectedRight == rightTerms[index]
                        ? Colors.green
                        : Colors.grey[200],
                    margin: EdgeInsets.all(10),
                    child: Text(
                      rightTerms[index],
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}