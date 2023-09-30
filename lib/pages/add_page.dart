import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recommendationsapp/constants/constants.dart';
import 'package:recommendationsapp/pages/map_page.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:open_file/open_file.dart';
import 'package:syncfusion_officechart/officechart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
              child: Text("Generar Excel")),
          ElevatedButton(
            onPressed: () {
              getRecommendations();
            },
            child: Text("debugeando"),
          ),
          ElevatedButton(
            onPressed: () {
              _createExcelChart1();
            },
            child: Text("CHART 1"),
          ),
          ElevatedButton(
            onPressed: () {
              _createExcelChart2();
            },
            child: Text("CHART 2"),
          ),
          ElevatedButton(
            onPressed: () {
              _exportPdf();
            },
            child: Text("TOPDF"),
          ),
        ],
      ),
    );
  }

  Future<void> getRecommendations() async {
    await recommendationsReference.get().then((value) {
      QuerySnapshot recommendationsCollection = value;
      List<QueryDocumentSnapshot> docs = recommendationsCollection.docs;

      docs.forEach(
        (element) {
          Map<String, dynamic> myDoc = element.data() as Map<String, dynamic>;
          myDoc['id'] = element.id;
          print(myDoc['id']);
          print(myDoc.length);
        },
      );
    });
  }

  Future<void> _createExcelChart1() async {
    // ignore: unused_local_variable
    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText("Meses");
    sheet.getRangeByName('B1').setText("Gastos internos");
    sheet.getRangeByName('C1').setText('Salidas');

    sheet.getRangeByName('A2').setDateTime(DateTime(2023, 01, 14, 14, 14, 14));
    sheet.getRangeByName('A3').setDateTime(DateTime(2023, 02, 14, 14, 14, 14));
    sheet.getRangeByName('A4').setDateTime(DateTime(2023, 03, 14, 14, 14, 14));
    sheet.getRangeByName('A5').setDateTime(DateTime(2023, 04, 14, 14, 14, 14));
    sheet.getRangeByName('A6').setDateTime(DateTime(2023, 05, 14, 14, 14, 14));

    sheet.getRangeByName('B2').setNumber(700);
    sheet.getRangeByName('B3').setNumber(200);
    sheet.getRangeByName('B4').setNumber(300);
    sheet.getRangeByName('B5').setNumber(500);
    sheet.getRangeByName('B6').setNumber(900);

    sheet.getRangeByName('C2').setNumber(30);
    sheet.getRangeByName('C3').setNumber(40);
    sheet.getRangeByName('C4').setNumber(50);
    sheet.getRangeByName('C5').setNumber(5);
    sheet.getRangeByName('C6').setNumber(100);

    //creamos instancia a una coleccion de chart
    final ChartCollection charts = ChartCollection(sheet);

    //agregamos el chart
    final Chart chart = charts.add();

    //tipo de chart
    chart.chartType = ExcelChartType.line;

    //setear data
    chart.dataRange = sheet.getRangeByName('A1:C6');
    chart.isSeriesInRows = false;

    //estilo a los titulos del chart
    chart.chartTitle = 'Ingresos mensuales';
    chart.chartTitleArea.bold = true;
    chart.chartTitleArea.size = 15;

    chart.legend!.position = ExcelLegendPosition.bottom;

    //position chart
    chart.topRow = 0;
    chart.bottomRow = 20;
    chart.leftColumn = 1;
    chart.rightColumn = 8;

    sheet.charts = charts;

    //crear  y abrir file
    List<int> bytes = workbook.saveSync();
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/REPORTE.xlsx';

    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<void> _createExcelChart2() async {
    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet1 = workbook.worksheets.addWithName('PAGINA1');

    sheet1.enableSheetCalculations();
    sheet1.getRangeByIndex(1, 1).columnWidth = 20;
    sheet1.getRangeByIndex(1, 2).columnWidth = 14;
    sheet1.getRangeByIndex(1, 3).columnWidth = 13;
    sheet1.getRangeByIndex(1, 4).columnWidth = 13;
    sheet1.getRangeByIndex(1, 5).columnWidth = 9;
    sheet1.getRangeByName('A1:A18').rowHeight = 21;

    final excel.Style style1 = workbook.styles.add('Style1');
    style1.backColor = '#D9E1F2';
    style1.vAlign = excel.VAlignType.center;
    style1.hAlign = excel.HAlignType.left;
    style1.bold = true;

    final excel.Style style2 = workbook.styles.add('Style2');
    style2.backColor = '#8EA9DB';
    style2.vAlign = excel.VAlignType.center;
    style2.bold = true;

    sheet1.getRangeByName('A10').cellStyle = style1;
    sheet1.getRangeByName('B10:D10').cellStyle.backColor = '#D9E1F2';
    sheet1.getRangeByName('B10:D10').cellStyle.hAlign = excel.HAlignType.right;
    sheet1.getRangeByName('B10:D10').cellStyle.vAlign = excel.VAlignType.center;
    sheet1.getRangeByName('B10:D10').cellStyle.bold = true;

    // sheet1.getRangeByName('A11:A17').cellStyle.

    sheet1.getRangeByIndex(10, 1).setText('Categoria');
    sheet1.getRangeByIndex(10, 2).setText('Precosto');
    sheet1.getRangeByIndex(10, 3).setText('Costo actual');
    sheet1.getRangeByIndex(10, 4).setText('Diferencia');
    sheet1.getRangeByIndex(11, 1).setText('Evento');
    sheet1.getRangeByIndex(12, 1).setText('Asientos y decoracion');
    sheet1.getRangeByIndex(13, 1).setText('equipo técnico');
    sheet1.getRangeByIndex(14, 1).setText('Artistas');
    sheet1.getRangeByIndex(15, 1).setText('Transporte del artista');
    sheet1.getRangeByIndex(16, 1).setText('Estancia del Artista');
    sheet1.getRangeByIndex(17, 1).setText('Marketing');
    sheet1.getRangeByIndex(18, 1).setText('Total');

    sheet1.getRangeByName('B11').setNumber(16250);
    sheet1.getRangeByName('B12').setNumber(1600);
    sheet1.getRangeByName('B13').setNumber(1000);
    sheet1.getRangeByName('B14').setNumber(12400);
    sheet1.getRangeByName('B15').setNumber(5000);
    sheet1.getRangeByName('B16').setNumber(3000);
    sheet1.getRangeByName('B17').setNumber(15000);
    sheet1.getRangeByName('B18').setFormula('=SUM(B11:B17)');

    sheet1.getRangeByName('C11').setNumber(17500);
    sheet1.getRangeByName('C12').setNumber(1828);
    sheet1.getRangeByName('C13').setNumber(800);
    sheet1.getRangeByName('C14').setNumber(14000);
    sheet1.getRangeByName('C15').setNumber(2600);
    sheet1.getRangeByName('C16').setNumber(4464);
    sheet1.getRangeByName('C17').setNumber(2700);
    sheet1.getRangeByName('B18').setFormula('=SUM(C11:C17)');

    sheet1.getRangeByName('D11').setFormula('=IF(C11>B11, C11-B11, B11-C11)');
    sheet1.getRangeByName('D12').setFormula('=IF(C12>B12, C11-B12, B12-C12)');
    sheet1.getRangeByName('D13').setFormula('=IF(C13>B13, C11-B13, B13-C13)');
    sheet1.getRangeByName('D14').setFormula('=IF(C14>B14, C11-B14, B14-C14)');
    sheet1.getRangeByName('D15').setFormula('=IF(C15>B15, C11-B15, B15-C15)');
    sheet1.getRangeByName('D16').setFormula('=IF(C16>B16, C11-B16, B16-C16)');
    sheet1.getRangeByName('D17').setFormula('=IF(C17>B17, C11-B17, B17-C17)');
    sheet1.getRangeByName('D18').setFormula('=IF(C18>B18, C11-B18, B18-C18)');

    final ChartCollection charts = ChartCollection(sheet1);

    final Chart chart = charts.add();
    chart.chartType = ExcelChartType.pie;
    chart.dataRange = sheet1.getRangeByName('A11:B17');
    chart.isSeriesInRows = false;
    chart.chartTitle = "Gastos en eventos";
    sheet1.charts = charts;

    //crear  y abrir file
    List<int> bytes = workbook.saveSync();
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/REPORTE.xlsx';

    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<void> _createExcel() async {
    final workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText('ID');
    sheet.getRangeByName('B1').setText('DESCRIPCIÓN');
    sheet.getRangeByName('C1').setText('LAT');
    sheet.getRangeByName('D1').setText('LONG');
    sheet.getRangeByName('E1').setText('SCORE');
    int rowActual = 2;
    int columnActual = 1;
    await recommendationsReference.get().then((value) {
      QuerySnapshot recommendationsCollection = value;
      List<QueryDocumentSnapshot> docs = recommendationsCollection.docs;

      docs.forEach(
        (element) {
          Map<String, dynamic> myDoc = element.data() as Map<String, dynamic>;
          myDoc['id'] = element.id;
          print(myDoc);
          sheet.getRangeByIndex(rowActual, columnActual).setText(myDoc['id']);
          sheet
              .getRangeByIndex(rowActual, columnActual + 1)
              .setText(myDoc['description']);
          sheet
              .getRangeByIndex(rowActual, columnActual + 2)
              .setText(myDoc['lat'].toString());
          sheet
              .getRangeByIndex(rowActual, columnActual + 3)
              .setText(myDoc['lang'].toString());
          sheet
              .getRangeByIndex(rowActual, columnActual + 4)
              .setText(myDoc['score'].toString());
          setState(() {
            rowActual += 1;
          });
        },
      );
    });

    //GUARDAR Y ABRIR EL DOCUMENTO EN EL CELULAR
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;

    final String fileName = '$path/MyFirstExcel.xlsx';

    final File file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open(fileName);
  }

  Future<void> _exportPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.ListView.builder(
              itemCount: 300,
              itemBuilder: (pw.Context context, int index) {
                return pw.Text("hola $index");
              },
            ),
          ];
        },
      ),
    );
    Uint8List bytes = await pdf.save();
    print(bytes);

    Directory directory = await getApplicationSupportDirectory();
    String fileName = "${directory.path}/reportPdf.pdf";

    File pdfFile = File(fileName);
    await pdfFile.writeAsBytes(bytes, flush: true);

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
