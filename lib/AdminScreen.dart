import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

class adminScreen extends StatefulWidget {
  @override
  _adminScreenState createState() => _adminScreenState();
}

class _adminScreenState extends State<adminScreen> {

  int getValuesOneTime = 0;
  String segunda ="carregando...", terca ="carregando...", quarta ="carregando...", quinta ="carregando...", sexta ="carregando...", sabado ="carregando...";


  @override
  Widget build(BuildContext context) {

    if (getValuesOneTime == 0)
    getAgendedCuts(); // as soon as the page is oppened the caling of the agended cuts will be made

    return Scaffold(
      appBar: AppBar(
        title: Text('RusticCut Admin menu'),
      ),
      backgroundColor: Colors.black,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        new Image(
          image: new AssetImage("assets/girl.jpeg"),
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),
        new Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                new TextStyle(color: Colors.deepOrangeAccent, fontSize: 25.0),
              )),
          isMaterialAppTheme: true,
          child: SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  new Container(


                    padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                    child: new Form(
                      autovalidate: true,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('Segunda Feira',),
                              subtitle: Text(segunda.toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('Terça Feira'),
                            subtitle: Text(terca.toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('Quarta Feira'),
                            subtitle: Text(quarta.toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('Quinta Feira'),
                            subtitle: Text(quinta.toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('Sexta Feira'),
                            subtitle: Text(sexta.toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('Sábado'),
                            subtitle: Text(sabado.toString()),
                          ),


                          new Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                          new MaterialButton(

                            height: 50.0,
                            minWidth: 150.0,
                            color: Colors.orange,
                            splashColor: Colors.orange,
                            textColor: Colors.white,
                            child: Text('Atualizar'),
                            onPressed: () {

                              //REFRESHES THE DATA
                              getAgendedCuts(); // refresh all the days

                            },
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
          )
        ),
      ]),

    );
  }

  File cachedFile;// this file holds one day of agended cuts

  Future<void> getAgendedCuts () async{


    await downloadAgended("1");
    await downloadAgended("2");
    await downloadAgended("3");
    await downloadAgended("4");
    await downloadAgended("5");
    await downloadAgended("6");



  }




  Future <Null> downloadAgended(String dia) async {



    final String fileName = "infoCliente";
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');

    final StorageReference ref = FirebaseStorage.instance.ref().child("agenda/dia"+dia);
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);

    final int byteNumber = (await downloadTask.future).totalByteCount;

    getValuesOneTime = 1;
    setState(() => cachedFile = file);

    var strings = cachedFile.readAsStringSync().split("\n");
    var i;
    String aux = "";
    for (i =1; i<strings.length ; i++){
      strings[i] =  strings[i].replaceAll('||', ': ');
      aux+= strings[i] + "\n";
      print(strings[i]);
    }


    if (dia == "1") segunda = aux;
    if (dia == "2") terca = aux;
    if (dia == "3") quarta = aux;
    if (dia == "4") quinta = aux;
    if (dia == "5") sexta = aux;
    if (dia == "6") sabado = aux;

  }
}
