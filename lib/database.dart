import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

int _counter = 0;
int get counter => _counter;

DatabaseReference counterRef;

init() async {
  final database = FirebaseDatabase.instance
    ..setPersistenceEnabled(true)
    ..setPersistenceCacheSizeBytes(10000000);
  counterRef = database.reference().child('test/counter')..keepSynced(true);
  _counter = await getCounter() ?? 0;
}

Future<int> getCounter() async {
  return await counterRef.once().then((DataSnapshot snapshot) {
    print('Connected to the database and read: ${snapshot.value}');
    return snapshot.value;
  });
}

Future<void> setCounter(int value) async {
  final result = await counterRef.runTransaction((MutableData mutableData) async {
    mutableData.value = value;
    return mutableData;
  });

  if (result.committed) {
    _counter = result.dataSnapshot.value;
    print('Saved value to the database');
  } else {
    print('Failed to save to the database!');
    throw result.error;
  }
}
