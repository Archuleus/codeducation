import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static AIService? _instance;
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  late String _apiKey;
  bool _useLocalResponses = true; // Use local responses instead of API

  // Local response database
  final Map<String, Map<String, Map<String, String>>> _localResponses = {
    'programming': {
      'en': {
        'what is programming':
            'Programming is the process of creating a set of instructions (code) that tell a computer how to perform a task. It involves using programming languages to write code that can solve problems, automate tasks, or create applications.',
        'how to start programming':
            'To start programming:\n1. Choose a beginner-friendly language like Python\n2. Use online resources and tutorials\n3. Practice with small projects\n4. Join coding communities\n5. Build your portfolio',
        'what is python':
            'Python is a high-level, interpreted programming language known for its simplicity and readability. It\'s great for beginners and can be used for web development, data science, AI, and more.',
        'what is javascript':
            'JavaScript is a versatile programming language primarily used for web development. It can run in browsers and on servers, making it essential for creating interactive websites and web applications.',
        'what is java':
            'Java is a popular object-oriented programming language known for its "Write Once, Run Anywhere" capability. It\'s widely used for Android development, enterprise software, and more.',
        'what is variable':
            'A variable is a container for storing data values. It can hold different types of data like numbers, text, or more complex information. Variables help you manage and manipulate data in your programs.',
        'what is function':
            'A function is a reusable block of code that performs a specific task. It helps organize code, makes it more maintainable, and follows the DRY (Don\'t Repeat Yourself) principle.',
        'what is loop':
            'A loop is a programming construct that repeats a block of code multiple times. Common types include for loops and while loops. They\'re useful for automating repetitive tasks.',
        'what is array':
            'An array is a data structure that can store multiple values in a single variable. It\'s like a list where each item can be accessed by its index number.',
        'what is object':
            'An object is a data structure that contains both data (properties) and code (methods). It\'s a fundamental concept in object-oriented programming (OOP).',
      },
      'tr': {
        'programlama nedir':
            'Programlama, bilgisayara belirli görevleri nasıl yapacağını söyleyen bir dizi talimat (kod) oluşturma sürecidir. Problemleri çözmek, görevleri otomatikleştirmek veya uygulamalar oluşturmak için programlama dilleri kullanılır.',
        'programlamaya nasıl başlanır':
            'Programlamaya başlamak için:\n1. Python gibi başlangıç dostu bir dil seçin\n2. Online kaynakları ve öğreticileri kullanın\n3. Küçük projelerle pratik yapın\n4. Kodlama topluluklarına katılın\n5. Portfolyonuzu oluşturun',
        'python nedir':
            'Python, basitliği ve okunabilirliği ile bilinen yüksek seviyeli, yorumlanmış bir programlama dilidir. Başlangıç için mükemmeldir ve web geliştirme, veri bilimi, yapay zeka gibi alanlarda kullanılabilir.',
        'javascript nedir':
            'JavaScript, öncelikle web geliştirme için kullanılan çok yönlü bir programlama dilidir. Tarayıcılarda ve sunucularda çalışabilir, interaktif web siteleri ve web uygulamaları oluşturmak için gereklidir.',
        'java nedir':
            'Java, "Bir Kez Yaz, Her Yerde Çalıştır" özelliği ile bilinen popüler bir nesne yönelimli programlama dilidir. Android geliştirme, kurumsal yazılım ve daha fazlası için yaygın olarak kullanılır.',
        'değişken nedir':
            'Değişken, veri değerlerini depolamak için kullanılan bir kaptır. Sayılar, metin veya daha karmaşık bilgiler gibi farklı veri türlerini tutabilir. Değişkenler, programlarınızda veriyi yönetmenize ve işlemenize yardımcı olur.',
        'fonksiyon nedir':
            'Fonksiyon, belirli bir görevi yerine getiren yeniden kullanılabilir kod bloğudur. Kodu organize etmeye yardımcı olur, daha sürdürülebilir hale getirir ve DRY (Kendini Tekrar Etme) prensibini takip eder.',
        'döngü nedir':
            'Döngü, bir kod bloğunu birden çok kez tekrarlayan bir programlama yapısıdır. For döngüleri ve while döngüleri yaygın türlerdir. Tekrarlayan görevleri otomatikleştirmek için kullanışlıdır.',
        'dizi nedir':
            'Dizi (array), tek bir değişkende birden çok değer saklayabilen bir veri yapısıdır. Her öğeye indeks numarası ile erişilebilen bir liste gibidir.',
        'nesne nedir':
            'Nesne, hem veri (özellikler) hem de kod (metodlar) içeren bir veri yapısıdır. Nesne yönelimli programlamanın (OOP) temel bir kavramıdır.',
        'selamlar':
            'Merhaba! Size programlama konusunda nasıl yardımcı olabilirim?',
        'merhaba':
            'Merhaba! Programlama ile ilgili sorularınızı yanıtlamaya hazırım.',
      }
    }
  };

  AIService._() {
    _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  static Future<AIService> getInstance() async {
    if (_instance == null) {
      try {
        if (!dotenv.isInitialized) {
          await dotenv.load(fileName: ".env");
        }
        _instance = AIService._();
      } catch (e) {
        print('Error initializing AIService: $e');
      }
    }
    return _instance!;
  }

  String _findBestMatch(String question, String language) {
    // Convert question to lowercase and remove punctuation
    question = question.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

    // Get responses for the current language
    final responses =
        _localResponses['programming']?[language == 'en' ? 'en' : 'tr'];

    if (responses == null) {
      return language == 'en'
          ? "Sorry, responses are not available in this language."
          : "Üzgünüm, bu dilde yanıtlar mevcut değil.";
    }

    // Try to find an exact match first
    if (responses.containsKey(question)) {
      return responses[question]!;
    }

    // If no exact match, try to find the best partial match
    String? bestMatch;
    int highestMatchScore = 0;

    for (var key in responses.keys) {
      int matchScore = 0;
      var questionWords = question.split(' ');
      var keyWords = key.split(' ');

      for (var word in questionWords) {
        if (keyWords.contains(word)) {
          matchScore++;
        }
      }

      if (matchScore > highestMatchScore) {
        highestMatchScore = matchScore;
        bestMatch = responses[key];
      }
    }

    if (bestMatch != null) {
      return bestMatch;
    }

    // Default response if no match found
    return language == 'en'
        ? "I'm a programming assistant. Please ask me specific questions about programming concepts, languages, or coding problems."
        : "Ben bir programlama asistanıyım. Lütfen bana programlama kavramları, dilleri veya kodlama sorunları hakkında özel sorular sorun.";
  }

  Future<String> generateResponse(String question,
      {String language = 'en'}) async {
    if (_useLocalResponses) {
      return _findBestMatch(question, language);
    }

    // If local responses are disabled, return a message
    return language == 'en'
        ? "I'm currently operating in offline mode. Please ask me about basic programming concepts."
        : "Şu anda çevrimdışı modda çalışıyorum. Lütfen bana temel programlama kavramları hakkında sorular sorun.";
  }
}
