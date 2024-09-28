import 'package:flutter/material.dart';
import 'package:offlinedatabase/Screen/Home_screen.dart';

void main(){
  runApp(myapp());
}


class myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:const ColorScheme.dark(
          primary:  Color.fromARGB(255, 0, 255, 200),
          background:  Color.fromARGB(90, 10, 97, 82),
          secondary:  Color.fromARGB(255, 44, 136, 116),
          primaryContainer:  Color.fromARGB(255, 6, 148, 158),
          onPrimary:  Color.fromARGB(255, 167, 241, 225),
          onBackground: Color.fromARGB(255, 221, 255, 248),
          error: Color.fromARGB(255, 73, 97, 100)
        )
        
      ) ,
     home: const Scaffold(
      body: HomeScreen()
     ),
    );
  }
}