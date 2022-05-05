import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
      var proofStream = http.ByteStream(proof.openRead())..cast();
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
      // // string to uri
      // var uri = Uri.parse(url);
      // // create multipart request
      // var request = http.MultipartRequest("PUT", uri);
      // request.fields["id"] = id;
      // request.fields["_id"] = id;
      // // Adding Image Cover
      // var coverlength = await profileImage.length();

      // var profileImageStream = http.ByteStream(profileImage.openRead())..cast();

      var profileImageFile = http.MultipartFile(
        'photo',
        profileImage.readAsBytes().asStream(),
        profileImage.lengthSync(),
        filename: basename(profileImage.path),
      );
      // request.files.add(profileImageFile);

      // // send
      // var response = await request.send();
      // log(response.statusCode.toString());

      // // listen for response
      // response.stream.transform(utf8.decoder).listen((value) {
      //   log(value);
      // });
      log("id is : " + id);
      try {
        ///[1] CREATING INSTANCE
        var dioRequest = dio.Dio();
        dioRequest.options.baseUrl =
            'https://fundzer.herokuapp.com/api/user/update-user';

        //[2] ADDING TOKEN
        dioRequest.options.headers = {
          'Content-Type': 'application/x-www-form-urlencoded'
        };

        //[3] ADDING EXTRA INFO
        var formData = dio.FormData.fromMap({'id': id, '_id': id});

        //[4] ADD IMAGE TO UPLOAD
        var file = await dio.MultipartFile.fromFile(
          profileImage.path,
          filename: basename(profileImage.path),
          contentType: MediaType("image", basename(profileImage.path)),
        );

        formData.files.add(MapEntry('photo', file));

        //[5] SEND TO SERVER
        var response = await dioRequest.post(
          url,
          data: formData,
        );
        final result = json.decode(response.toString())['result'];
        log(result.toString());
      } catch (err) {
        log('ERROR  $err');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
