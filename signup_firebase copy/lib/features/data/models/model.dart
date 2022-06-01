import 'package:cloud_firestore/cloud_firestore.dart';

class data {
  final id;
  final name;

  data(this.id, this.name);


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id
    };
  }

  data.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"];

}