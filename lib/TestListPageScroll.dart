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
import 'package:indusnovatest2/String_Values.dart';
import 'package:indusnovatest2/model.dart';
import 'package:indusnovatest2/model2.dart';

import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';

class PageListView extends StatefulWidget {
  @override
  PageListViewState createState() => PageListViewState();
}

class PageListViewState extends State<PageListView> {
  bool _isHidden = true;
  bool loading = false;
  PageController _controller;
  final Xml2Json xml2Json = Xml2Json();

  Model li;

  Model2List li2;

  int totalpages;

  double currentpage = 0;

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
    postRequest();
    _controller = PageController();
    _controller.addListener(_pagelListener);
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
              child: Container(
                  height: height,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Flexible(
                                  flex: 2,
                                  child: Text(
                                    "S.No",
                                    textAlign: TextAlign.start,
                                  )),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                  flex: 5,
                                  child: Text(
                                    "Employee Id",
                                    textAlign: TextAlign.start,
                                  )),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                  flex: 10,
                                  child: Text(
                                    "Employee Name",
                                    textAlign: TextAlign.start,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PageView(
                            controller: _controller,
                            children: [
                              for (int i = 0; i < totalpages; i++)
                               new ListView.builder(
                                    itemCount: (i != totalpages - 1
                                        ? 20
                                        : li2.list.length % 20),
                                    itemBuilder:
                                        (BuildContext ctxt, int Index) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            ((i * 20) +
                                                                    Index +
                                                                    1)
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ],
                                                      )),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container()),
                                                  Flexible(
                                                      flex: 5,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            li2
                                                                .list[(i * 20) +
                                                                    Index]
                                                                .empID
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ],
                                                      )),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container()),
                                                  Flexible(
                                                      flex: 10,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              li2
                                                                  .list[
                                                                      (i * 20) +
                                                                          Index]
                                                                  .firstName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 2,
                        child: DotsIndicator(
                          dotsCount: totalpages,
                          position: currentpage,
                          // reversed: true,
                          decorator: DotsDecorator(
                              //   color: Colors.black87,

                              // Inactive color
                              // activeColor: Colors.redAccent,
                              ),
                        ),
                      ),
                    ],
                  )),
            ),
    );
  }
}
