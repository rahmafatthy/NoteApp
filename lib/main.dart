import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/cubit/themecubit.dart';
import 'package:noteapp/hive_hilper.dart';

import 'cubit/note_cubit.dart';
import 'note.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveHelper.notesBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NoteCubit()..getNotes(),
          ),
          BlocProvider(create: (context) => noteCubit())
        ],
        child: BlocBuilder<noteCubit, ThemeData>(
          builder: ((context, state) {
            return MaterialApp(
              theme: state,
              debugShowCheckedModeBanner: false,
              home: note(),
            );
          }),
        ));
  }
}
