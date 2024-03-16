import 'package:blog_application/models/api_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloading = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailControllert = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void _loginUser () async {
     ApiResponse response =await login(emailControllert.text,passwordController.text);
     if(response.error==null)
     {
      _savedandredirectedtohome(response.data as User);
     }
     else{
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
     }
  }
  void _savedandredirectedtohome(User user) async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", user.token ?? "");
    await pref.setInt("userId", user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Home()), (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: SafeArea(
            child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "Invalid EmailAddress" : null,
                  controller: emailControllert,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kdecoration('email')),
              box,
              TextFormField(
                  obscureText: true,
                  validator: (value) =>
                      value!.length < 6 ? "required at least 6 letters" : null,
                  controller: passwordController,
                  decoration: kdecoration('password')),
              box,
              isloading ? const Center(child: CircularProgressIndicator(),) :
              ktextButtom("Login", () {
                if(formkey.currentState!.validate()){
                  setState(() {
                    isloading = true ;
                    _loginUser ();
                  });
                }
              }),
              box,
              hintrow("Dont have an account ?", "Sign Up", () {
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Register()), (route) => false);
              }),
            ],
          ),
        )),
      ),
    );
  }
}
