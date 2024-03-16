import 'package:blog_application/data.dart';
import 'package:blog_application/screens/post_form.dart';
import 'package:blog_application/screens/postscreen.dart';
import 'package:blog_application/screens/profile.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Home page'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                  onTap: () {
                    logout().then((value) => Navigator.of(context)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (route) => false));
                  },
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  )),
            )
          ],
        ),
        body: index == 0 ? const PostScreen() : const Profile(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const PostForm()));
          },
          child: const Icon(Icons.add,color: Colors.white,size: 40,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
            onTap: (v) {
              setState(() {
                index = v;
              });
            },
            currentIndex: index,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(label: '', icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: '', icon: Icon(Icons.account_box_rounded))
            ]));
  }
}
