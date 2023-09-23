import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recommendationsapp/constants/constants.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key});

  CollectionReference recommendationsReference =
      FirebaseFirestore.instance.collection('recommendations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                fondoBlanco(context),
                StreamBuilder(
                  stream: recommendationsReference.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot recommendationsCollection = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: recommendationsCollection.size,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> myDoc =
                              recommendationsCollection.docs[index].data()
                                  as Map<String, dynamic>;
                          myDoc['id'] =
                              recommendationsCollection.docs[index].id;
                          print(myDoc);
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
