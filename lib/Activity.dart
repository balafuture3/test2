import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Activity extends StatefulWidget {
  Activity({Key key, this.name,this.id});
  String name;
  String id;
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Completer<GoogleMapController> _controller = Completer();
  var _kGooglePlex;
  Marker marker ;
  String imei;
  int cnt=0;
  Set<Marker> markers = Set();
  Position position;
  var loading=false;
  bool textcheck=false;
@override
  void initState() {
  getlocation();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("logo.png",width: 100,height:50),

          ],
        ),
      ),
      body: loading?Center(child: CircularProgressIndicator()):SingleChildScrollView(
        child:Container(

          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          "Employee Detail",
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Employee Id : ",style: TextStyle(color: Colors.red,fontSize: 16),),
                    Text("${widget.id}",style: TextStyle(color: Colors.blueAccent,fontSize: 16,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Employee Name : ",style: TextStyle(color: Colors.red,fontSize: 16),),
                    Text("${widget.name}",style: TextStyle(color: Colors.blueAccent,fontSize: 16,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
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
                          "Location Detail",
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
              Container(
                height: 500,
                  padding: const EdgeInsets.all(16),
                  child: GoogleMap(
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller)
                    {
                      _controller.complete(controller);
                    },
                    markers: markers,

                  ))
            ],
          ),
        )
      ),
    );
  }
  Future<void> getlocation() async {
    setState(() {
      loading=true;
    });
    // List<String> multiImei = await ImeiPlugin.getImeiMulti(); //for double-triple SIM phones
    // String uuid = await ImeiPlugin.getId();
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    marker= Marker(
      markerId: MarkerId("fdg"),
      position: LatLng(position.latitude, position.longitude
      ),);

    setState(() {
      markers.add(marker);
      _kGooglePlex = CameraPosition( target: LatLng(position.latitude, position.longitude),zoom: 16);

      loading=false; //    print("Markers "+markers.length.toString());
    });
  }

}
