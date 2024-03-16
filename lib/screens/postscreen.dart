import 'package:flutter/material.dart';
import '../data.dart';
import '../models/api_response.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import 'login.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retriveposts() async {
    userId = await getId();
    ApiResponse response = await getPosts();
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retriveposts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? const Center(child:CircularProgressIndicator()) : ListView.builder(
            itemCount: _postList.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = _postList[index];
              return Container(
                padding:const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                             Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                    image: post.user!.image != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                "${post.user!.image}"))
                                        : null,
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.blue
                                        ),
                              ),
                              box,
                              Text('${post.body}')
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            });
  }
}
