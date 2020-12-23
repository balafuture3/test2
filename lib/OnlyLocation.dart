import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.username});
  String username;
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  var _kGooglePlex;
  Marker marker;
  Set<Marker> markers = Set();
  Position position;
  TextEditingController NameController = new TextEditingController();
  var loading = false;

  void initState() {
    getlocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: GoogleMap(
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
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

  Future<void> getlocation() async {
    setState(() {
      loading = true;
    });

    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    marker = Marker(
      markerId: MarkerId("fdg"),
      position: LatLng(position.latitude, position.longitude),
    );

    setState(() {
      markers.add(marker);
      _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 16);

      loading = false;
    });
  }
}
