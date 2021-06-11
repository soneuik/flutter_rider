import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rider/AllScreens/loginScreen.dart';
import 'package:flutter_rider/AllScreens/mainscreen.dart';
import 'package:flutter_rider/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20.0,),
                Image(
                  image: AssetImage("images/logo.png"),
                  width:390.0,
                  height: 350.0,
                  alignment: Alignment.center,
                ),


                SizedBox(height: 15.0,),
                Text(
                  "Register as a Rider",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ),



                Padding(
                    padding: EdgeInsets.all(20.0),
                    child:Column(
                      children: [

                        SizedBox(height: 1.0,),
                        TextField(
                          controller: nametextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Name",
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
                          controller: phonetextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: "Phone",
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
                                      "Create Account",
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
                            if(nametextEditingController.text.length <4 ){
                              displayToastMessage("Name must be at least 3 characters.", context);
                            }else if(!emailtextEditingController.text.contains("@")){
                              displayToastMessage("Email is not Valid", context);
                            }else if(phonetextEditingController.text.isEmpty){
                              displayToastMessage("Phone number is mandatory", context);
                            }else if(passwordtextEditingController.text.length < 6){
                              displayToastMessage("Password must be at least 6 characters", context);
                            }else{
                              registerNewUser(context);
                            }
                          },
                        )

                      ],
                    )
                ),

                FlatButton(
                  onPressed: ()
                  {
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                  },
                  child:Text(
                    "Already have an Account? Login Here.",
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  registerNewUser(BuildContext context) async{

    final User? user = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailtextEditingController.text,
        password: passwordtextEditingController.text
      ).catchError((errMsg){
        displayToastMessage("Error: "+errMsg.toString(), context);
    })).user;

    //user created
    if(user != null){
      //save user info to database
      Map userDataMap = {
        "name": nametextEditingController.text.trim(),
        "email": emailtextEditingController.text.trim(),
        "phone": phonetextEditingController.text.trim(),
      };

      usersRef.child(user.uid).set(userDataMap);
      displayToastMessage("Congratulations, your account has been created", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }else{
      //error occured - display error msg
      displayToastMessage("New user account has not been Created", context);
    }

  }

  void displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }


}
