import 'package:crud_flutter_firebase/segundo_nivel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'consejo_class.dart';
import 'segundo_nivel.dart';



void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(/*title: 'Listado'*/),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  Future<List<Consejo>> _getConsejos() async{
    var firestore = Firestore.instance;
    var data = await firestore.collection("consejos2").getDocuments();

    List<Consejo> consejos = [];
    int index = 0;

  for(var c in data.documents){      
      index = 0;

      if(c.documentID == '0Tmf4QHrEHKJxnj2ejNw')
      {
        for(int i = 0; i <= c.data.length - 1; i++){
          String item = ("item" + (i+1).toString());        
          Consejo consejo = Consejo(item, data.documents[index].documentID, index, c.data[item][0]['title'], c.data[item][0]['subtitle']);
          consejos.add(consejo);
        }
      }

      index++;  
  }


    return consejos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD - Firebase")
      ),
      body: Container(
        child: FutureBuilder(
          future: _getConsejos(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }  
            else
            {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].subtitle),
                    leading: Icon(Icons.play_arrow),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SegundoNivel(snapshot.data[index])));
                    },
                  );
                } 
              );
            }
          }
        ),
      ),
    );
  }
}

// class SegundoNivel extends StatelessWidget {
//   final Consejo consejo;

//   SegundoNivel(this.consejo);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(consejo.title)
//       ),
//     );
//   }
// }