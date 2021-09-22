import 'package:event/database_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  //const ({ Key? key }) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Event Manager"),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                //save the event
                if (_eventController.text.isEmpty || selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Fields must be empty")),
                  );
                } else {
                  setState(() {
                    isSaving = true;
                  });

                  final uid = _auth.currentUser!.uid;
                  DatabaseClass(uid)
                      .addEvents(
                          eventName: _eventController.text.trim(),
                          location: _locationController.text.trim(),
                          description: _descriptionController.text.trim(),
                          date: selectedDate.toString())
                      .then((value) {
                    setState(() {
                      isSaving = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value)),
                    );
                  });
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              formFields(context, "Event Name", _eventController),
              const SizedBox(
                height: 15,
              ),
              formFields(context, "Location", _locationController),
              const SizedBox(
                height: 15,
              ),
              formFields(context, "Description", _descriptionController),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Date', style: TextStyle(fontSize: 20))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            getDate(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                              ),
                              child: Text("$selectedDate")),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            getTime(context);
                          },
                          child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                              ),
                              child: Text("$selectedTime")),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  isSaving == false
                      ? Container()
                      : CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.utc(2021),
      lastDate: DateTime.utc(2030),
    ).then((value) {
      setState(() {
        selectedDate = value!;
      });
    });
  }

  Future getTime(BuildContext context) async {
    await showTimePicker(context: context, initialTime: selectedTime)
        .then((value) {
      setState(() {
        selectedTime = value!;
      });
    });
  }

  Widget formFields(
      BuildContext context, String text, TextEditingController controller) {
    return Container(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: text),
      ),
    );
  }
}
