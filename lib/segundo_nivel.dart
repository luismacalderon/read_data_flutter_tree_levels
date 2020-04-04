import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_flutter_firebase/tercer_nivel.dart';
import 'package:flutter/material.dart';
import 'consejo_class.dart';


class SegundoNivel extends StatelessWidget {
  final Consejo consejo;

  SegundoNivel(this.consejo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(consejo.title)
      ),
      body: MyContentPage(documentID: consejo.documentID, parent: consejo.parent,),
    );
  }
 
}

class MyContentPage extends StatefulWidget {
  final String documentID;
  final String parent;

  MyContentPage({Key key, this.documentID, this.parent}) : super(key: key);

  @override
  _MyContentPageState createState() => _MyContentPageState(documentID: documentID, parent: parent);
}
class _MyContentPageState extends State<MyContentPage> {
  final String documentID;
  final String parent;

  _MyContentPageState({Key key, this.documentID, this.parent});

  Future<List<Consejo>> _getConsejos() async{
    var firestore = Firestore.instance;
    var data = await firestore.collection("consejos2").getDocuments();
   
    List<Consejo> consejos = [];
    int index = 0;

    for(var c in data.documents){
      if(c.documentID == 'GGyz0uCVnJ662dSARh1F')
      {     
        index = 0;    
        for(var k in c.data.keys){
          print(k.indexOf('.'));          
          String key = k.substring(0, 5);
          if(key == parent){
            String item = parent + "." + (index + 1).toString();
            Consejo consejo = Consejo(item, data.documents[index].documentID, index, c.data[item][0]['title'], c.data[item][0]['subtitle']);
            consejos.add(consejo);
            index++;
          }
        }
      }
    }

    return consejos;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: FutureBuilder(
          future: _getConsejos(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: CircularProgressIndicator()
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TercerNivel(snapshot.data[index])));
                    },
                  );
                } 
              );
            }
          }
        ),
      );
  }
}
