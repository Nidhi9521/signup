import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_firebase/features/presentaion/cubit/dashboad_state.dart';
import 'package:signup_firebase/features/presentaion/cubit/dashboard_cubit.dart';
import 'package:signup_firebase/features/data/models/model.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<data>>? dataList;

  final TextEditingController _nameController = TextEditingController();
  final CollectionReference _productss =
      FirebaseFirestore.instance.collection('user');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    String? a;
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
    }
    AlertDialog alert = AlertDialog(
      actions: [
        BlocBuilder<DashCubit, DashBoardInit>(builder: (context, state) {
          return TextField(
            onChanged: (val) {
              BlocProvider.of<DashCubit>(context).Textchanged(val.toString());
            },
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: state is TextError ? 'pls enter data' : null,
            ),
          );
        }),
        BlocBuilder<DashCubit, DashBoardInit>(builder: (context, state) {
          return ElevatedButton(
            child: Text(action == 'create' ? 'Create' : 'Update'),
            onPressed: () async {
              final String? name = _nameController.text;
              if (name != null) {
                if (action == 'create') {
                  if (state is TextValid) {
                    context.read<DashCubit>().addData(name);
                  }else{
                    print('error');
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('error')));
                  }
                }
                if (action == 'update') {
                    context.read<DashCubit>().Update(documentSnapshot!.id, name);
                }
                _nameController.text = '';
                Navigator.of(context).pop();
              }
            },
          );
        })
      ],
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(create: (context) => DashCubit(), child: alert);
      },
    );

    // await showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (BuildContext ctx) {
    //       return Padding(
    //         padding: EdgeInsets.only(
    //             top: 20,
    //             left: 20,
    //             right: 20,
    //             bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             TextField(
    //               controller: _nameController,
    //               decoration: const InputDecoration(labelText: 'Name'),
    //             ),
    //             // TextField(
    //             //   keyboardType:
    //             //   const TextInputType.numberWithOptions(decimal: true),
    //             //   controller: _priceController,
    //             //   decoration: const InputDecoration(
    //             //     labelText: 'Price',
    //             //   ),
    //             // ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             ElevatedButton(
    //               child: Text(action == 'create' ? 'Create' : 'Update'),
    //               onPressed: () async {
    //                 final String? name = _nameController.text;
    //                 if (name != null ) {
    //                   if (action == 'create') {
    //                     await _productss.add({"name": name});
    //                   }
    //
    //                   if (action == 'update') {
    //                     await _productss
    //                         .doc(documentSnapshot!.id)
    //                         .update({"name": name});
    //                   }
    //                   _nameController.text = '';
    //                   Navigator.of(context).pop();
    //                 }
    //               },
    //             )
    //           ],
    //         ),
    //       );
    //     });
  }

  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a user')));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: const Text('CRUD operation'),
            automaticallyImplyLeading: false,
            actions: [
              // FlatButton(
              //     onPressed: () {
              //       debugPrint('retrive click');
              //       print('hello');
              //       dataList = context.read<DashCubit>().retrieveData();
              //       //debugPrint(dataList.value['name']);
              //     },
              //     child: Text('retrive')),
              TextButton(
                  child: Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    print('Log out');
                    debugPrint('Log out');

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('email');
                    //_navigateToLoginScreen(context);
                    //Navigator.of(context).pushNamedAndRemoveUntil('/screen2', ModalRoute.withName('/screen1'));
                    Navigator.of(context).pushNamedAndRemoveUntil('/screen2', (Route<dynamic> route) => false);
                  })
            ],
          ),
          body: StreamBuilder(
            stream: _productss.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['name']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _createOrUpdate(documentSnapshot)),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      //_deleteProduct(documentSnapshot.id)
                                      context
                                      .read<DashCubit>()
                                      .deleteProduct(documentSnapshot.id)
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _createOrUpdate(),
            child: const Icon(Icons.add),
          ),
        );
  }


}
