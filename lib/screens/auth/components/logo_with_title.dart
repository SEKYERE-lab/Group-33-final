import 'package:flutter/material.dart';

class LogoWithTitle extends StatelessWidget {
  final String title;
  final String subText;
  final List<Widget> children;

  const LogoWithTitle({
    Key? key,
    required this.title,
    required this.subText,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Your logo widget here
        const FlutterLogo(size: 100),
        
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        Text(
          subText,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }
}
