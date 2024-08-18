import 'package:flutter/material.dart';



class CheckImage extends StatelessWidget {
  const CheckImage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Display Example'),
        ),
        body: Center(
          child: Image.asset('assets/images/img_6.jpg'),
        ),
      ),
    );
  }
}
