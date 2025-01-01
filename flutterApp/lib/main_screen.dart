import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'avatar_customizer_screen.dart';
import 'points_system.dart';
import 'widgets/language_switch.dart';
import 'services/language_service.dart';
import 'widgets/edu_bot.dart';
import 'services/ai_service.dart';
import 'painters/path_painter.dart';
import 'widgets/level_button.dart';
import 'widgets/chat_message.dart';
import 'widgets/faq_item.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  bool _isChatOpen = false;
  int _selectedIndex = 0;
  double _health = 1.0; // Full health
  late bool _isEnglish;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  int _currentStage = 1;
  final ScrollController _levelScrollController = ScrollController();
  final PageController _stageController = PageController();

  final List<Map<String, String>> stages = [
    {"name": "Başlangıç", "name_en": "Beginner"},
    {"name": "Temel Kavramlar", "name_en": "Basic Concepts"},
    {"name": "Veri Yapıları", "name_en": "Data Structures"},
    {"name": "Algoritmalar", "name_en": "Algorithms"},
    {"name": "Nesne Yönelimli", "name_en": "Object Oriented"},
    {"name": "İleri Seviye", "name_en": "Advanced"},
    {"name": "Web Geliştirme", "name_en": "Web Development"},
    {"name": "Mobil Geliştirme", "name_en": "Mobile Development"},
    {"name": "Veritabanları", "name_en": "Databases"},
    {"name": "API Geliştirme", "name_en": "API Development"},
    {"name": "Güvenlik", "name_en": "Security"},
    {"name": "Test ve Hata Ayıklama", "name_en": "Testing & Debugging"},
    {"name": "DevOps", "name_en": "DevOps"},
    {"name": "Cloud Computing", "name_en": "Cloud Computing"},
    {"name": "Yapay Zeka", "name_en": "Artificial Intelligence"},
    {"name": "Makine Öğrenmesi", "name_en": "Machine Learning"},
    {"name": "Büyük Veri", "name_en": "Big Data"},
    {"name": "Blockchain", "name_en": "Blockchain"},
    {"name": "IoT", "name_en": "IoT"},
    {"name": "Uzman", "name_en": "Expert"}
  ];

  // FAQ questions and answers
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: "Programlama nedir?",
      answer:
          "Programlama, bilgisayara belirli görevleri nasıl yapacağını söyleyen bir dizi talimat (kod) oluşturma sürecidir. Problemleri çözmek, görevleri otomatikleştirmek veya uygulamalar oluşturmak için programlama dilleri kullanılır.",
    ),
    FAQItem(
      question: "Programlamaya nasıl başlarım?",
      answer:
          "Programlamaya başlamak için:\n1. Python gibi başlangıç dostu bir dil seçin\n2. Online kaynakları ve öğreticileri kullanın\n3. Küçük projelerle pratik yapın\n4. Kodlama topluluklarına katılın\n5. Portfolyonuzu oluşturun",
    ),
    FAQItem(
      question: "En popüler programlama dilleri nelerdir?",
      answer:
          "En popüler programlama dilleri:\n1. Python - Başlangıç için ideal, veri bilimi ve yapay zeka için popüler\n2. JavaScript - Web geliştirme için temel dil\n3. Java - Android ve kurumsal yazılımlar için yaygın\n4. C++ - Sistem programlama ve oyun geliştirme için tercih edilen\n5. C# - Windows uygulamaları ve oyun geliştirme için popüler",
    ),
    FAQItem(
      question: "Web geliştirme nedir?",
      answer:
          "Web geliştirme, internet siteleri ve web uygulamaları oluşturma sürecidir. Frontend (kullanıcı arayüzü) ve backend (sunucu tarafı) olmak üzere iki ana bölümden oluşur. HTML, CSS ve JavaScript temel web teknolojileridir.",
    ),
    FAQItem(
      question: "Mobil uygulama geliştirme nedir?",
      answer:
          "Mobil uygulama geliştirme, akıllı telefonlar ve tabletler için yazılım oluşturma sürecidir. Android için Java/Kotlin, iOS için Swift/Objective-C kullanılır. Flutter ve React Native gibi cross-platform araçlarla tek kodla birden fazla platforma uygulama geliştirilebilir.",
    ),
    FAQItem(
      question: "Yapay zeka ve makine öğrenimi nedir?",
      answer:
          "Yapay zeka, bilgisayarların insan gibi düşünme ve öğrenme yeteneği kazanmasını sağlayan teknolojidir. Makine öğrenimi ise yapay zekanın bir alt dalı olup, bilgisayarların verilerden öğrenmesini sağlayan yöntemler bütünüdür.",
    ),
    FAQItem(
      question: "Veri yapıları neden önemlidir?",
      answer:
          "Veri yapıları, verileri organize etme ve depolama yöntemleridir. Doğru veri yapısı seçimi, programın performansını ve verimliliğini önemli ölçüde etkiler. Diziler, bağlı listeler, ağaçlar ve hash tabloları temel veri yapılarıdır.",
    ),
    FAQItem(
      question: "Algoritma nedir?",
      answer:
          "Algoritma, bir problemi çözmek için adım adım izlenen yol veya yöntemdir. İyi bir algoritma, problemi en verimli şekilde çözer ve minimum kaynak kullanır. Sıralama, arama ve optimizasyon algoritmaları en yaygın örneklerdir.",
    ),
  ];

  late AnimationController _drawerAnimationController;
  late Animation<double> _healthAnimation;
  late AIService _aiService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _initializeAIService();

    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _healthAnimation = Tween<double>(
      begin: 1.0,
      end: _health,
    ).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    // Start with full health
    _health = 1.0;
    _levelScrollController.addListener(_onScroll);
    _stageController.addListener(_onPageScroll);
  }

  Future<void> _loadLanguagePreference() async {
    final languageService = await LanguageService.getInstance();
    setState(() {
      _isEnglish = languageService.isEnglish;
    });
  }

  Future<void> _initializeAIService() async {
    _aiService = await AIService.getInstance();
    setState(() {
      _isInitialized = true;
    });
  }

  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;

      _isDrawerOpen
          ? _drawerAnimationController.forward()
          : _drawerAnimationController.reverse();
    });
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  void _onScroll() {
    final scrollPosition = _levelScrollController.position.pixels;
    final newStage = (scrollPosition / 500).floor() + 1;
    if (newStage != _currentStage && newStage <= 20 && newStage > 0) {
      setState(() {
        _currentStage = newStage;
      });
    }
  }

  void _onPageScroll() {
    if (_stageController.hasClients) {
      int newStage = (_stageController.page?.round() ?? 0) + 1;
      if (newStage != _currentStage && newStage <= 20 && newStage > 0) {
        setState(() {
          _currentStage = newStage;
        });
      }
    }
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    _chatController.dispose();
    _scrollController.dispose();
    _levelScrollController.dispose();
    _stageController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _chatController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Add a small delay before bot starts typing
    await Future.delayed(Duration(milliseconds: 500));

    try {
      // Show typing indicator
      setState(() {
        _isTyping = true;
      });

      // Get response from AI service with artificial delay
      final response = await Future.delayed(
        Duration(seconds: 1),
        () => _aiService.generateResponse(
          text,
          language: _isEnglish ? 'en' : 'tr',
        ),
      );

      if (mounted) {
        // Hide typing indicator and show response
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: response,
            isUser: false,
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: _isEnglish
                ? "Sorry, I couldn't process your request. Please try again."
                : "Üzgünüm, isteğinizi işleyemedim. Lütfen tekrar deneyin.",
            isUser: false,
          ));
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/bg_codelingo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Stages PageView
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                bottom: 0,
                child: PageView.builder(
                  controller: _stageController,
                  itemCount: stages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Path connector lines
                          CustomPaint(
                            painter: PathPainter(),
                          ),

                          // Level buttons - Original positions
                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.5 - 40,
                            top: 20,
                            child: LevelButton(
                              icon: Icons.star,
                              level: "${index * 5 + 1}",
                              isCompleted: true,
                              isActive: true,
                              isEnglish: _isEnglish,
                            ),
                          ),

                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.2,
                            top: 110,
                            child: LevelButton(
                              icon: Icons.fitness_center,
                              level: "${index * 5 + 2}",
                              isCompleted: false,
                              isActive: true,
                              isEnglish: _isEnglish,
                            ),
                          ),

                          Positioned(
                            right: MediaQuery.of(context).size.width * 0.2,
                            top: 200,
                            child: LevelButton(
                              icon: Icons.fast_forward,
                              level: "${index * 5 + 3}",
                              isCompleted: false,
                              isActive: false,
                              isEnglish: _isEnglish,
                            ),
                          ),

                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.2,
                            top: 290,
                            child: LevelButton(
                              icon: Icons.star_half,
                              level: "${index * 5 + 4}",
                              isCompleted: false,
                              isActive: false,
                              isEnglish: _isEnglish,
                            ),
                          ),

                          Positioned(
                            right: MediaQuery.of(context).size.width * 0.2,
                            top: 380,
                            child: LevelButton(
                              icon: Icons.grid_view,
                              level: "${index * 5 + 5}",
                              isCompleted: false,
                              isActive: false,
                              isEnglish: _isEnglish,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Stage Navigation Buttons
              Positioned(
                left: 16,
                right: 16,
                bottom: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStage > 1)
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          _stageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    if (_currentStage < stages.length)
                      IconButton(
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: () {
                          _stageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Top Bar with Stage Indicator
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  child: Stack(
                    children: [
                      // Main App Bar
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Menu Button with Animation
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: _isDrawerOpen
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: IconButton(
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.menu_close,
                                  progress: _drawerAnimationController,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: toggleDrawer,
                              ),
                            ),

                            // Modern Animated Health Bar
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Glowing Background
                                    Container(
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Animated Health Bar
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 1500),
                                      curve: Curves.easeInOut,
                                      height: 16,
                                      width: MediaQuery.of(context).size.width *
                                          0.6 *
                                          _health,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _health > 0.6
                                                ? Color(0xFF4CAF50)
                                                : Color(0xFFFF5252),
                                            _health > 0.6
                                                ? Color(0xFF81C784)
                                                : Color(0xFFFF8A80),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (_health > 0.6
                                                    ? Colors.green
                                                    : Colors.red)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Health Text with Icon
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 14,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "${(_health * 100).toInt()}%",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Avatar Preview
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: FluttermojiCircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stage Indicator
                      Positioned(
                        bottom: 0,
                        left: 50,
                        right: 50,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 24),
                              SizedBox(width: 8),
                              Text(
                                _isEnglish
                                    ? "Stage $_currentStage - ${stages[_currentStage - 1]["name_en"]}"
                                    : "Aşama $_currentStage - ${stages[_currentStage - 1]["name"]}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Chat Bot Button (Bottom Right)
              Positioned(
                right: 16,
                bottom: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: _toggleChat,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isChatOpen ? Icons.close : Icons.smart_toy,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            _isEnglish ? "Ask Edu" : "Edu'ya Sor",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Chat Panel Overlay
              if (_isChatOpen)
                Positioned(
                  top: 120,
                  right: 0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Card(
                    margin: EdgeInsets.all(16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Chat Header
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                _isEnglish
                                    ? "Programming Assistant"
                                    : "Programlama Asistanı",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Chat Messages
                        Expanded(
                          child: Stack(
                            children: [
                              ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.all(16),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  return _messages[index];
                                },
                              ),
                              if (_isTyping)
                                Positioned(
                                  bottom: 0,
                                  left: 16,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF7277E4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.smart_toy,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: List.generate(
                                            3,
                                            (index) => Padding(
                                              padding: EdgeInsets.only(
                                                  right: index < 2 ? 4 : 0),
                                              child: Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // FAQ Section
                        Container(
                          height: 120,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _faqItems.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () => _handleSubmitted(
                                      _faqItems[index].question),
                                  child: Container(
                                    width: 150,
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      _faqItems[index].question,
                                      style: TextStyle(fontSize: 12),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Input Field
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _chatController,
                                  decoration: InputDecoration(
                                    hintText: _isEnglish
                                        ? "Ask me anything..."
                                        : "Bana her şeyi sorabilirsin...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  onSubmitted: _handleSubmitted,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF7277E4),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.send, color: Colors.white),
                                  onPressed: () =>
                                      _handleSubmitted(_chatController.text),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Drawer Background

              if (_isDrawerOpen)
                GestureDetector(
                  onTap: toggleDrawer,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),

              // Modern Animated Drawer

              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _isDrawerOpen ? 0 : -280,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(5, 0),
                      ),
                    ],
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B8FE5), Color(0xFF6A6FB8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AvatarCustomizerScreen(),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        FluttermojiCircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: Color(0xFF7277E4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Points Badge
                                Positioned(
                                  left: -5,
                                  top: -5,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.stars,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${PointsSystem().points}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Player Name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Level 1 Master",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            LanguageSwitch(
                              darkMode: true,
                              onLanguageChanged: (isEnglish) {
                                setState(() {
                                  _isEnglish = isEnglish;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildDrawerItem(
                          Icons.favorite, "Lives", "3", Colors.red),
                      _buildDrawerItem(Icons.local_fire_department,
                          "Daily Streak", "5", Colors.orange),
                      _buildDrawerItem(Icons.stars, "Points",
                          "${PointsSystem().points}", Colors.amber),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          _isEnglish
                              ? "Available Unlocks"
                              : "Kullanılabilir Özellikler",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ...PointsSystem()
                          .getAvailableUnlocks()
                          .take(3)
                          .map((unlock) {
                        final featureName = unlock.key
                            .split('_')
                            .map((word) =>
                                word[0].toUpperCase() + word.substring(1))
                            .join(' ');
                        return UnlockableFeatureCard(
                          featureId: unlock.key,
                          featureName: featureName,
                          cost: unlock.value,
                          isUnlocked: false,
                          onUnlock: () {
                            if (PointsSystem().unlockFeature(unlock.key)) {
                              setState(() {});
                            }
                          },
                        );
                      }).toList(),
                      if (PointsSystem().getAvailableUnlocks().length > 3)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "And ${PointsSystem().getAvailableUnlocks().length - 3} more...",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      _buildDrawerItem(
                          Icons.settings, "Settings", "", Colors.grey),
                      _buildDrawerItem(
                          Icons.info_outline, "About", "", Colors.blue),
                      _buildDrawerItem(Icons.logout, "Logout", "", Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          _isEnglish ? title : _getLocalizedTitle(title),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: value.isNotEmpty
            ? Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: () {
          // Handle drawer item tap
        },
      ),
    );
  }

  String _getLocalizedTitle(String title) {
    switch (title) {
      case 'Lives':
        return 'Canlar';
      case 'Daily Streak':
        return 'Günlük Seri';
      case 'Points':
        return 'Puanlar';
      case 'Available Unlocks':
        return 'Kullanılabilir Özellikler';
      case 'Settings':
        return 'Ayarlar';
      case 'About':
        return 'Hakkında';
      case 'Logout':
        return 'Çıkış Yap';
      default:
        return title;
    }
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF7277E4).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFF7277E4) : Colors.grey,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              _isEnglish ? label : _getLocalizedNavLabel(label),
              style: TextStyle(
                color: isSelected ? Color(0xFF7277E4) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedNavLabel(String label) {
    switch (label) {
      case 'Home':
        return 'Ana Sayfa';
      case 'Progress':
        return 'İlerleme';
      case 'Practice':
        return 'Alıştırma';
      case 'Profile':
        return 'Profil';
      default:
        return label;
    }
  }
}
