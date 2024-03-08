import 'package:flutter/material.dart';
import 'package:kliniek/pref/appcolors.dart';
import 'package:kliniek/user_page/llist_doctor.dart';

class ChooseDoctor extends StatefulWidget {
  const ChooseDoctor({super.key});

  @override
  State<ChooseDoctor> createState() => _ChooseDoctorState();
}

class _ChooseDoctorState extends State<ChooseDoctor> {
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor().bgcolor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor().bluecolor),
        title: Text(
          'Choose your doctor',
          style: TextStyle(color: AppColor().bluecolor),
        ),
        backgroundColor: AppColor().bgcolor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/Logoname.png',
              scale: 2.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconImg('assets/1.png', 'General'),
                iconImg('assets/2.png', 'Pediattrics'),
                iconImg('assets/3.png', 'Cardiology'),
              ],
            ),
            SizedBox(
              height: screenheight * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconImg('assets/4.png', 'Ophthalmology'),
                iconImg('assets/5.png', 'Obstetrics'),
                iconImg('assets/6.png', 'Elderly care'),
              ],
            ),
            SizedBox(
              height: screenheight * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconImg('assets/7.png', 'Dentistry'),
                iconImg('assets/8.png', 'Otolaryngology'),
                iconImg('assets/9.png', 'Office syndrome'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconImg(String asset, String page) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.white,
      elevation: 8,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.black,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListDoctor(catalog: page)));
        },
        child: Ink.image(
          image: AssetImage(asset),
          width: screenwidth * 0.25,
          height: screenwidth * 0.25,
        ),
      ),
    );
  }
}
