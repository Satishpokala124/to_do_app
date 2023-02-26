import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/pages/home.dart';
import 'package:to_do_app/providers/navigate.dart';
import 'package:to_do_app/providers/tasks.dart';
import 'package:to_do_app/providers/theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppTheme()),
      ChangeNotifierProvider(create: (_) => Tasks()),
      ChangeNotifierProvider(create: (_) => Navigation()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isBackground = false;
  Brightness systemBrightness =
      SchedulerBinding.instance.window.platformBrightness;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      isBackground = state != AppLifecycleState.resumed;
    });
    // developer.log('state = $state');
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {
      systemBrightness = SchedulerBinding.instance.window.platformBrightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.watch<AppTheme>();
    var color = appTheme.color;
    var darkMode = appTheme.darkMode;
    var navigation = context.watch<Navigation>();
    var tasks = context.watch<Tasks>();
    if (isBackground) {
      tasks.saveData();
    }
    return MaterialApp(
      title: 'Check List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color,
          brightness: (darkMode == null)
              ? systemBrightness
              : darkMode
                  ? Brightness.dark
                  : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: tasks.initialized
          ? MyHomePage(title: navigation.title)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Loading...'),
                ],
              ),
            ),
    );
  }
}
