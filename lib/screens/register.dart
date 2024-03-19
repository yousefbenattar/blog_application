import 'package:blog_application/screens/login.dart';
import 'package:blog_application/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailControllert = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailControllert.text, passwordController.text);
    if (response.error == null) {
      _savedandredirectedtohome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _savedandredirectedtohome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", user.token ?? '');
    await pref.setInt("userId", user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Form(
            key: formkey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Invalid  Name" : null,
                  controller: nameController,
                  decoration: kdecoration("name"),
                ),
                meduimbox,
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? "Invalid EmailAddress" : null,
                  controller: emailControllert,
                  decoration: kdecoration("Email"),
                ),
                meduimbox,
                TextFormField(
                  obscureText: false,
                  validator: (value) =>
                      value!.length < 6 ? "Required at least 6 chars" : null,
                  controller: passwordController,
                  decoration: kdecoration("password"),
                ),
                meduimbox,
                TextFormField(
                  obscureText: false,
                  validator: (value) => value != passwordController.text
                      ? "Confirm password dosent match"
                      : null,
                  controller: passwordConfirmationController,
                  decoration: kdecoration("Confirm password"),
                ),
                box,
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ktextButtom("Register", () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = !loading;
                            _registerUser();
                          });
                        }
                      }),
                meduimbox,
                hintrow("Already have an account ?", "Login", () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                }),
              ],
            )),
      ),
    );
  }
}
