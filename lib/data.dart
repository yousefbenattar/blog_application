import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const baseURL = 'http://192.168.1.2/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const postURL = '$baseURL/post'; //create post
const updatepost = '$baseURL/update'; //update post
const deletepost = '$baseURL/delete'; //update post
const commentsURL = '$baseURL/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? "";
}

// get user id
Future<int> getId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('token') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null ;
  return base64Encode(file.readAsBytesSync());
}

SizedBox box = const SizedBox(height: 10);
SizedBox meduimbox = const SizedBox(height: 20);

InputDecoration kdecoration(String label) {
  return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      labelText: label,
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 5, color: Colors.black)));
}

TextButton ktextButtom(String label, Function onpressed) {
  return TextButton(
    onPressed: () => onpressed(),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(vertical: 15))),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white,fontSize: 25),
    ),
  );
}

Row hintrow (String text ,String label,Function onpressed){
  return  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      const SizedBox(width: 5),
      GestureDetector(
        onTap: () => onpressed(),
        child: Text(label,style:const TextStyle(color: Colors.blue,),)),
  ],);
}