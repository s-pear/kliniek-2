import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kliniek/pref/appcolors.dart';
import 'package:table_calendar/table_calendar.dart';

class AddTime extends StatefulWidget {
  const AddTime({Key? key}) : super(key: key);

  @override
  State<AddTime> createState() => _AddTimeState();
}

class _AddTimeState extends State<AddTime> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? pickedTime;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().basecolor,
        centerTitle: true,
        title: const Text("Time Table"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return const Dialog(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Saving...'),
                    ],
                  ),
                ),
              );
            },
          );
          await _selectTime(context);
          pickedTime = join(_selectedDay!, selectedTime);

          final QuerySnapshot result = await FirebaseFirestore.instance
              .collection('doctortime')
              .where('docId', isEqualTo: user!.uid)
              .where('dateTime', isEqualTo: pickedTime)
              .get();
          final List<DocumentSnapshot> documents = result.docs;
          if (documents.isNotEmpty) {
            Navigator.of(context).pop();

            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text("You already added this time"),
                  content: const Text("Select a new time"),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            await FirebaseFirestore.instance.collection('doctortime').add({
              'docId': user!.uid,
              'time': selectedTime.format(context).toString(),
              'date': DateFormat('d/M/y').format(_selectedDay!).toString(),
              'userId': "",
              'userName': "",
              'dateTime': pickedTime,
            });
            await Future.delayed(const Duration(seconds: 3));
            Navigator.of(context).pop();
          }
        },
      ),
      body: ListView(
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          Container(
            height: 1,
            color: Colors.black,
          ),
          SizedBox(height: screenheight * 0.02),
          SizedBox(
            child: Center(
              child: Column(
                children: [
                  Text("This Is Your Work At", style: TextStyle(fontSize: 18)),
                  Text(
                    "${DateFormat('d/M/y').format(_selectedDay!)}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenheight * 0.02),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('doctortime')
                .where('docId', isEqualTo: user!.uid)
                .where('date', isEqualTo: DateFormat('d/M/y').format(_selectedDay!).toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("No Data"),
                );
              } else {
                var docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(
                    child: Text("No cases for this day."),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(12.0),
                  height: screenheight * 0.3,
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = docs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: data['userId'] == "" ?  AppColor().basecolor : Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                                Text(
                                  "${data['time']}",
                                  style: TextStyle(color: Colors.white, fontSize: 24),
                                ),
                            IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance.collection('doctortime').doc(data.id).delete();
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }
}
