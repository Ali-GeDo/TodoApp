import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/components.dart';
import 'package:todo_app/shared/cubit.dart';
import 'package:todo_app/shared/states.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppState>(
      listener: (context ,state){},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newtasks;
      return  tasksBuilder(tasks: tasks);
      }
    );
  }

     
}

