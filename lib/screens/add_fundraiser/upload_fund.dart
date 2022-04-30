import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/utils/upload_file.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:http/http.dart' as http;

class UploadFund {
  Future<bool> createNewFund({
    required String title,
    required String category,
    required String userId,
    required String description,
    required double amount,
    required DateTime lastdate,
    required List<File> proofs,
    required File bannerImage,
  }) async {
    String ipAddress = await Ipify.ipv64();
    log("IP ADDRESS IS: " + ipAddress);

    // uploading initial data
    final uri = Uri.parse("https://fundzer.herokuapp.com/api/fund/create-fund");
    final createFundRes = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "title": title,
        "category": category,
        "createdBy": userId,
        "description": description,
        "projectedAmount": amount,
        "ip": ipAddress,
        "lastDate": lastdate.toIso8601String(),
        "deadline": lastdate.toIso8601String(),
        "numOfPeople": 0,
      }),
    );

    final response = jsonDecode(createFundRes.body);
    String documentId = response["data"]["data"]["_id"];
    log("Document id: " + documentId);

    // uploading image files through patch
    final file = FileUplaod();
    int fileUploadStatusCode = await file.updateFundFiles(
      bannerImage,
      proofs,
      documentId,
      "https://fundzer.herokuapp.com/api/fund/update-fund",
    );

    log(
      fileUploadStatusCode.toString() +
          ", " +
          createFundRes.statusCode.toString(),
    );
    if (fileUploadStatusCode == 200 && createFundRes.statusCode == 201) {
      return true;
    }
    return false;
  }
}
