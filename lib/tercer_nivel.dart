import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'consejo_class.dart';


class TercerNivel extends StatelessWidget {
  final Consejo consejo;
  TercerNivel(this.consejo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(consejo.title)
      ),
      body: MyContentPage(indexCollection: consejo.index, parent: consejo.parent),
    );
  }
 
}

class MyContentPage extends StatefulWidget {
  final int indexCollection;
  final String parent;

  MyContentPage({Key key, this.indexCollection, this.parent}) : super(key: key);
  
  @override
  _MyContentPageState createState() => _MyContentPageState(indexCollection: indexCollection, parent: parent);
}
class _MyContentPageState extends State<MyContentPage> {
  final int indexCollection;
  final String parent;

  _MyContentPageState({Key key, this.indexCollection, this.parent});

  Future<List<Consejo>> _getConsejos() async{
    var firestore = Firestore.instance;
    var data = await firestore.collection("consejos2").getDocuments();
    print(indexCollection);

    List<Consejo> consejos = [];
    int index = 0;
    
    for(var c in data.documents){
      if(c.documentID == 'NdcnHXWpzW2LFjk1kJAe')
      {     
        index = 0;    
        for(var k in c.data.keys){
          int indiceSubstring = k.indexOf(".", (k.indexOf(".") + 1));
          String key =  k.substring(0, indiceSubstring);        

          if(key == parent){
            String item = parent + "." + (index + 1).toString();
            Consejo consejo = Consejo(parent, data.documents[index].documentID, index, c.data[item][0]['title'], c.data[item][0]['subtitle']);
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
                  );
                } 
              );
            }
          }
        ),
      );
  }
}
