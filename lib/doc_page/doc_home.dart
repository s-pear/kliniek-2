import 'package:flutter/material.dart';
import 'package:kliniek/doc_page/add_time.dart';
import 'package:kliniek/pref/appcolors.dart';
import '../doc_page/doc_profile.dart';
import '../homepage/doctor_home.dart';


class LandingDoc extends StatefulWidget {
  const LandingDoc({super.key});

  @override
  State<LandingDoc> createState() => _LandingDocState();
}

class _LandingDocState extends State<LandingDoc> {
  int currentTab = 0;
  final List<Widget> screen = [
    const DoctorHome(isCheck: true,),
    const AddTime(),
    const DocProfile(),
  ];

  Widget currentScreen = const DoctorHome(isCheck: true,);

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().bgcolor,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = const DoctorHome(isCheck: true);
                    currentTab = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.home,
                        color: currentTab == 0
                            ? AppColor().bluecolor
                            : Colors.grey),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = const AddTime();
                    currentTab = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.access_time_filled,
                        color: currentTab == 1
                            ? AppColor().bluecolor
                            : Colors.grey),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = const DocProfile();
                    currentTab = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person,
                        color: currentTab == 3
                            ? AppColor().bluecolor
                            : Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
