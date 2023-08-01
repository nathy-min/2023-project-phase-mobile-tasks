import 'dart:io';

class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}

class TaskManager {
  List<Task> _tasks = [];

  void addTask(Task task) {
    _tasks.add(task);
  }

  List<Task> viewAllTasks() {
    return _tasks;
  }

  List<Task> viewCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<Task> viewPendingTasks() {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  void markTaskAsCompleted(Task task) {
    task.isCompleted = true;
  }

  void markTaskAsPending(Task task) {
    task.isCompleted = false;
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
  }
}

void printTaskList(List<Task> tasks) {
  for (var i = 0; i < tasks.length; i++) {
    var task = tasks[i];
    print('Task ${i + 1}:');
    print('Title: ${task.title}');
    print('Description: ${task.description}');
    print('Due Date: ${task.dueDate}');
    print('Status: ${task.isCompleted ? "Completed" : "Pending"}');
    print('');
  }
}

void main() {
  TaskManager taskManager = TaskManager();

  while (true) {
    print('Task Manager Application');
    print('1. Add Task');
    print('2. View All Tasks');
    print('3. View Completed Tasks');
    print('4. View Pending Tasks');
    print('5. Mark Task as Completed');
    print('6. Mark Task as Pending');
    print('7. Delete Task');
    print('8. Exit');
    stdout.write('Enter your choice (1-8): ');
    var choice = stdin.readLineSync();

    switch (int.tryParse(choice ?? '') ?? 0) {
      case 1:
        stdout.write('Enter task title: ');
        var title = stdin.readLineSync() ?? '';
        stdout.write('Enter task description: ');
        var description = stdin.readLineSync() ?? '';
        stdout.write('Enter task due date (yyyy-mm-dd): ');
        var dueDateStr = stdin.readLineSync() ?? '';
        var dueDate = DateTime.tryParse(dueDateStr) ?? DateTime.now();
        taskManager.addTask(Task(
          title: title,
          description: description,
          dueDate: dueDate,
        ));
        print('Task added successfully!\n');
        break;
      case 2:
        var allTasks = taskManager.viewAllTasks();
        print('All tasks:\n');
        printTaskList(allTasks);
        break;
      case 3:
        var completedTasks = taskManager.viewCompletedTasks();
        print('Completed tasks:\n');
        printTaskList(completedTasks);
        break;
      case 4:
        var pendingTasks = taskManager.viewPendingTasks();
        print('Pending tasks:\n');
        printTaskList(pendingTasks);
        break;
      case 5:
        var pendingTasks = taskManager.viewPendingTasks();
        if (pendingTasks.isEmpty) {
          print('No pending tasks available.\n');
          break;
        }
        print('Select a task to mark as completed:');
        printTaskList(pendingTasks);
        stdout.write('Enter the task number: ');
        var taskNumber = int.tryParse(stdin.readLineSync() ?? '');
        if (taskNumber != null && taskNumber > 0 && taskNumber <= pendingTasks.length) {
          taskManager.markTaskAsCompleted(pendingTasks[taskNumber - 1]);
          print('Task marked as completed!\n');
        } else {
          print('Invalid task number.\n');
        }
        break;
      case 6:
        var completedTasks = taskManager.viewCompletedTasks();
        if (completedTasks.isEmpty) {
          print('No completed tasks available.\n');
          break;
        }
        print('Select a task to mark as pending:');
        printTaskList(completedTasks);
        stdout.write('Enter the task number: ');
        var taskNumber = int.tryParse(stdin.readLineSync() ?? '');
        if (taskNumber != null && taskNumber > 0 && taskNumber <= completedTasks.length) {
          taskManager.markTaskAsPending(completedTasks[taskNumber - 1]);
          print('Task marked as pending!\n');
        } else {
          print('Invalid task number.\n');
        }
        break;
      case 7:
        var allTasks = taskManager.viewAllTasks();
        if (allTasks.isEmpty) {
          print('No tasks available.\n');
          break;
        }
        print('Select a task to delete:');
        printTaskList(allTasks);
        stdout.write('Enter the task number: ');
        var taskNumber = int.tryParse(stdin.readLineSync() ?? '');
        if (taskNumber != null && taskNumber > 0 && taskNumber <= allTasks.length) {
          taskManager.deleteTask(allTasks[taskNumber - 1]);
          print('Task deleted!\n');
        } else {
          print('Invalid task number.\n');
        }
        break;
      case 8:
        print('Exiting the Task Manager Application.');
        return;
      default:
        print('Invalid choice. Please enter a number from 1 to 8.\n');
    }
  }
}
