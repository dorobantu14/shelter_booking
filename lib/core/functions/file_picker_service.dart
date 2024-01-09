import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

class FilePickerService {
  Future<List<List<dynamic>>> loadCsvData() async {
    String csvString = await File(
            '/Users/taniadorobantu/StudioProjects/shelter_booking/assets/adaposturi.csv')
        .readAsString();

    List<List<dynamic>> csvTable = const CsvToListConverter().convert(
      csvString.replaceAll(',', '.'), eol: '\n', fieldDelimiter: ';',
    );
    return csvTable;
  }

  String convertToJSON(List<dynamic> csvData) {
    List<String> headers = [
      'județ',
      'localitate',
      'adresa',
      'tip',
      'latitudine',
      'longitudine',
      'capacitate'
    ];

    List<Map<String, dynamic>> jsonDataList = [];

    Map<String, dynamic> jsonData = {};
    for (int i = 0; i < headers.length; i++) {
      jsonData[headers[i]] = csvData[i];
    }
    jsonDataList.add(jsonData);

    String jsonString = jsonEncode(jsonDataList);

    return jsonString;
  }
}
