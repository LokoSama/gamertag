import 'package:flutter/material.dart';

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

}

class GameTagsState extends State<GameTags> {
  final List<GameTag> _myGameTags = <GameTag>[];

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

  Widget _buildCreateTagDialog() {
    var _newGameTag = GameTag();
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    var _game = "";
    var platforms = [
      GameTag(),
      GameTag.init("Steam", null, "steam.png"),
      GameTag.init("League of Legends", null, "lol.png"),
      GameTag.init("Battle.net", null, "battlennet.png")] ;

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
      leading: FlutterLogo(size: 72.0),
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
