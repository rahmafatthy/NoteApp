import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../hive_hilper.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());

  void getNotes() {
    HiveHelper.getNotes();
  }

  void addNote(String text) {
    HiveHelper.addNote(text);
    emit(NoteGetSuccess());
  }

  void removeAll() {
    HiveHelper.removeAllNote();
    emit(NoteGetSuccess());
  }

  void updateNote(String text, int index) {
    HiveHelper.updateNote(text, index);
    emit(NoteGetSuccess());
  }
}
