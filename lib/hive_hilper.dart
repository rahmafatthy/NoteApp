import 'package:hive/hive.dart';

class HiveHelper {
  static var notesBox = 'MyBox';
  static var notesBoxKey = "notesBoxKey";
  static List<String> noteList = [];
  static var myBox = Hive.box(notesBox);

  static void addNote(String text) async {
    noteList.add(text);
    await myBox.put(notesBoxKey, noteList);
  }

  static void removeAllNote() async {
    noteList.clear();
    await myBox.put(notesBoxKey, noteList);
  }

  static void removeNote(int index) async {
    noteList.removeAt(index);
    await myBox.put(notesBoxKey, noteList);
  }

  static void updateNote(String text, int index) async {
    noteList[index] = text;
    await myBox.put(notesBoxKey, noteList);
  }

  static void getNotes() {
    if (myBox.isNotEmpty) {
      noteList = myBox.get(notesBoxKey);
    }
  }
}
