import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recommendationsapp/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn();

    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "RECOMMENDATIONS APP",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correo',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            hintText: "Ingresa el correo",
                            hintStyle: TextStyle(color: Colors.white54)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Contraseña',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _passController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            hintText: "Ingresa la contraseña",
                            hintStyle: TextStyle(color: Colors.white54)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passController.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text("Crear cuenta"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await _auth.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passController.text,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text("Iniciar sesión"),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
