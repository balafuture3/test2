import 'dart:convert';
import 'dart:ui';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:indusnovatest2/Activity.dart';
import 'package:indusnovatest2/TestListPageScroll.dart';
import 'package:indusnovatest2/OnlyLocation.dart';
import 'package:indusnovatest2/String_Values.dart';
import 'package:indusnovatest2/model.dart';
import 'package:indusnovatest2/model2.dart';

import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';

class PaginationPage extends StatefulWidget {
  @override
  PaginationPageState createState() => PaginationPageState();
}

class PaginationPageState extends State<PaginationPage> {
  bool _isHidden = true;
  bool loading = false;
  PageController _controller;
  final Xml2Json xml2Json = Xml2Json();

  List<User> users;
  Model li;

  Model2List li2;

  Model3List li3;
  int totalpages;
  List<String> name = new List();
  List<String> id = new List();
  double currentpage = 0;

  var page = 1;

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
    var url = String_values.base_url + '?op=IndusMobileAllEmpList';

    var response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
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

      li = Model.fromJson(json.decode(jsonString));

      if (li.soapEnvelope.soapBody.indusMobileAllEmpListResponse
              .indusMobileAllEmpListResult !=
          "[]") {
        li2 = Model2List.fromJson(json.decode(li.soapEnvelope.soapBody
            .indusMobileAllEmpListResponse.indusMobileAllEmpListResult
            .toString()
            .replaceAll("\t", "")));
        print(li2.list.length / 20);
        if (li2.list.length % 20 == 0)
          totalpages = (li2.list.length / 20).floor();
        else
          totalpages = (li2.list.length / 20).floor() + 1;
        print(totalpages);
        users = User.getUsers();
        users.removeRange(0, users.length);
        for (int i = 0; i < 20; i++) {
          users.add(User(
              firstName: li2.list[i].firstName,
              id: li2.list[i].empID.toString()));
        }
      }
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
                TextButton(
                  child: Text('RETRY'),
                  onPressed: () {

                  retry();
            Navigator.of(context).pop();
            })]);


          },
        );
    });
    super.initState();
  }

  _pagelListener() {
    setState(() {
      currentpage =
          _controller.offset / (MediaQuery.of(context).size.width - 32);
    });

    print(_controller.offset / (MediaQuery.of(context).size.width - 32));
    print(MediaQuery.of(context).size.width);
    print(_controller.offset);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    // color: Colors.white,
                    margin: EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: new Text(
                              "Employee List",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: width / 10,
                      columns: [
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Employee ID",
                                softWrap: true,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Employee Name",
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Location",
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                      ],
                      rows: users
                          .map(
                            (list) => DataRow(
                                onSelectChanged: (bool selected) {
                                  if (selected) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Activity(
                                                name: list.firstName,
                                                id: list.id)));
                                  }
                                },
                                cells: [
                                  DataCell(Center(
                                    child:
                                        Wrap(direction: Axis.vertical, //defau
                                            children: [
                                          Text(
                                            list.id,
                                            textAlign: TextAlign.center,
                                          )
                                        ]),
                                  )),
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        children: [
                                          Text(list.firstName.toString(),
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(
                                    IconButton(
                                        icon: Icon(
                                          Icons.location_history,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MapScreen()));
                                        }),
                                  ),
                                ]),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    color: Colors.blueAccent.withOpacity(0.2),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Page : ${page}"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color:
                                    page > 1 ? Colors.blueAccent : Colors.grey,
                              ),
                              onPressed: () {
                                if (page > 1)
                                  setState(() {
                                    page--;
                                    users.removeRange(0, users.length);
                                    for (int i = (page * 20) - 19;
                                        i < page * 20;
                                        i++) {
                                      users.add(User(
                                          firstName: li2.list[i].firstName,
                                          id: li2.list[i].empID.toString()));
                                    }
                                  });
                              },
                            ),
                            int.parse(li2.list.length.toString()) == 0
                                ? Text("0 to 0 of 0")
                                : int.parse(li2.list.length.toString()) >
                                        (page * 20)
                                    ? Text(
                                        "${(page * 20) - 19} to ${(page * 20)} of ${li2.list.length}")
                                    : Text(
                                        "${(page * 20) - 19} to ${li2.list.length} of ${li2.list.length}"),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: int.parse(li2.list.length.toString()) >
                                        (page * 20)
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (int.parse(li2.list.length.toString()) >
                                      (page * 20)) {
                                    page++;
                                    users.removeRange(0, users.length);
                                    for (int i = (page * 20) - 19;
                                        i < page * 20;
                                        i++) {
                                      if(i<li2.list.length)
                                      users.add(User(
                                          firstName: li2.list[i].firstName,
                                          id: li2.list[i].empID.toString()));
                                    }
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("logo.png", width: 100, height: 50),
          ],
        ),
      ),
    );
  }

  void retry() {
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
                TextButton(
                  child: Text('RETRY'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    retry();

                  },
                ),
              ],
            );
          },
        );

    });
  }
}

class User {
  String firstName;
  String id;

  User({this.firstName, this.id});

  static List<User> getUsers() {
    return <User>[];
  }
}
