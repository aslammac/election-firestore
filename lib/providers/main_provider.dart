import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
//models
import '../models/booth_model.dart';
import '../models/contact_model.dart';
//pages
import '../screen/contact_screen.dart';

class MainProvider with ChangeNotifier {
  final firebase = cloud.FirebaseFirestore.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  bool _isLoading = true;
  String _lacName;
  BoothModel _pollingStationName;
  BoothModel _pollingStationNameTemp;
  List<String> _lacList = [
    'ERANAD',
    'KONDOTTY',
    'KOTTAKKAL',
    'MALAPPURAM',
    'MANJERI',
    'MANKADA',
    'NILAMBUR',
    'PERINTHALMANNA',
    'PONNANI',
    'TANUR',
    'THAVANUR',
    'TIRUR',
    'TIRURANGADI',
    'VALLIKKUNNU',
    'VENGARA',
    'WANDOOR'
  ];
  List<BoothModel> _pollingStationList = [];
  String get lacName {
    return _lacName;
  }

  BoothModel get pollingStationName {
    return _pollingStationName;
  }

  BoothModel get pollingStationNameTemp {
    return _pollingStationNameTemp;
  }

  List<String> get lacList {
    return _lacList;
  }

  List<BoothModel> get pollingStaionList {
    return _pollingStationList;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<void> fetchBooth(String lac) async {
    _lacName = lac;
    _isLoading = true;
    _pollingStationNameTemp = null;
    notifyListeners();
    _pollingStationList = [];
    final prefs = await SharedPreferences.getInstance();
    final cloud.DocumentReference cacheDocRef =
        cloud.FirebaseFirestore.instance.doc('status/status');

    final String cacheField = 'time';

    final cloud.Query query =
        firebase.collection('booth').where('lac', isEqualTo: lac.trim());
    try {
      final cloud.QuerySnapshot snapshot = await FirestoreCache.getDocuments(
        query: query,
        cacheDocRef: cacheDocRef,
        firestoreCacheField: cacheField,
        localCacheKey: 'time',
      );
      await prefs.setString('time', DateTime.now().toIso8601String());
      snapshot.docs.forEach((element) {
        _pollingStationList.add(BoothModel.fromDocument(element));
      });
    } catch (e) {
      throw e;
    }

    // if (_pollingStationList.isNotEmpty) {
    //   _isLoading = false;
    // }
    notifyListeners();
    // firebase
    //     .collection('booth')
    //     .where('lac', isEqualTo: lac.trim())
    //     .get()
    //     .then((value) => print(value.docs.length));
  }

  Future<BoothModel> fetchRecent() async {
    readData();
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> booth = await jsonDecode(prefs.getString('booth'));
    if (booth != null) {
      return BoothModel.fromJson(booth);
    }
    return null;
  }

  void readData() {
    final ref = databaseReference
        .child('1844vNCBfUOZWF8RGWbJZsUxJB-1AGrMNLJpVLT6R2Jo')
        .child('primary')
        .orderByChild('lac')
        .equalTo('KONDOTTY')
        .once()
        .then((snapshot) {
      // List<dynamic> results = snapshot.value;
      // results.removeAt(0);
      // results.forEach((value) {
      //   BoothModel model = BoothModel.fromRealtimeDocument(value);

      //   print(model.lsgi);
      // });
      // // BoothModel model = BoothModel.fromRealtimeDocument(snapshot.value[1]);
      // print('${snapshot.value[1]}');
      // print('${snapshot.key}');
    });
    //     .then((DataSnapshot snapshot) {
    //   BoothModel model = BoothModel.fromRealtimeDocument(snapshot);
    //   print(model.lsgi);
    //   print('${snapshot.value}');
    // });
  }

  void selectPollingBooth(BoothModel booth) async {
    final prefs = await SharedPreferences.getInstance();
    _isLoading = false;
    _pollingStationNameTemp = booth;
    _pollingStationName = booth;
    await prefs.setString('booth', jsonEncode(booth.toJson()));
    notifyListeners();
  }

  void searchContact(BuildContext context, {BoothModel booth}) {
    if (booth != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactScreen(booth)),
      );
      return;
    }
    if (_pollingStationNameTemp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select polling Station'),
        ),
      );
      return;
    }
    if (_pollingStationName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactScreen(_pollingStationName)),
      );
      // _isLoading = true;
      // _pollingStationNameTemp = null;
      // _pollingStationList = [];
      notifyListeners();
    }

    print(_pollingStationName.pollingStation);
  }
}
