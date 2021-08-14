import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'homescreen.dart';

import 'package:movie_bucket/database/database_manager.dart';
import 'package:movie_bucket/database/movies.dart';

class updateMovie extends StatefulWidget {
  updateMovie({Key? key, required this.movie}) : super(key: key);

  movies movie;

  @override
  _updateMovieState createState() => _updateMovieState(kCurrentMovie: movie);
}

class _updateMovieState extends State<updateMovie> {
  _updateMovieState({required this.kCurrentMovie});
  movies kCurrentMovie;
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

  void updateMovie(String kImageString, String kDirector, String kTitle) async {
    kCurrentMovie.image = kImageString;
    kCurrentMovie.director = kDirector;
    kCurrentMovie.title = kTitle;
    await DatabaseManager.instance.updateMovie(kCurrentMovie);
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
                            : Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: MemoryImage(
                                            base64Decode(kCurrentMovie.image)),
                                        fit: BoxFit.cover)),
                              )),
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
                      controller: titleController..text = kCurrentMovie.title,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
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
                      controller: directorTextController
                        ..text = kCurrentMovie.director,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
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
                          String imageAsString;
                          if (kImage != null) {
                            imageAsString = base64Encode(
                                File(kImage!.path).readAsBytesSync());
                          } else {
                            imageAsString = kCurrentMovie.image;
                          }
                          updateMovie(
                              imageAsString,
                              directorTextController.text,
                              titleController.text);
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                            return Homescreen();
                          }));
                        },
                        child: Text(
                          'Update Fields',
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
