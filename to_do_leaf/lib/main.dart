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
    return const MaterialApp(home: NavigationPage());
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 0;

  final SharedPreferencesAsync preferencesAsync = SharedPreferencesAsync();

  List<Habit> habits = [
    Habit(1, 'Andare a letto'),
    Habit(2, 'Lavarsi i denti'),
    Habit(1, 'Mangiare del fieno'),
    Habit(2, 'Farsi le sopracciglia'),
    Habit(2, 'Farsi le sopracciglia'),
    Habit(1, 'Andare a letto'),
    Habit(2, 'Lavarsi i denti'),
    Habit(1, 'Mangiare del fieno'),
    Habit(2, 'Farsi le sopracciglia'),
    Habit(2, 'Farsi le sopracciglia'),
    Habit(1, 'Andare a letto'),
    Habit(2, 'Lavarsi i denti'),
    Habit(1, 'Mangiare del fieno'),
    Habit(2, 'Farsi le sopracciglia'),
    Habit(2, 'Farsi le sopracciglia'),
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
            selectedIcon: Image.asset('assets/refresh_filled.png', height: imageSize, width: imageSize),
            icon: Image.asset('assets/refresh.png', height: imageSize, width: imageSize),
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
                                habits.elementAt(index).timer = Timer(
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + 1,
                                  ).difference(DateTime.now()),
                                  () => setState(() {
                                    habits.elementAt(index).done = false;
                                  }),
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
