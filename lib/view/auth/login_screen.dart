import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/viewmodel/auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? errorMessage;
  bool isLoad = false;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        errorMessage = e.message;
        if (e.code == "user-not-found") {
          errorMessage = "Böyle bir kullanıcı bulunamadı";
        }
        // errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        bottomSheet: isLoad
            ? Container(
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Giriş yapılıyor..."),
                  ],
                ),
              )
            : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
              child: const Row(
                children: [
                  Text('Merhaba', style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
                  Text('.', style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.green))
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(
                          labelText: 'Email ya da kullanıcı adınızı giriniz...',
                          labelStyle:
                              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: password,
                      decoration: const InputDecoration(
                          labelText: 'Şifrenizi giriniz...',
                          labelStyle:
                              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      alignment: const Alignment(1.0, 0.0),
                      padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                      child: const InkWell(
                        child: Text(
                          'Şifremi Unuttum',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: InkWell(
                          onTap: () async {
                            errorMessage = null;
                            setState(() {
                              isLoad = true;
                            });
                            await signInWithEmailAndPassword().then((_) async {
                              if (errorMessage == null) {
                                setState(() {
                                  isLoad = false;
                                });
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text("Giriş Hatası"),
                                      content: Text(errorMessage ?? "Tekrar deneyin..."),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const SignupPage(),
                                                  ));
                                            },
                                            child: const Text("Kaydol")),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Tamam")),
                                      ],
                                    );
                                  },
                                ).then((value) => setState(() {
                                      isLoad = false;
                                    }));
                              }
                            });
                          },
                          child: const Center(
                            child: Text(
                              'Giriş Yap',
                              style:
                                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: const Center(
                          child: Text('Google ile giriş yap',
                              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                        ),
                      ),
                    )
                  ],
                )),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hesabın yok mu ?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                const SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ));
                  },
                  child: const Text(
                    'Hesap Oluştur',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
