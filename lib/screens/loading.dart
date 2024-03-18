import 'package:blog_application/data.dart';
import 'package:blog_application/models/api_response.dart';
import 'package:blog_application/screens/register.dart';
import 'package:blog_application/services/user_service.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void loadUserInfo () async{
    String token = await getToken();
    if(token == ""){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Login()), (route) => false);
    }
    else  {
      ApiResponse response = await getUserDetail();
      if((response.error == null))
      {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Home()), (route) => false);
      }
      else if (response.error == unauthorized){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Register()), (route) => false);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
      }
    }
  }
  @override
  void initState() {
    loadUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child:const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
