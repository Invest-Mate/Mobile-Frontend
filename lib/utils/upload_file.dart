import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class FileUplaod {
  Future<int> updateFundFiles(
      File coverImage, List<File> proofs, String id, String url) async {
    // string to uri
    var uri = Uri.parse(url);
    // create multipart request
    var request = http.MultipartRequest("PUT", uri);
    request.fields["id"] = id;

    // Adding Image Cover
    var coverlength = await coverImage.length();
    // ignore: deprecated_member_use
    var coverImageStream =
        http.ByteStream(DelegatingStream.typed(coverImage.openRead()));
    var coverImageFile = http.MultipartFile(
      'imageCover',
      coverImageStream,
      coverlength,
      filename: basename(coverImage.path),
    );
    // add file to multipart
    request.files.add(coverImageFile);

    //uploading proofs
    for (var proof in proofs) {
      var prooflength = await proof.length();
      // ignore: deprecated_member_use
      var proofStream =
          http.ByteStream(DelegatingStream.typed(proof.openRead()));
      var proofFile = http.MultipartFile(
        'proofs',
        proofStream,
        prooflength,
        filename: basename(proof.path),
      );
      request.files.add(proofFile);
    }
    // send
    var response = await request.send();
    log(response.statusCode.toString());

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      log(value);
    });
    return response.statusCode;
  }
}
