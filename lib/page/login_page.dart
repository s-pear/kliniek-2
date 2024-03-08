import 'package:flutter/material.dart';
import 'package:kliniek/api/auth_fuctions.dart';
import 'package:kliniek/page/register_page.dart';
import 'package:kliniek/pref/appcolors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  bool isRemember = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor().secondarycolor,
      body: Form(
        key: formKey,
        child: ListView(shrinkWrap: true, children: [
          Column(
            children: [
              SizedBox(
                height: screenheight*0.03,
              ),
              SizedBox(
                width: screenwidth * 0.85,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Logo.png',
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "KLINIEK",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screenwidth * 0.8,
                child: const Text(
                  'Welcome, Guest!',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(
                height: screenheight * 0.005,
              ),
              SizedBox(
                width: screenwidth * 0.8,
                child: const Text(
                  'Sign in to continue.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenheight * 0.025,
                    ),
                    SizedBox(
                        width: screenwidth * 0.8,
                        child: Image.asset('assets/Doctor1.png')),
                    SizedBox(
                      height: screenheight * 0.025,
                    ),
                    SizedBox(
                      width: screenwidth * 0.9,
                      child: TextFormField(
                        cursorColor: AppColor().darkcolor,
                        obscureText: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor().basecolor,
                            errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            hintText: 'E-mail',
                            hintStyle: const TextStyle(fontSize: 14)),
                        controller: email,
                        validator: (val) {
                          bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email.text);
                          if (val!.isEmpty) {
                            return 'Please enter Email';
                          } else if (emailValid == false){
                            return 'Please enter Email Form';
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenheight * 0.02,
                    ),
                    SizedBox(
                      width: screenwidth * 0.9,
                      child: TextFormField(
                        cursorColor: AppColor().darkcolor,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                            errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            filled: true,
                            fillColor: AppColor().basecolor,
                            hintText: 'Password',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: AppColor().darkcolor,
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            )),
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenheight * 0.005,
                    ),
                    SizedBox(
                      height: screenheight * 0.05,
                      width: screenwidth * 0.85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: AppColor().darkcolor),
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenheight * 0.005,
                    ),
                    Text(
                      'Social Media Login',
                      style:
                          TextStyle(fontSize: 18, color: AppColor().darkcolor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.email),
                          iconSize: 50,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.facebook),
                          iconSize: 50,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.apple),
                          iconSize: 50,
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(
                      height: screenheight * 0.01,
                    ),
                    SizedBox(
                      width: screenwidth * 0.9,
                      height: screenheight * 0.07,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: AppColor().darkcolor,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            )),
                        child: Text(
                          'sign in',
                          style: TextStyle(
                              color: AppColor().primarycolor, fontSize: 20),
                        ),
                        onPressed: () {
                          bool pass = formKey.currentState!.validate();

                          if (pass) {
                            formKey.currentState!.save();
                            AuthServices.signinUser(email.text, password.text, context);
                          }
                        },
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "Tap here if you are didn't have account",
                        style: TextStyle(color: AppColor().darkcolor),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}