import 'package:recommendationsapp/pages/add_page.dart';
import 'package:recommendationsapp/pages/list_page.dart';

final List<Map<String, dynamic>> pageDetails = [
  {
    'pageName': ListPage(),
    'title': "Lista de recomendaciones",
  },
  {
    'pageName': AddPage(),
    'title': "Agregar recomendación",
  }
];
