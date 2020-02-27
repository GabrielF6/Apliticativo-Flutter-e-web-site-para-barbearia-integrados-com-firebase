import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:typed_data';
import 'dart:io';
import 'dart:async';

import 'package:flutter_app_sd/AdminScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.orange),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  final userName = TextEditingController();
  final pwdValue = TextEditingController();


  File cachedFile;


  //loading symbol control
   bool loginOrLoading = true;


  // change field
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _pswFocus = FocusNode();



  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {



    return new Scaffold(
      appBar: AppBar(
        title: Text('RusticCut Admin control'),
      ),
      backgroundColor: Colors.black,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        new Image(
          image: new AssetImage("assets/girl.jpeg"),
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),

        new Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                new TextStyle(color: Colors.orange, fontSize: 25.0),
              )),
          isMaterialAppTheme: true,
          child: SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(top: 60.0)),
                new Icon(IconData(59389, fontFamily: 'MaterialIcons'),
                  size: _iconAnimation.value * 140.0,
                ),

                new Container(
                  padding: const EdgeInsets.all(40.0),
                  child: new Form(
                    autovalidate: true,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new TextFormField(
                          controller: userName,
                          decoration: new InputDecoration(
                              labelText: "Email", fillColor: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _nameFocus,
                            onFieldSubmitted: (term){
                              _fieldFocusChange(context, _nameFocus, _pswFocus);
                            }
                        ),
                        new TextFormField(
                          controller: pwdValue,
                          focusNode: _pswFocus,
                          decoration: new InputDecoration(
                            labelText: "Senha",
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value){
                            _pswFocus.unfocus();

                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                        ),
                        loginOrLoading== false?
                        new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),):

                        new MaterialButton(

                          height: 50.0,
                          minWidth: 150.0,
                          color: Colors.orange,
                          splashColor: Colors.orange,
                          textColor: Colors.white,
                          child: Text('Login'),
                          onPressed: () {

                            if(userName.text!= "" && pwdValue.text!= "") {
                              loginOrLoading = false;
                              setState(() { //this exchanges the login button to the loading button and refreshes the state

                              });
                              Login();
                            }



                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ]),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }



  Future <bool> verifyAdmin( String username) async {


    //final RegExp regExp = RegExp('([^?/]*\.(txt))');
    final String fileName = "infoCliente";
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');

    final StorageReference ref = FirebaseStorage.instance.ref().child("admin/"+username+"/info");
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);

    try{

      //TODO: RETURN FALSE IF THE FILE DOENST EXIST, ISNT WORKING YET, BUT AT LEAST INST DOING THE LOGIN EATHER IN CASE THE EMAIL ISNT THE ADMIN EMAIL
    final int byteNumber = (await downloadTask.future).totalByteCount;


    return true;

    }catch(e){
      print(e.message);
      return false;
    }



  }



  Future<void> Login () async{



    String username = userName.text;
    String pwd = pwdValue.text;

    final bool isAdmin = await verifyAdmin(username);

    if (isAdmin) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: username, password: pwd);
        setState(() {//get the login button back to normal
          loginOrLoading = true;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => adminScreen()));
      } catch (e) {
        print(e.message);
      }
    }

    //is reaches here the the email is not from admin

    print("Nao é admin");


  }
}