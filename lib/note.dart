import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/cubit/note_cubit.dart';
import 'package:noteapp/hive_hilper.dart';

import 'cubit/themecubit.dart';

class note extends StatelessWidget {
  note({super.key});

  final _notecontroller = TextEditingController();
  bool _iconBool = true;
  IconData _iconLight = Icons.wb_sunny;
  IconData _iconDark = Icons.nights_stay;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NoteCubit>();
    final cubitTheme = context.read<noteCubit>();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _notecontroller.clear();

            // set up the button
            Widget okButton = TextButton(
              child: Text("Save"),
              onPressed: () {
                if (_notecontroller.text.isNotEmpty) {
                  cubit.addNote(_notecontroller.text);
                  Navigator.pop(context);
                }
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("Add your note"),
              backgroundColor: Colors.white,
              content: TextFormField(
                controller: _notecontroller,
              ),
              actions: [
                okButton,
              ],
            );

            // show the dialog
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
          backgroundColor: Colors.lightBlueAccent.withOpacity(0.6),
          child: Icon(
            Icons.add,
            // color: Colors.white,
            size: 35,
          ),
        ),
        // backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Note",
            style: TextStyle(
                color: Colors.lightBlueAccent.withOpacity(0.8),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  cubitTheme.toggleTheme();
                },
                icon: Icon(
                  cubitTheme.state == ThemeData.dark() ? _iconDark : _iconLight,
                )),
            _actionicon(
                icon: Icons.delete_forever_outlined,
                ontap: () {
                  cubit.removeAll();
                }),
          ],
        ),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: HiveHelper.noteList.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () async {
                  _notecontroller.text = HiveHelper.noteList[index];
                  Widget okButton = TextButton(
                    child: Text("Save"),
                    onPressed: () {
                      if (_notecontroller.text.isNotEmpty) {
                        cubit.updateNote(_notecontroller.text, index);
                        Navigator.pop(context);
                      }
                    },
                  );

                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("Add your note"),
                    backgroundColor: Colors.white,
                    content: TextFormField(
                      controller: _notecontroller,
                    ),
                    actions: [
                      okButton,
                    ],
                  );

                  // show the dialog
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                child: Dismissible(
                  onDismissed: (val) {
                    HiveHelper.removeNote(index);
                  },
                  background: Container(
                    color: Colors.cyan,
                  ),
                  secondaryBackground: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 30,
                        ),
                        Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  key: UniqueKey(),
                  child: Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Color.fromRGBO(255, 140, 0, 0.8)
                              : Colors.lightBlueAccent.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        HiveHelper.noteList[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

Widget _actionicon({required IconData icon, void Function()? ontap}) {
  return InkWell(
    onTap: ontap,
    child: Container(
      margin: EdgeInsets.all(5),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        //  color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        //color: Colors.white.withOpacity(0.89),
        size: 32,
      ),
    ),
  );
}
