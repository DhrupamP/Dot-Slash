import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'fileadd.dart';
final FirebaseAuth _auth=FirebaseAuth.instance;



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  void _register() async {
      final UserCredential user = (await
      _auth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      ));
    if(user.user!=null)
    {
        _login();
    }
  }
  void _login() async {
      final UserCredential user = (await
      _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      ));
      if(user.user!=null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Filee();}));
      }
  }
  String username ="";
  String password=" ";
  bool _obscureText1 = true;
  final _formKey1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.2,),
            Form(
                key: _formKey1,
                child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text('Welcome OnBoard!',style: TextStyle(
                          fontSize: 25,
                          fontWeight:FontWeight.bold
                      ),),
                      SizedBox(height: 25),
                      TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'This Field is Required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Enter Email Address',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40)),),
                          ),
                          onChanged: (val)
                          {
                            setState(() {username=val;});
                          }
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Enter Password',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40)),),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                              child: Icon(
                                _obscureText1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          obscureText: _obscureText1,
                          onChanged: (val)
                          {
                            setState(() {password=val;});
                          }
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width-30,
                        height:50,
                        onPressed: () {
                          hideKeyboard(context);
                          if(_formKey1.currentState!.validate()) {

                          }},
                        elevation: 4,
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Align(
                        alignment: Alignment(0, 0.8),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: ElevatedButton(
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  _register();
                                })),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.red,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Login();}));
                        },
                        child: Text('Already have a account? LogIn'),
                      ),
                    ]
                )
            ),
          ],
        ),
      ),
    );
  }
}

void hideKeyboard(BuildContext context){
  FocusScope.of(context).requestFocus(FocusNode());
}



