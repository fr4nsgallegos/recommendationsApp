import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recommendationsapp/constants/constants.dart';
import 'package:recommendationsapp/pages/map_page.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:open_file/open_file.dart';

class AddPage extends StatefulWidget {
  AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _descriptionController = TextEditingController();

  String dropDownValue = '1';
  double lat = 0;
  double lang = 0;

  CollectionReference recommendationsReference =
      FirebaseFirestore.instance.collection('recommendations');

  Future<void> getDataLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      lat = position.latitude;
      lang = position.longitude;
    });
  }

  Widget forms(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
      child: ListView(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: _descriptionController,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.cyan.shade900,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.description),
                labelText: "Ingrese la descripción",
                labelStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.cyan.shade800,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 20,
                child: Text(
                  'Ingrese el Score',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 3,
                margin: EdgeInsets.all(20),
                child: DropdownButtonHideUnderline(
                  child: new GFDropdown(
                    isExpanded: true,
                    items: ['1', '2', '3', '4', '5']
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    value: dropDownValue,
                    onChanged: (dynamic newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                      });
                      // print(dropDownValue);
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Lat: ${lat}"),
              // SizedBox(width: m,)
              Text("Lat: ${lang}"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(),
              onPressed: () {
                getDataLocation().then((value) {});
              },
              child: Icon(
                Icons.place,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {
                // recommendationsReference.get().then((value) {
                //   QuerySnapshot recommendationCollection = value;
                //   List<QueryDocumentSnapshot> docs =
                //       recommendationCollection.docs;
                // });
                recommendationsReference.add({
                  'description': _descriptionController.text,
                  'score': dropDownValue,
                  'lat': lat,
                  'lang': lang,
                });
              },
              child: Text("Agregar recomendación")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
              child: Text("Ver mapa")),
          ElevatedButton(
              onPressed: () {
                _createExcel();
              },
              child: Text("Generar Excel"))
        ],
      ),
    );
  }

  Future<void> _createExcel() async {
    final workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('B2').setText('Hola ya estoy escribiendo');

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;

    final String fileName = '$path/MyFirstExcel.xlsx';

    final File file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                fondoBlanco(context, forms(context)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
