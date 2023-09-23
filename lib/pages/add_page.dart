import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:recommendationsapp/constants/constants.dart';

class AddPage extends StatefulWidget {
  AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _scoreController = TextEditingController();
  String dropDownValue = '1';
  double lat = 0;
  double lang = 0;

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
          ElevatedButton(
            onPressed: () {
              getDataLocation().then((value) {
                print(lang);
                print(lat);
              });
            },
            child: Icon(
              Icons.place,
            ),
          )
        ],
      ),
    );
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
