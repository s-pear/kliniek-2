import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliniek/api/firestore_services.dart';
import 'package:kliniek/api/util.dart';
import 'package:kliniek/homepage/doctor_home.dart';
import 'package:kliniek/pref/appcolors.dart';
import 'dart:typed_data';

class DoctorRegister extends StatefulWidget {
  const DoctorRegister({super.key});

  @override
  State<DoctorRegister> createState() => _DoctorRegisterState();
}

class _DoctorRegisterState extends State<DoctorRegister> {
  final _catalogList = [
    "General",
    "Pediattrics",
    "Cardiology",
    "Ophthalmology",
    "Obstetrics",
    "Elderly care",
    "Dentistry",
    "Otolaryngology",
    "Office syndrome"
  ];
  String? catalog = "General";
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/kliniek-app.appspot.com/o/user.png?alt=media&token=77f2f379-5deb-46c6-9eac-e7f0c0d637e6';

  bool uploaded = false;
  Uint8List? image;

  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController name = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController exp = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor().bgcolor,
      body: ListView(children: [
        Form(
          key: formKey,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenheight * 0.1),
              Stack(
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/kliniek-app.appspot.com/o/user.png?alt=media&token=77f2f379-5deb-46c6-9eac-e7f0c0d637e6'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () {
                          selectImg();
                        },
                        icon: const Icon(Icons.add_a_photo)),
                  )
                ],
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              SizedBox(
                width: screenwidth * 0.9,
                child: TextFormField(
                  cursorColor: AppColor().darkcolor,
                  decoration: InputDecoration(
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    filled: true,
                    fillColor: AppColor().primarycolor,
                    hintText: 'Name',
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                  controller: name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter name';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              SizedBox(
                width: screenwidth * 0.9,
                child: TextFormField(
                  cursorColor: AppColor().darkcolor,
                  decoration: InputDecoration(
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    filled: true,
                    fillColor: AppColor().primarycolor,
                    hintText: 'Lastname',
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                  controller: lname,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Lastname';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              SizedBox(
                width: screenwidth * 0.9,
                child: TextFormField(
                  cursorColor: AppColor().darkcolor,
                  decoration: InputDecoration(
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0),
                    ),
                    filled: true,
                    fillColor: AppColor().primarycolor,
                    hintText: 'How about your EXP',
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                  controller: exp,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your EXP';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              const Text('choose your catalog', style: TextStyle(fontSize: 18)),
              SizedBox(
                height: screenheight * 0.025,
              ),
              DropdownButton<String>(
                value: catalog,
                items: _catalogList.map(buildMenuItem).toList(),
                onChanged: (val) {
                  setState(() {
                    catalog = val;
                  });
                },
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              SizedBox(
                width: screenwidth * 0.9,
                height: screenheight * 0.07,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColor().darkcolor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                  child: Text(
                    'Continue',
                    style:
                        TextStyle(color: AppColor().primarycolor, fontSize: 20),
                  ),
                  onPressed: () async {
                    bool pass = formKey.currentState!.validate();
                    if (pass) {
                      if (uploaded) {
                        formKey.currentState!.save();

                        await FireStoreServices.addDoctor(name.text, lname.text,
                            exp.text, catalog!, user!.uid, imageUrl);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const DoctorHome(isCheck: true,),
                            ),
                            (route) => false);
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Please upload photo"),
                                content: const Text(""),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'))
                                ],
                              );
                            });
                      }
                    }
                  },
                ),
              ),
            ],
          )),
        ),
      ]),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  void selectImg() async {
    try {
      Uint8List? img = await pickImg2(ImageSource.gallery);
      imageUrl = await FireStoreServices.uploadImgToStorage("test", img!);
      setState(() {
        image = img;
        uploaded = true;
      });
    } catch (e) {
      print(e);
    }
    print(imageUrl);
  }
}
