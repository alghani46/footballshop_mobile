import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
// The app root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Shop',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// Home Page Widget
class HomePage extends StatelessWidget {
  const HomePage({super.key});


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Football Shop')),
      body: const SafeArea(
        child: Center(child: ButtonsArea()),
      ),
    );
  }
}

//Button Area Widget
class ButtonsArea extends StatelessWidget {
  const ButtonsArea({super.key});

  //SnackBar function
    void _snack(BuildContext context, String msg) {
    final m = ScaffoldMessenger.of(context);
    m.hideCurrentSnackBar();
    m.showSnackBar(SnackBar(content: Text(msg))); }


    //Create the 3 buttons
    Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        SizedBox(
          width: 200,
          height: 50,
          child: OutlinedButton(
            onPressed: () => _snack(context, 'You have pressed the All Products button'),
            child: const Text('All Products'),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 200,
          height: 50,
          child: OutlinedButton(
            onPressed: () => _snack(context, 'You have pressed the My Products button'),
            child: const Text('My Products'),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 200,
          height: 50,
          child: OutlinedButton(
            onPressed: () => _snack(context, 'You have pressed the Create Products button'),
            child: const Text('Create Product'),
          ),
        ),
      ],
    );
  }
}
