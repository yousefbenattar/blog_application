import 'dart:convert';

import 'package:blog_application/data.dart';
import 'package:blog_application/models/api_response.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

// login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {"Accept": "application/json"},
        body: {"email": email, "password": password});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)[0]];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)["message"];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
// register
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL),
        headers: {"Accept": "application/json"},
        body: {
          "name" : name,
          "email": email,
          "password": password,
          "password_confirmation": password,
          });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)[0]];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}


Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final token = await getToken();
    final response = await http.get(
    Uri.parse(userURL),
    headers: {
      "Accept" : "application/json",
      "Authorization" : "Bearer $token"
    }
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}