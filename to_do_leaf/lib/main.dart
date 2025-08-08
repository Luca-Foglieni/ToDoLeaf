import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_settings_ui/card_settings_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

List<Habit> habits = [
  Habit(1, 'Andare a letto', 'alle 21:50 sarebbe top'),
  Habit(5, 'Lavarsi i denti', ''),
  Habit(3, 'Fare colazione', ''),
  Habit(4, 'Fare esercizio fisico', ''),
  Habit(5, 'Bere acqua', ''),
  Habit(2, 'Leggere un libro', ''),
  Habit(7, 'Meditare', ''),
  Habit(4, 'Fare una passeggiata', ''),
  Habit(9, 'Pianificare la giornata', ''),
  Habit(10, 'Fare una pausa dal lavoro', ''),
  Habit(2, 'Prendere le medicine', ''),
  Habit(3, 'Scrivere un diario', ''),
  Habit(5, 'Fare stretching', ''),
  Habit(5, 'Preparare il pranzo', ''),
  Habit(1, 'Chiamare un amico o un familiare', ''),
  Habit(5, 'Fare la spesa', ''),
  Habit(9, 'Pulire la casa', ''),
  Habit(8, 'Fare una sessione di yoga', ''),
  Habit(6, 'Ascoltare un podcast', ''),
  Habit(2, 'Fare un controllo delle email', ''),
];

List<Task> tasks = [
  Task('Fare la spesa settimanale', ''),
  Task('Pagare le bollette', 'in tempo'),
  Task('Fare il bucato', ''),
  Task('Pulire il garage', ''),
  Task('Innaffiare le piante', ''),
  Task('Fare il pieno alla macchina', ''),
  Task('Prenotare un appuntamento dal dottore', ''),
  Task('Fare il backup del computer', ''),
  Task('Organizzare la scrivania', ''),
  Task('Fare una revisione del budget mensile', ''),
  Task('Fare manutenzione alla bicicletta', ''),
  Task('Pulire le finestre', ''),
  Task('Fare una lista di obiettivi mensili', ''),
  Task('Fare una revisione delle assicurazioni', ''),
  Task('Fare una passeggiata nel parco', ''),
  Task('Fare volontariato', ''),
  Task('Fare una visita ai nonni', ''),
  Task('Fare una revisione delle password', ''),
  Task('Fare una giornata senza schermo', ''),
  Task('Fare una revisione delle spese annuali', ''),
  Task('Fare una giornata di pulizia digitale', ''),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerPeriodicTask(
  //   "dailyTask",
  //   "simplePeriodicTask",
  //   initialDelay: calculateInitialDelay(),
  //   frequency: Duration(hours: 24),
  // );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(ToDoLeaf());
}

class ToDoLeaf extends StatelessWidget {
  const ToDoLeaf({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'To Do Leaf', theme: ThemeData.dark(useMaterial3: true), home: const NavigationPage());
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 0;
  bool _isExpanded = true;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double imageSize = 24;
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do Leaf'),
        actions: [
          IconButton(
            onPressed: () => {
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              }),
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: theme.focusColor,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Image.asset('assets/refresh_filled_light.png', height: imageSize, width: imageSize),
            icon: Image.asset('assets/refresh_light.png', height: imageSize, width: imageSize),
            label: 'Habits',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.check_circle),
            icon: Icon(Icons.check_circle_outline),
            label: 'Tasks',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.timer),
            icon: Icon(Icons.timer_outlined),
            label: 'Pomodoro',
          ),
        ],
      ),
      body: <Widget>[
        /// Habit Tracking
        Scrollbar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          habits.elementAt(index).done = !habits.elementAt(index).done;
                          // habits.elementAt(index).timer = Timer(
                          //   DateTime(
                          //     DateTime.now().year,
                          //     DateTime.now().month,
                          //     DateTime.now().day + 1,
                          //   ).difference(DateTime.now()),
                          //   () => habits.elementAt(index).done = false,
                          // );
                          habits.elementAt(index).timer = Timer(Duration(seconds: habits.elementAt(index).seconds), () {
                            _showNotification();
                            setState(() {
                              habits.elementAt(index).done = !habits.elementAt(index).done;
                            });
                          });
                          // print(
                          //   DateTime(
                          //     DateTime.now().year,
                          //     DateTime.now().month,
                          //     DateTime.now().day + 1,
                          //   ).difference(DateTime.now()).toString(),
                          // );
                        });
                      },
                      icon: Icon(
                        habits.elementAt(index).done ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      ),
                    ),
                    title: Text(habits.elementAt(index).title),
                    subtitle: Text(habits.elementAt(index).description.toString()),
                  ),
                );
              },
            ),
          ),
        ),

        // To Do List
        Scrollbar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: ListView(
              children: [
                // Tasks non completati
                ...tasks
                    .where((task) => !task.done)
                    .map(
                      (task) => Card(
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                task.done = !task.done;
                              });
                            },
                            icon: Icon(task.done ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                          ),
                          title: Text(task.title),
                          subtitle: Text(task.description),
                        ),
                      ),
                    ),

                // Sezione completati
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).canvasColor,
                        child: Row(
                          children: [
                            Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                            const SizedBox(width: 8),
                            const Text("Completed tasks"),
                          ],
                        ),
                      ),
                    ),
                    if (_isExpanded)
                      ...tasks
                          .where((task) => task.done)
                          .map(
                            (task) => Card(
                              child: ListTile(
                                leading: IconButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      task.done = !task.done;
                                    });
                                  },
                                  icon: Icon(task.done ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                                ),
                                title: Text(task.title),
                                subtitle: Text(task.description),
                              ),
                            ),
                          ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Pomodoro
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: ListView.builder(
            reverse: true,
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Hello',
                      style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ),
                );
              }
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(8.0)),
                  child: Text('Hi!', style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary)),
                ),
              );
            },
          ),
        ),
      ][currentPageIndex],
      floatingActionButton: currentPageIndex != 2
          ? FloatingActionButton(
              onPressed: () {
                String newTaskOrHabitTitle = '';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    if (currentPageIndex == 0) {
                      return AlertDialog(
                        title: const Text('Add a new habit'),
                        content: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(hintText: 'Habit title'),
                          onChanged: (value) {
                            newTaskOrHabitTitle = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (newTaskOrHabitTitle.trim().isNotEmpty) {
                                setState(() {
                                  habits.add(Habit(1, newTaskOrHabitTitle.trim(), ''));
                                });
                              }
                              Navigator.of(context).pop(); // close the dialog
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    } else if (currentPageIndex == 1) {
                      return AlertDialog(
                        title: const Text('Add a new task'),
                        content: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(hintText: 'Task title'),
                          onChanged: (value) {
                            newTaskOrHabitTitle = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (newTaskOrHabitTitle.trim().isNotEmpty) {
                                setState(() {
                                  tasks.add(Task(newTaskOrHabitTitle.trim(), ''));
                                });
                              }
                              Navigator.of(context).pop(); // close the dialog
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    } else {
                      return AlertDialog(content: Text('you shouldn\'t be here'));
                    }
                  },
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// FloatingActionButton(
//   onPressed: () {
//     String newTaskTitle = '';

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Aggiungi una nuova task'),
//           content: TextField(
//             autofocus: true,
//             decoration: const InputDecoration(hintText: 'Titolo della task'),
//             onChanged: (value) {
//               newTaskTitle = value;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Chiude il dialog
//               },
//               child: const Text('Annulla'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (newTaskTitle.trim().isNotEmpty) {
//                   setState(() {
//                     tasks.add(Task(
//                       title: newTaskTitle.trim(),
//                       description: '',
//                       done: false,
//                     ));
//                   });
//                 }
//                 Navigator.of(context).pop(); // Chiude il dialog
//               },
//               child: const Text('Aggiungi'),
//             ),
//           ],
//         );
//       },
//     );
//   },
//   child: const Icon(Icons.add),
// ),

// FloatingActionButton(
//               onPressed: () {
//                 if (currentPageIndex == 0) {
//                   setState(() {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog();
//                       },
//                     );
//                   });
//                 } else if (currentPageIndex == 1) {
//                 } else {
//                   print('You shouldn\'t be here');
//                 }
//               },
//               child: Icon(Icons.add),
//             )

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Settings'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(leading: Icon(Icons.language), title: Text('Language'), value: Text('English')),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Habit {
  int seconds; // to turn into a date at some point
  bool done = false;
  String title;
  String description;
  late Timer timer;

  Habit(this.seconds, this.title, this.description) {
    // timer = Timer(Duration(seconds: seconds), () {
    //   done = false;
    // });
  }

  @override
  String toString() {
    return 'title: $title, description: $description, seconds: $seconds, done: $done';
  }
}

class Task {
  bool done = false;
  String title;
  String description;

  Task(this.title, this.description);

  @override
  String toString() {
    return ' title: $title, description: $description, done: $done';
  }
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Notification Title',
    'This is the notification body',
    platformChannelSpecifics,
  );
}
