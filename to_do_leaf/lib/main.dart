import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_settings_ui/card_settings_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ToDoLeaf());

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

  // final SharedPreferencesAsync preferencesAsync = SharedPreferencesAsync();

  List<Habit> habits = [
    Habit(1, 'Andare a letto'),
    Habit(5, 'Lavarsi i denti'),
    Habit(3, 'Fare colazione'),
    Habit(4, 'Fare esercizio fisico'),
    Habit(5, 'Bere acqua'),
    Habit(2, 'Leggere un libro'),
    Habit(7, 'Meditare'),
    Habit(4, 'Fare una passeggiata'),
    Habit(9, 'Pianificare la giornata'),
    Habit(10, 'Fare una pausa dal lavoro'),
    Habit(2, 'Prendere le medicine'),
    Habit(3, 'Scrivere un diario'),
    Habit(5, 'Fare stretching'),
    Habit(5, 'Preparare il pranzo'),
    Habit(1, 'Chiamare un amico o un familiare'),
    Habit(5, 'Fare la spesa'),
    Habit(9, 'Pulire la casa'),
    Habit(8, 'Fare una sessione di yoga'),
    Habit(6, 'Ascoltare un podcast'),
    Habit(2, 'Fare un controllo delle email'),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double imageSize = 24;
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do Leaf'),
        actions: [
          IconButton(
            onPressed:
                () => {
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
        indicatorColor: Colors.amber,
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
      body:
          <Widget>[
            /// Habit Tracking
            Scrollbar(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: ListView(
                  children: [
                    ...List.generate(habits.length, (index) {
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
                                habits.elementAt(index).timer = Timer(
                                  Duration(seconds: habits.elementAt(index).seconds),
                                  () => {},
                                );
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
                          title: Text(habits.elementAt(index).titolo),
                          subtitle: Text('This is a notification'),
                        ),
                      );
                    }),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            /// To Do List
            Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 1'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 2'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
              ],
            ),

            // Pomodoro
            ListView.builder(
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
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('Hi!', style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary)),
                  ),
                );
              },
            ),
          ][currentPageIndex],
    );
  }
}

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
  String titolo;
  late Timer timer;

  Habit(this.seconds, this.titolo) {
    // timer = Timer(Duration(seconds: seconds), () {
    //   done = false;
    // });
  }

  @override
  String toString() {
    return 'seconds: $seconds, done: $done, titolo: $titolo';
  }
}
