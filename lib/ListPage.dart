import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:indusnovatest2/String_Values.dart';
import 'package:indusnovatest2/model.dart';
import 'package:indusnovatest2/model2.dart';

import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isHidden = true;
  bool loading = false;
  String errortextemail;
  String errortextpass;
  final Xml2Json xml2Json = Xml2Json();
  bool validateE = false;

  bool validateP = false;

  Model li;



  Model2List li2;


  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });
    var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IndusMobileAllEmpList xmlns="http://tempuri.org/" />
    </soap:Body>
</soap:Envelope>
''';
    var url =
        String_values.base_url+'?op=IndusMobileAllEmpList';

    var response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          //   'Authorization':
          //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIxIiwidXR5cGUiOiJFTVAifQ.AhfTPvo5C_rCMIexbUd1u6SEoHkQCjt3I7DVDLwrzUs'
          //
        },
        body: envelope);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      print(response.statusCode);
      print(response.body);
      xml2Json.parse(response.body.toString());
      var jsonString = xml2Json.toParker();
      print(jsonString);
      li = Model.fromJson(json.decode(jsonString));

      if (li.soapEnvelope.soapBody.indusMobileAllEmpListResponse.indusMobileAllEmpListResult
           !=
          "[]") {
        li2 = Model2List.fromJson(json.decode(li.soapEnvelope.soapBody.indusMobileAllEmpListResponse.indusMobileAllEmpListResult.toString()));
        // print(li2.list[0].firstName);
      }
      //   Fluttertoast.showToast(
      //       msg:
      //       "Name: ${li2.name}\nCode: ${li2.code}\nDepartment: ${li2.depratment}\nBranchCode: ${li2.branchCode}\nBranchName: ${li2.branchName}\nManagerID: ${li2.managerID}\nSuperUser: ${li2.superUser}\nWebIDSales: ${li2.webIDSales}\nImei: ${li2.imei}",
      //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.blueAccent,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
        // print(json.encode(li.soapEnvelope.soapBody.indusMobileUserLogin1Response.indusMobileUserLogin1Result));
        // print(li2.name);

        //
        // else
        //   showDialog(context: context,child: AlertDialog(
        //     backgroundColor:  String_values.base_color,
        //     title: Text("Incorrect Login Details ",style: TextStyle(color: Colors.white),),
        //     content: Text("Please check your username or email and password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        //     actions: <Widget>[
        //       TextButton(
        //         child: Text('OK',style: TextStyle(color: Colors.white)),
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //       ),
        //     ],
        //   ));
    //   } else
    //     Fluttertoast.showToast(
    //         msg: "Please check your login details,No users found",
    //         toastLength: Toast.LENGTH_LONG,
    //         gravity: ToastGravity.SNACKBAR,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.blueAccent,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "Http error!, Response code ${response.statusCode}",
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.SNACKBAR,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.blueAccent,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //   setState(() {
    //     loading = false;
    //   });

    }
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  static TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
@override
  void initState() {
    // TODO: implement initState
  postRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(),
    );
  }

  Widget buildTextField(String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 5),
      child: TextField(
        controller: hintText == "Email" ? emailController : passwordController,
        keyboardType: TextInputType.emailAddress,
        onTap: () {
          setState(() {
            hintText == "Email" ? errortextemail = null : errortextpass = null;
          });
        },
        decoration: InputDecoration(
          errorText: hintText == "Email"
              ? validateE
              ? errortextemail
              : null
              : validateP
              ? errortextpass
              : null,
          prefixIcon:
          hintText == "Email" ? Icon(Icons.email) : Icon(Icons.lock),
          labelText: hintText == "Email" ? hintText + " or Username" : hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          suffixIcon: hintText == "Password"
              ? IconButton(
            onPressed: _toggleVisibility,
            icon: _isHidden
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
          )
              : null,
        ),
        obscureText: hintText == "Password" ? _isHidden : false,
      ),
    );
  }

  Widget ButtonContainer() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 50,
        child: FlatButton(
          child: Text('Login'),
          color: String_values.base_color,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          onPressed: () {
            setState(() {
              if (emailController.text.trim().isNotEmpty) {
                validateE = false;
              } else {
                validateE = true;
                errortextemail = "Email cannot be empty";
              }
              if (passwordController.text.isEmpty) {
                if (passwordController.text.isEmpty)
                  errortextpass = "Password cannot be empty";
                validateP = true;
              } else
                validateP = false;

              if (validateE == false && validateP == false)
                check().then((value) {
                  if (value)
                    postRequest();
                  else
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("No Internet Connection"),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                });
            });
          },
        ));
  }
}
