import 'package:flutter/material.dart';
import 'package:kliniek/api/auth_fuctions.dart';
import 'package:kliniek/page/doctor_register.dart';
import 'package:kliniek/page/first_page.dart';
import 'package:kliniek/pref/appcolors.dart';

class docRegis extends StatefulWidget {
  const docRegis({super.key});

  @override
  State<docRegis> createState() => _docRegisState();
}

class _docRegisState extends State<docRegis> {
  bool passwordVisible = false;

  TextEditingController username = TextEditingController();
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
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor().bluecolor,
        body: Form(
          key: formKey,
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)),
                      color: AppColor().secondarycolor),
                  width: screenwidth,
                  height: screenheight * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: screenheight * 0.05,
                      ),
                      const Text('Create new', style: TextStyle(fontSize: 24)),
                      const Text('Doctor Account',
                          style: TextStyle(fontSize: 24)),
                      SizedBox(
                          width: screenwidth * 0.7,
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Username',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: screenwidth * 0.7,
                                height: screenheight * 0.07,
                                child: TextFormField(
                                  cursorColor: AppColor().darkcolor,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColor().basecolor,
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      hintText: '',
                                      hintStyle: const TextStyle(fontSize: 14)),
                                  controller: username,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please enter Username';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: screenheight * 0.02,
                              ),
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'E-mail',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: screenwidth * 0.9,
                                height: screenheight * 0.07,
                                child: TextFormField(
                                  cursorColor: AppColor().darkcolor,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColor().basecolor,
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      hintText: '',
                                      hintStyle: const TextStyle(fontSize: 14)),
                                  controller: email,
                                  validator: (val) {
                                    bool emailValid = RegExp(
                                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                        .hasMatch(email.text);
                                    if (val!.isEmpty) {
                                      return 'Please enter Email';
                                    } else if (emailValid == false) {
                                      return 'Please enter Email Form';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: screenheight * 0.02,
                              ),
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Password',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: screenheight * 0.07,
                                width: screenwidth * 0.9,
                                child: TextFormField(
                                  cursorColor: AppColor().darkcolor,
                                  obscureText: passwordVisible,
                                  decoration: InputDecoration(
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      filled: true,
                                      fillColor: AppColor().basecolor,
                                      hintText: '',
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
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please enter password';
                                    } else if (val.length < 8) {
                                      return 'Please enter more than 8 ';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: screenheight * 0.03,
                              ),
                              SizedBox(
                                width: screenwidth * 0.9,
                                height: screenheight * 0.07,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: AppColor().whitecolor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      )),
                                  child: Text(
                                    'sign up',
                                    style: TextStyle(
                                        color: AppColor().darkcolor,
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    bool pass =
                                        formKey.currentState!.validate();
                                    if (pass) {
                                      formKey.currentState!.save();
                                      AuthServices.signupUser(
                                          email.text,
                                          password.text,
                                          username.text,
                                          "doctor",
                                          context);
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DoctorRegister()),
                                          (route) => false);
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                      Container(
                        alignment: Alignment.bottomLeft,
                        width: screenwidth,
                        height: screenheight * 0.25,
                        child: Stack(
                          children: [
                            Image.asset('assets/Doctor2.png'),
                            Positioned(
                              left: screenwidth * 0.425,
                              bottom: 68,
                              child: Column(children: [
                                Text(
                                  'Already Have',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  'Account?',
                                  style: TextStyle(fontSize: 11),
                                )
                              ]),
                            ),
                            Positioned(
                                right: 1,
                                top: 10,
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Social Media Login',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor().darkcolor),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.email),
                                            iconSize: 40,
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.facebook),
                                            iconSize: 40,
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.apple),
                                            iconSize: 40,
                                            onPressed: () {},
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 70,
              height: 70,
              color: AppColor().whitecolor,
            ),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColor().whitecolor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24.0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 20, color: AppColor().darkcolor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const FirstPage()),
                              (route) => route.isFirst);
                        },
                      )
                    ],
                  ),
                  Text(
                    'Sign up',
                    style: TextStyle(fontSize: 24, color: AppColor().darkcolor),
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
