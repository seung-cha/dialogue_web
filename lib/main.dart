import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  late Ros _ros;
  String text = "Hello World!";
  List<String> history = [];

  bool screenDisplayFlag = false;

  Future<void> subscribeDialogue(Map<String, dynamic> msg) async {
    text = msg['data'];

    // history.add(msg['data']);

    if (history.length > 4) {
      history.removeAt(0);
    }

    setState(() {});
  }

  Future<void> subscribeDialogueRobot(Map<String, dynamic> msg) async {
    text = msg['data'];

    // history.add(msg['data']);

    if (history.length > 4) {
      history.removeAt(0);
    }

    setState(() {});
  }

  Future<void> subscribeBoolean(Map<String, dynamic> msg) async {
    screenDisplayFlag = msg['data'];
    setState(() {});
  }

  Future<void> init() async {
    _ros = Ros(url: 'ws://ari-27c:9090');
    _ros.connect();

    final speechTopic = Topic(
        ros: _ros,
        name: '/dialogue',
        type: 'std_msgs/String',
        throttleRate: 100);

    final speechRobotTopic = Topic(
        ros: _ros,
        name: '/dialogue_robot',
        type: 'std_msgs/String',
        throttleRate: 100);

    final booleanFlagTopic = Topic(
        ros: _ros,
        name: '/screen_flag_display',
        type: 'std_msgs/Bool',
        throttleRate: 100);

    await speechTopic.subscribe(subscribeDialogue);
    await speechRobotTopic.subscribe(subscribeDialogueRobot);
    await booleanFlagTopic.subscribe(subscribeBoolean);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _ros.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Dialogue"),
        ),
        body: SizedBox(
          width: 1280.0,
          height: 800.0,

          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.

          child: ColoredBox(
            color: screenDisplayFlag
                ? const Color.fromARGB(255, 255, 95, 95)
                : const Color.fromARGB(255, 154, 255, 95),
            child: Stack(
              children: [
                // Align(
                //   alignment: const Alignment(0.0, -0.5),
                //   child: ListView(
                //     shrinkWrap: true,
                //     children: [
                //       Center(
                //         child: Text(
                //           screenDisplayFlag ? "Hello" : "Bye",
                //           style: const TextStyle(fontSize: 24),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Align(
                  alignment: const Alignment(0.0, 0.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text(
                          history[history.length - index - 1],
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 5,
                        color: Color.fromARGB(255, 0, 0, 0),
                      );
                    },
                    itemCount: history.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
