import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rider/AllScreens/registerationScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";

  TextEditingController passwordtextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width:390.0,
                height: 350.0,
                alignment: Alignment.center,
              ),


              SizedBox(height: 15.0,),
              Text(
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),



              Padding(
                  padding: EdgeInsets.all(20.0),
                  child:Column(
                    children: [

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: emailtextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style:TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: passwordtextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style:TextStyle(fontSize: 14.0),
                      ),


                      SizedBox(height:20.0,),
                      RaisedButton(
                        color:Colors.yellow,
                        textColor:Colors.white,
                        child:Container(
                          height:50.0,
                          child:Center(
                            child:Text(
                              "Login",
                              style:TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Brand Bold",
                              )
                            )
                          )
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        onPressed:(){
                          if(!emailtextEditingController.text.contains("@")){
                            displayToastMessage("Email is not Valid", context);
                          }else if(passwordtextEditingController.text.isEmpty){
                            displayToastMessage("Password is mandatory", context);
                          }else{
                            loginAndAuthenticateUser(context);
                          }
                        },
                      )

                    ],
                  )
              ),

              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                child:Text(
                  "Do not have an Account? Register Here.",
                ),
              )






            ],
          ),
        ),
      )
    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async{
    final User? user = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailtextEditingController.text,
        password: passwordtextEditingController.text
    ).catchError((errMsg){
      displayToastMessage("Error: "+errMsg.toString(), context);
    })).user;

    //user created
    if(user != null){
      usersRef.child(user.uid).once().then((DataSnapshot snap){
        if(snap.value != null){
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("You are logged in now", context);
        }else{
          _firebaseAuth.signOut();
          displayToastMessage("No record exists for this user. Please create new account", context);
        }
      });
    }else{
      //error occured - display error msg
      displayToastMessage("Error Occured, cannot be signed in ", context);
    }
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
