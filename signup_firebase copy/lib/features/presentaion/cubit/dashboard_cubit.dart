import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup_firebase/features/presentaion/cubit/dashboad_state.dart';
import 'package:signup_firebase/features/data/models/model.dart';


class DashCubit extends Cubit<DashBoardInit>{
  DashCubit() : super(DashBoardData());


  void DataDisplay() async{


  }
  void Textchanged(val){
    if(val.isEmpty || val == null){
      emit(TextError());
    }else{
      emit(TextValid());
    }
  }


  void deleteProduct(String productId) async {
    final CollectionReference _productss = FirebaseFirestore.instance.collection('user');
    await _productss.doc(productId).delete();
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('You have successfully deleted a user')));
  }

  void Update(String docId,String name)async{
    final CollectionReference _productss = FirebaseFirestore.instance.collection('user');
    await _productss.doc(docId).update({"name":name});
  }

  void addData(String name)async{
    final CollectionReference _productss = FirebaseFirestore.instance.collection('user');
    await _productss.add({'name': name});
  }

  Future<List<data>> retrieveData() async {
    print('retrive data');
    final FirebaseFirestore _productss = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _productss.collection("user").get();
    var d=snapshot.docs
        .map((docSnapshot) => data.fromDocumentSnapshot(docSnapshot))
        .toList();
    d.forEach((element) {
      debugPrint(element.toString());
    });

    return snapshot.docs
        .map((docSnapshot) => data.fromDocumentSnapshot(docSnapshot))
        .toList();

 }
}