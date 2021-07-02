import 'package:flutter/material.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

class GetFeedback extends StatefulWidget {
  @override
  _GetFeedbackState createState() => _GetFeedbackState();
}

class _GetFeedbackState extends State<GetFeedback> {
  late DatabaseReference userDbReferece;
  late String feedback;
  final TextEditingController feedbackController = TextEditingController();

  void submitDetails(feedback) {
    userDbReferece.child("Users").push().set({
      "feedback": feedback,
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Feedback Submitted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: black,
          textColor: white,
          fontSize: 16.0);
    });
  }

  @override
  void initState() {
    super.initState();
    userDbReferece = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: cyan,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 350,
                    height: 217,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SizedBox(
                      height: 10,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Write your Feedback below!',
                                          style: TextStyle(color: white)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                text1(feedbackController, "FEEDBACK"),
                                SizedBox(
                                  height: 7,
                                ),
                                button("SUBMIT")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget text1(TextEditingController controller, String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextField(
          onChanged: (value) {
            setState(() {
              this.feedback = value;
            });
          },
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  Widget button(String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () async {
          submitDetails(this.feedback);
          Navigator.pop(context);
        },
        child: Container(
            height: 45,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: cyan),
            child: Stack(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: hint,
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
