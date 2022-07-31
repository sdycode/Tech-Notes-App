

import '../models/notemodel.dart';

updateJsonDataToFirebase()async{
    List _dicts = [
                 
                  {
                    "id": "tCZdkpCQ1FFaoruxrZ5V",
                    "title": "Provider package",
                    "tags": "Flutter",
                    "subtags":
                        "provider__provider package__state__state management ",
                    "note": "Provider package used for state management",
                    "bullets":
                        "data= Provider.of<Data>(context, listen: false);\nHere, listen parameter is used to update UI or not using notifylistener()\nlisten : false --> means UI wont updated i.e build(context) is not callled__listen : false is MUST when we are initialising provider instance outside build method where ( context may or may not available )",
                    "code": "",
                    "time": "2022-07-15 11:56:26.258",
                    "epoch": "0"
                  }
                ];
                for (Map m in _dicts) {
                  // _editingNote = Note(m["title"], m["note"]);
                  // final docNote = noteInstance.doc(m["id"]);
                  Note note = Note(m["title"], m["note"]);
                  note.code = m["code"];
                  note.tags = m["tags"];
                  // note.id = docNote.id;
                  note.bullets = m["bullets"];

                  note.subtags = m["subtags"];
                  note.epoch = DateTime.now().millisecondsSinceEpoch;
                  note.time = DateTime.now();
                  note.author = "sdycode@gmail.com";
                  // fullNoteslist.removeWhere((e) {
                  //   return e.id == m["id"];
                  // });
                  // fullNoteslist.add(note);
                  final json = note.toJson();
                  // await docNote.update(json);
                }
}