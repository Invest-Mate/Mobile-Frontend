import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class FileUpload {
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
        // ignore: deprecated_member_use
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
      var proofStream = http.ByteStream(proof.openRead());
      proofStream.cast();
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

  Future updateProfile(
      {required File profileImage,
      required String id,
      required String url}) async {
    try {
      // string to uri
      var uri = Uri.parse(url);
      // create multipart request
      var request = http.MultipartRequest("PUT", uri);
      request.fields["id"] = id;
      request.fields["_id"] = id;
      // Adding Image Cover
      var coverlength = await profileImage.length();

      var profileImageStream = http.ByteStream(profileImage.openRead())..cast();

      var profileImageFile = http.MultipartFile(
        'photo',
        profileImage.readAsBytes().asStream(),
        profileImage.lengthSync(),
        filename: basename(profileImage.path),
      );
      request.files.add(profileImageFile);

      // send
      var response = await request.send();
      log(response.statusCode.toString());

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        log(value);
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
