import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recommendationsapp/constants/constants.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  CollectionReference recommendationsReference =
      FirebaseFirestore.instance.collection('recommendations');

  Widget stream() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: StreamBuilder(
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
                myDoc['id'] = recommendationsCollection.docs[index].id;
                print(myDoc);
                return Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  color: Colors.cyan.shade800,
                  child: ListTile(
                    // hoverColor: Colors.red,
                    // color
                    title: Text(
                      myDoc["description"],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      myDoc["score"].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Lat: ${myDoc['lat']} , Lon: ${myDoc['lang']}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

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
                fondoBlanco(context, stream()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
