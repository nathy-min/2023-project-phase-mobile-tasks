import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Layout1',
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(0, 0, 0, 1), width: 3,),
                image: DecorationImage(
                  image: AssetImage('assets/images/p1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
              child: SizedBox(  
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Button'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 117, 25, 13)
                  )
                ),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
