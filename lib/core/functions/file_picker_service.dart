import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:shelter_booking/core/core.dart';

class FilePickerService {
  Future<List<Map<String, dynamic>>> loadCsvData() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final sheltersReference = databaseReference.child("shelters");
    DataSnapshot snapshot = await sheltersReference.get();
    Map<String, dynamic> sheltersData = {};
    List<Map<String, dynamic>> sheltersList = [];
    if (snapshot.value == null) {
      return sheltersList;
    } else {
      // get data from firebase
      sheltersData = convertMap(snapshot.value as Map<Object?, Object?>);
      sheltersData.forEach((key, value) {
        sheltersList.add(convertMap(value as Map<Object?, Object?>));
      });
    }
    return sheltersList;
  }

  Future<List<List<dynamic>>> readCSV() async {
    // Load the CSV file from the assets folder
    String csvString = await rootBundle.loadString('assets/adaposturi.csv');

    // Parse the CSV string
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString, fieldDelimiter: ';', eol: '\n');

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
    uploadDataToFirebase(jsonDataList);
    return jsonString;
  }

  void uploadDataToFirebase(List<Map<String, dynamic>> csvData) async {
    // Initialize Firebase Realtime Database
    final databaseReference = FirebaseDatabase.instance.ref();
    if (await checkIfDataExists()) {
      return;
    } else {
      // Upload data to Firebase
      for (var data in csvData) {
        databaseReference.child("shelters").push().set(data);
      }
    }
  }

  Future<bool> checkIfDataExists() async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // Specify the path to the data you want to check (e.g., "shelters")
    DatabaseReference sheltersReference = databaseReference.child("shelters");

    // Use once() to read data once
    DataSnapshot snapshot = await sheltersReference.get();

    // Check if the snapshot has data
    if (snapshot.value != null) {
      return true;
    } else {
      return false;
    }
  }
}
