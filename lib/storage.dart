import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

Future<String> upload(File file, String basename) async {
  StorageReference ref = FirebaseStorage.instance.ref().child('file/test/${basename}');
  StorageUploadTask uploadTask = ref.putFile(file);

  final storageTaskSnapshot = await uploadTask.onComplete;
  final location = await storageTaskSnapshot.ref.getDownloadURL();

  String name = await ref.getName();
  String bucket = await ref.getBucket();
  String path = await ref.getPath();

  print('Url: ${location.toString()}');
  print('Name: $name');
  print('Bucket: $bucket');
  print('Path: $path');

  return location.toString();
}

Future<String> download(Uri location) async {
  http.Response data = await http.get(location);
  return data.body;
}