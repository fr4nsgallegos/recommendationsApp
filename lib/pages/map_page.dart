import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CollectionReference recommendationReference =
      FirebaseFirestore.instance.collection('recommendations');

  Set<Marker> myMarkers = {};

  Future<void> getRecommendations() async {
    await recommendationReference.get().then((value) {
      QuerySnapshot recommendationsCollection = value;
      List<QueryDocumentSnapshot> docs = recommendationsCollection.docs;

      docs.forEach(
        (element) {
          Map<String, dynamic> myDoc = element.data() as Map<String, dynamic>;
          myDoc['id'] = element.id;
          // print(myDoc);
          // print("---------------");
          // print(element['lat']);
          // print(element['lang']);
          double latAux = element['lat'];
          double langAux = element['lang'];
          Marker marker = Marker(
            markerId: MarkerId(
              myMarkers.length.toString(),
            ),
            position: LatLng(latAux, langAux),
          );
          myMarkers.add(marker);
        },
      );
    });
  }

  @override
  void initState() {
    getRecommendations();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicaciones"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-10.662173, -75.749106),
          zoom: 6,
        ),
        markers: myMarkers,
      ),
    );
  }
}
