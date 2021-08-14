import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'homescreen.dart';

import 'package:movie_bucket/database/database_manager.dart';
import 'package:movie_bucket/database/movies.dart';

class Addmovie extends StatefulWidget {
  const Addmovie({Key? key}) : super(key: key);

  @override
  _AddmovieState createState() => _AddmovieState();
}

class _AddmovieState extends State<Addmovie> {
  XFile? kImage;
  TextEditingController titleController = new TextEditingController();
  TextEditingController directorTextController = new TextEditingController();

  void imagePicker() async {
    XFile? pickedImage;
    final ImagePicker _picker = ImagePicker();
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      kImage = pickedImage;
    });
  }

  void addMovie(String kImageString, String kDirector, String kTitle) async {
    await DatabaseManager.instance.addMovies(
        new movies(title: kTitle, director: kDirector, image: kImageString));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 0,
        ),
        title: Center(
          child: Row(
            children: [
              Text('Add a Movie'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      imagePicker();
                    },
                    child: Container(
                      width: size.width / 2,
                      height: size.height / 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: kImage != null
                          ? Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                        File(
                                          kImage!.path,
                                        ),
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : Center(
                              child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: titleController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'Title?', border: InputBorder.none),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: directorTextController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'Director?', border: InputBorder.none),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF2935A7),
                        borderRadius: BorderRadius.circular(size.width * 0.04)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width / 4,
                          vertical: size.width * 0.01),
                      child: TextButton(
                        onPressed: () {
                          if (kImage != null &&
                              titleController.text.isNotEmpty &&
                              directorTextController.text.isNotEmpty) {
                            String imageAsString = base64Encode(
                                File(kImage!.path).readAsBytesSync());

                            addMovie(imageAsString, directorTextController.text,
                                titleController.text);
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                              return Homescreen();
                            }));
                          } else {
                            Fluttertoast.showToast(
                                msg: "All fields are necessary",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text(
                          'Add Movie',
                          style: TextStyle(
                              color: Colors.white, fontSize: size.width * 0.04),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
