import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GamerTag',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameTags(),
    );
  }
}

class GameTags extends StatefulWidget {
  @override
    GameTagsState createState() => GameTagsState();
}

class GameTag {
  String gameName = "";
  String gameTag ="";
  String gameLogo ="";
  GameTag();
  GameTag.init(this.gameName, this.gameTag, this.gameLogo);

  Map<String, dynamic> toJson() => {
    'gameName': gameName,
    'gameTag': gameTag,
    'gameLogo': gameLogo,
  };

  GameTag.fromJson(Map<String, dynamic> json)
      : gameName = json['gameName'],
        gameTag = json['gameTag'],
        gameLogo = json['gameLogo'];

}

class GameTagsState extends State<GameTags> {
  List<GameTag> _myGameTags = <GameTag>[];

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My games"),
      ),
      body: _buildTags(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(context: context, child: _buildCreateTagDialog()),
        tooltip: 'Add a new game',
        child: const Icon(Icons.add),
      ),
    );
  }

  _loadTags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var tags = jsonDecode(prefs.get("tags"));
      print("Tags loaded : " + prefs.get("tags"));
        _myGameTags = tags.map<GameTag>((json) => GameTag.fromJson(json)).toList();
    });
  }

  _updateTags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("tags", jsonEncode(_myGameTags));
      print("Tags updated : " + prefs.get("tags"));
    });
  }

  Widget _buildCreateTagDialog() {
    var _newGameTag = GameTag();
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    var _game = "";
    var platforms = [
      GameTag(),
      GameTag.init("Steam", null, "steam.png"),
      GameTag.init("League of Legends", null, "lol.png"),
      GameTag.init("Battle.net", null, "bnet.png")] ;

    void _submitForm() {
      final FormState form = _formKey.currentState;
      form.save();
      print(_newGameTag.gameTag);
      _myGameTags.add(_newGameTag);
      print(_myGameTags.last.gameName);
     }

     return new AlertDialog(
        title: Text("Add new game"),
        content: new Form(
          key: _formKey,
          child: new Column(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Enter your nickname"
              ),
              onSaved: (val) => _newGameTag.gameTag = val,
            ),
            new FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.gamepad),
                    labelText: 'Select a game',
                    errorText: state.hasError ? state.errorText : null,
                  ),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      isDense: true,
                      value: _game,
                      items: platforms.map((GameTag game) {
                        return new DropdownMenuItem<String>(
                          value: game.gameName,
                          child: new Text(game.gameName),
                        );
                      }).toList(),
                    onChanged: (val){
                        setState(() {
                          var _selectedGame = platforms.firstWhere((elt) => elt.gameName == val);
                          _newGameTag.gameName = _selectedGame.gameName;
                          _newGameTag.gameLogo = _selectedGame.gameLogo;
                          _game = val;
                          state.didChange(_selectedGame.gameName);
                        });
                        },
                    ),
                  ),
                );
              },
              validator: (val) {
                return val != '' ? null : 'Please select a color';
              }
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  _submitForm();
                  _updateTags();
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text('Submit'),
              ),
            ),
          ],
          ),
        )
    );
  }



  Widget _buildTags() {
    List<Widget> list = new List<Widget>();
    for (var tag in _myGameTags){
      list.add(_buildRow(tag));
    }
    return new ListView(children: list,
    padding: const EdgeInsets.all(16.0),);
  }

  Widget _buildRow(GameTag gameTag) {
    return Card(
      child: ListTile(
      leading: Image(image: AssetImage("lib/assets/" + gameTag.gameLogo))
    ,
        title: Text(
        gameTag.gameName
    ),
      subtitle: Text(
        gameTag.gameTag,
        style: TextStyle(color: Colors.black),
      ),
      )
    ) ;
  }


}
