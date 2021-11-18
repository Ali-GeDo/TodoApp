import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/screens/archived_task_screen.dart';
import 'package:todo_app/screens/done_tasks_screen.dart';
import 'package:todo_app/screens/new_task_screen.dart';
import 'package:todo_app/shared/states.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> title = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  List<Widget> screen = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];

  Database? database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase2() {
    openDatabase('todo4.db', version: 1, onCreate: (database, version) {
      print('Database created');
      database.execute("CREATE TABLE tasks("
          "'id' INTEGER PRIMARY KEY,"
          "'title' TEXT,"
          "'date' TEXT,"
          "'time' TEXT,"
          "'status' TEXT)");
    }, onOpen: (database) {
      getFromDatabase(database);
      print('Database opened');
    }).then((value) => {
          database = value,
      print(value),
          emit(AppCreateDatabaseState()),
        });
  }

   insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
     await database!.transaction((txn) async {
      txn.rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")').then((value) {
        print('$value data inserted');
        emit(AppInsertDatabaseState());

        getFromDatabase(database!);
      }).catchError((error) {});
      // print('data inserted');
    });
  }

  void getFromDatabase(Database database)  {
    newtasks=[];
    donetasks=[];
    archivedtasks=[];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element) {
         if(element['status']=='new') newtasks.add(element);
        else if(element['status']=='done') donetasks.add(element);
         else  archivedtasks.add(element);
        // print(element['status']);
       });
       emit(AppGetDatabaseState());
     });

  }


  void UpdateDatabase({
    required String status,
    required int id,
  })async
  {
      await database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
          getFromDatabase(database!);
      emit(AppUpdateDatabaseLoadingState());
    });
  }

  void deleteDatabase({
    required int id,
  })async
  {
    await database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getFromDatabase(database!);
      emit(AppDeleteDatabaseLoadingState());
    });
  }

  bool isButtonSheetShow = false;
  IconData? fabIcon =Icons.edit;

  void changeButtonSheetState({
    required bool isShow ,
    required IconData icon,
})
  {
    isButtonSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
