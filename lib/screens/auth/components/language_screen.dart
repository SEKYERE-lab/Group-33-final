import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English'; // Default selected language

  final List<Language> _languages = [
    Language(name: 'English', code: 'en', flag: 'assets/flags/us.svg'),
    Language(name: 'Spanish', code: 'es', flag: 'assets/flags/es.svg'),
    Language(name: 'French', code: 'fr', flag: 'assets/flags/fr.svg'),
    Language(name: 'German', code: 'de', flag: 'assets/flags/de.svg'),
    Language(name: 'Chinese', code: 'zh', flag: 'assets/flags/cn.svg'),
    Language(name: 'Japanese', code: 'ja', flag: 'assets/flags/jp.svg'),
    Language(name: 'Korean', code: 'ko', flag: 'assets/flags/kr.svg'),
    Language(name: 'Arabic', code: 'ar', flag: 'assets/flags/sa.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Choose Your Language'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.language,
                    size: 80,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return LanguageCard(
                    language: _languages[index],
                    isSelected: _selectedLanguage == _languages[index].name,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = _languages[index].name;
                      });
                    },
                  );
                },
                childCount: _languages.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Apply selected language
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to $_selectedLanguage'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        },
        icon: const Icon(Icons.check),
        label: const Text('Apply'),
      ),
    );
  }
}

class LanguageCard extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    Key? key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                language.flag,
                width: 48,
                height: 48,
              ),
              const SizedBox(height: 8),
              Text(
                language.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Language {
  final String name;
  final String code;
  final String flag;

  Language({required this.name, required this.code, required this.flag});
}
