import 'package:flutter/material.dart';
import 'package:kliniek/page/doctor_regis.dart';
import 'package:kliniek/page/login_page.dart';
import 'package:kliniek/page/register_page.dart';
import 'package:kliniek/pref/appcolors.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int tapCount = 0;

  @override
  void initState() {
    super.initState();
    tapCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppColor().primarycolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  tapCount++;
                  if (tapCount >= 5) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const docRegis()));
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/Logoname.png'),
                ),
              ),
              SizedBox(height: screenheight * 0.07),
              Container(
                width: screenwidth,
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                    color: AppColor().secondarycolor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenwidth * 0.6,
                      height: screenheight * 0.07,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: AppColor().basecolor,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            )),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: AppColor().darkcolor, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: screenwidth * 0.6,
                      height: screenheight * 0.07,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor().secondarycolor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          side: BorderSide(
                              width: 3.0, color: AppColor().darkcolor),
                        ),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: AppColor().darkcolor, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
