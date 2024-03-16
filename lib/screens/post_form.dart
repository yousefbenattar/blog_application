import 'dart:io';
import 'package:blog_application/models/api_response.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data.dart';
import '../services/post_service.dart';
import 'login.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  File? _imageFile ;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  void _createPost() async {
    String? image = _imageFile ==  null ? null : getStringImage(_imageFile);
    ApiResponse response = await createpost(_controller.text, image);

    if(response.error ==  null) {
      Navigator.of(context).pop();
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add new post'),),
       body: _loading ? const Center(child:  CircularProgressIndicator()) : ListView(
        children: [
        Container(
        decoration: BoxDecoration(
        image: _imageFile == null ? null : DecorationImage(image: FileImage(_imageFile ?? File('')),fit: BoxFit.cover)
        ),
        width: MediaQuery.of(context).size.width,
        height: 200,child: IconButton(
        onPressed: (){getImage();},icon:const Icon(Icons.image,size: 50,)),),
        Form(
        key: _formkey,
        child: Padding(padding:const EdgeInsets.all(10),
        child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: 9,
        validator :( value) => value!.isEmpty ? 'Post body required' : null ,
        decoration:const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2)),
        hintText: 'post body',hintStyle: TextStyle(fontSize: 25)),),)),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ktextButtom("Post", () {
        if (_formkey.currentState!.validate()) {
        setState(() {
        _loading = !_loading;
        _createPost();
        });}}),)],),);}}
