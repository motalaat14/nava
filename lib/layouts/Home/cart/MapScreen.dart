import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as p;
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor myIcon;
  GoogleMapController myController;
  double currentLat;
  double currentLng;
  String userLocation;
  Marker marker = Marker(markerId: MarkerId("1"));
  Set<Marker> mark = Set();
  var location = Location();
  bool onChoose = false;

  getAddress() async {
    Position position = await Geolocator().getCurrentPosition();
    setState(() {
      currentLat = position.latitude;
      currentLng = position.longitude;
    });
    print(currentLat);
    print(currentLng);
    Geolocator().placemarkFromCoordinates(currentLat, currentLng).then((address) {
      setState(() {
        userLocation = address[0].subAdministrativeArea + " - " + address[0].administrativeArea;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      myController = controller;
    });
  }

  void initState() {
    getAddress();
    super.initState();
    p.LocationPermissions().requestPermissions().then((p.PermissionStatus status) {
      if (status == p.PermissionStatus.granted) {
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^location granted");
        location.getLocation().then((LocationData myLocation) {
          setState(() {
            Geolocator().placemarkFromCoordinates(myLocation.latitude, myLocation.longitude)
                .then((address) {
              setState(() {
                userLocation = address[0].name + " " + address[0].country;
                print("============= $userLocation");
              });
            });
            currentLat = myLocation.latitude;
            currentLng = myLocation.longitude;
            InfoWindow infoWindow = InfoWindow(title: "Location");
            Marker marker = Marker(
              draggable: true,
              markerId: MarkerId('markers.length.toString()'),
              infoWindow: infoWindow,
              position: LatLng(myLocation.latitude, myLocation.longitude),
              icon: myIcon,
            );
            setState(() {
              mark.add(marker);
            });
          });
        });
      } else if (status == p.PermissionStatus.denied) {
        p.LocationPermissions().requestPermissions();
        Navigator.pop(context);
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^ location denied");
        Fluttertoast.showToast(msg:"Must Allow Location To Add Address");
      }else{
        Navigator.pop(context);
        Fluttertoast.showToast(msg:"Must Allow Location To Add Address");
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^location else");
      }
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(20, 20),
        devicePixelRatio: 0,
      ),
      'assets/images/marker.png',
    ).then((onValue) {
      myIcon = onValue;
    });
  }

  Position updatedPosition;

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        title: Text(tr("selectLocation"),style: TextStyle(color: MyColors.white,fontSize: 18),),
        iconTheme: IconThemeData(color: MyColors.white),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context, [userLocation, currentLat, currentLng]);
          },
            child: Icon(Icons.arrow_back)),
      ),
      body: currentLat == null && currentLng == null
          ? Center(
              child: MyLoading(),
            )
          : Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height*.8,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(target: LatLng(currentLat, currentLng), zoom: 15.0),
                        onTap: (newLang) {
                          currentLat = updatedPosition.latitude;
                          currentLng = updatedPosition.longitude;
                          },
                          onMapCreated: _onMapCreated,
                          onCameraMove: ((_position) => _updatePosition(_position)),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.location_on, color: MyColors.accent, size: 40)),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1,
                                color: MyColors.primary),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.my_location,
                                  size: 15,
                                  color: MyColors.primary,
                                ),
                              ),
                              Text(
                                userLocation ?? tr("address"),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              _confirmButton(context),
            ],
          ),
    );
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    setState(() {
      updatedPosition = newMarkerPosition;
      currentLat = newMarkerPosition.latitude;
      currentLng = newMarkerPosition.longitude;
      marker = marker.copyWith(
          positionParam:
              LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
      Geolocator()
          .placemarkFromCoordinates(
              updatedPosition.latitude, updatedPosition.longitude)
          .then((address) {
        setState(() {
          userLocation = address[0].name + "  " + address[0].country;
        });
      });
    });
  }



  Widget _confirmButton(BuildContext context) {
    return CustomButton(
      margin: EdgeInsets.only(left: 20,right: 20,bottom: 15),
      color: MyColors.white,
      title: tr("chooseCurrentLocation"),
      borderColor: MyColors.primary,
      textColor: MyColors.primary,
      width: MediaQuery.of(context).size.width,
      onTap: () {
        Navigator.pop(context, [userLocation, currentLat, currentLng]);
      },
    );
  }
}
