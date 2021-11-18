import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/shared/cubit.dart';
import 'package:todo_app/shared/states.dart';


//1.create database
//2.create tables
//3.open database
//4.insert database
//5.git from database
//6.delete from database
class TasksScreen extends StatelessWidget {
   TasksScreen({Key? key}) : super(key: key);


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase2(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                cubit
                    .title[cubit
                    .currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isButtonSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    /* AppCubit.get(context).insertToDatabase(
                        date: dateController.text,
                        time: timeController.text,
                        title: titleController.text)
                        .then((value) {
                      Navigator.pop(context);
                      isButtonSheetShow = false;
                      // setState(() {
                      // fabIcon = Icons.edit;
                      //});
                    });

                    */
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (value) {
                                    titleController.text = value.toString();
                                    print(value);
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    label: Text('Task title'),
                                    prefixIcon: Icon(Icons.title),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) {
                                      return {
                                        timeController.text =
                                            value!.format(context).toString(),
                                        print(value.format(context)),
                                      };
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    label: Text('Task time'),
                                    prefixIcon: Icon(Icons.watch),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2050-11-10'),
                                    ).then((value) =>
                                    {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!),
                                      print(
                                          DateFormat.yMMMd().format(value)),
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    label: Text('Task Date'),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ).closed.then((value) {
                   cubit.changeButtonSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeButtonSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit
                  .currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
              onTap: (index) {
               cubit.changeIndex(index);
              },
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) =>
             cubit
                  .screen[cubit
                  .currentIndex],
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}

