import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_bucket/database/movies.dart';
import 'package:movie_bucket/database/database_manager.dart';
import 'package:movie_bucket/screens/loginscreen.dart';
import 'package:sqflite/sqflite.dart';
import 'addform.dart';
import 'updateform.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  XFile? image;
  List<movies> movieBucket = [];
  void imagePicker() async {
    XFile? pickedImage;
    final ImagePicker _picker = ImagePicker();
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedImage;
    });
  }

  @override
  void initState() {
    initialiseDatabase();

    super.initState();
  }

  void fetchMovies() async {
    List<movies> temp = await DatabaseManager.instance.fetchAllMovies();
    setState(() {
      movieBucket = temp;
    });
  }

  void addMovie() async {
    await DatabaseManager.instance.addMovies(
        new movies(title: 'Moonlight', director: 'Snehdeep', image: 'yeehaw'));
    fetchMovies();
  }

  void deleteMovie(int id) async {
    await DatabaseManager.instance.deleteMovies(id);
    fetchMovies();
  }

  void initialiseDatabase() async {
    Database database = await DatabaseManager.instance.database;
    fetchMovies();
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Selected your movie?'),
            content: new Text('You sure want to close the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  await googleSignIn.signOut();
                  await FirebaseAuth.instance.signOut();
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return Addmovie();
              }));
            },
            child: Icon(Icons.add)),
        body: Container(
          width: size.width,
          height: size.height,
          child: ListView.builder(
              itemCount: movieBucket.length,
              itemBuilder: (BuildContext context, value) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Container(
                    width: size.height / 3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(
                                base64Decode(movieBucket[value].image)),
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken),
                            fit: BoxFit.cover)),
                    child: ListTile(
                      title: Text(
                        movieBucket[value].title.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        movieBucket[value].director.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    new MaterialPageRoute(builder: (context) {
                                  return updateMovie(movie: movieBucket[value]);
                                }));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.green,
                              )),
                          IconButton(
                              onPressed: () {
                                deleteMovie(movieBucket[value].id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[500],
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
