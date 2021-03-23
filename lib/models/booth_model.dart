import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './contact_model.dart';

class BoothModel {
  String id;
  String lac;
  String pollingStation;
  String lsgi;
  ContactModel contactModel;
  BoothModel({
    this.id,
    this.lac,
    this.pollingStation,
    this.lsgi,
    this.contactModel,
  });
  factory BoothModel.fromDocument(QueryDocumentSnapshot snapshot) {
    return BoothModel(
      id: snapshot.id,
      lac: snapshot.data()['lac'],
      pollingStation: snapshot.data()['pollingStation'],
      lsgi: snapshot.data()['lsgi'],
      contactModel: ContactModel(
        adpaName: snapshot.data()['adpaName'],
        adpaNumber: snapshot.data()['adpaNumber'].toString(),
        operatorName: snapshot.data()['operatorName'],
        operatorNumber: snapshot.data()['operatorNumber'].toString(),
        hseName: snapshot.data()['hseName'],
        hseNumber: snapshot.data()['hseNumber'].toString(),
        taName: snapshot.data()['taName'],
        taNumber: snapshot.data()['taNumber'].toString(),
        bsnlName: snapshot.data()['bsnlName'],
        bsnlNumber: snapshot.data()['bsnlNumber'].toString(),
        sectorName: snapshot.data()['sectorName'],
        sectorNumber: snapshot.data()['sectorNumber'].toString(),
      ),
    );
  }
  factory BoothModel.fromRealtimeDocument(dynamic snapshot) {
    return BoothModel(
      id: snapshot['id'].toString(),
      lac: snapshot['lac'].toString(),
      pollingStation: snapshot['pollingStation'],
      lsgi: snapshot['lsgi'],
      contactModel: ContactModel(
        adpaName: snapshot['adpaName'],
        adpaNumber: snapshot['adpaNumber'].toString(),
        operatorName: snapshot['operatorName'],
        operatorNumber: snapshot['operatorNumber'].toString(),
        hseName: snapshot['hseName'],
        hseNumber: snapshot['hseNumber'].toString(),
        taName: snapshot['taName'],
        taNumber: snapshot['taNumber'].toString(),
        bsnlName: snapshot['bsnlName'],
        bsnlNumber: snapshot['bsnlNumber'].toString(),
        sectorName: snapshot['sectorName'],
        sectorNumber: snapshot['sectorNumber'].toString(),
      ),
    );
  }
  Map<String, String> toJson() {
    return {
      'id': this.id,
      'lac': this.lac,
      'pollingStation': this.pollingStation,
      'lsgi': this.lsgi,
      'adpaName': this.contactModel.adpaName,
      'adpaNumber': this.contactModel.adpaNumber,
      'operatorName': this.contactModel.operatorName,
      'operatorNumber': this.contactModel.operatorNumber,
      'hseName': this.contactModel.hseName,
      'hseNumber': this.contactModel.hseNumber,
      'taName': this.contactModel.taName,
      'taNumber': this.contactModel.taNumber,
      'bsnlName': this.contactModel.bsnlName,
      'bsnlNumber': this.contactModel.bsnlNumber,
      'sectorName': this.contactModel.sectorName,
      'sectorNumber': this.contactModel.sectorNumber,
    };
  }

  factory BoothModel.fromJson(Map<String, dynamic> booth) {
    return BoothModel(
      id: booth['id'],
      lac: booth['lac'],
      pollingStation: booth['pollingStation'],
      lsgi: booth['lsgi'],
      contactModel: ContactModel(
        adpaName: booth['adpaName'],
        adpaNumber: booth['adpaNumber'],
        operatorName: booth['operatorName'],
        operatorNumber: booth['operatorNumber'],
        hseName: booth['hseName'],
        hseNumber: booth['hseNumber'],
        taName: booth['taName'],
        taNumber: booth['taNumber'],
        bsnlName: booth['bsnlName'],
        bsnlNumber: booth['bsnlNumber'],
        sectorName: booth['sectorName'],
        sectorNumber: booth['sectorNumber'],
      ),
    );
  }

  bool isEqual(BoothModel model) {
    return this?.id == model?.id;
  }

  String boothAsString() {
    return '${this.id}. ${this.pollingStation}';
  }
}
