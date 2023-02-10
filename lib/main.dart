import 'package:flutter/material.dart';
import 'package:qualtrics_digital_flutter_plugin/qualtrics_digital_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Qualtrics Example Code'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _qualtrics = QualtricsDigitalFlutterPlugin();
  final orgId = ''; //add test id here to make it work
  final projectId = ''; //add test id here to make it work
  final targetId = ''; //add test id here to make it work
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  void _initQualtircs() async {
    // STEP 01 INTIALIZE PROJECT
    final result = await _qualtrics.initializeProject(orgId, projectId);
    if (result.entries.isNotEmpty) {
      // STEP 02 SET REQUIRED PROPERTIES
      _qualtrics.setString(
        'appName',
        'yourAppName',
      );
      _qualtrics.setString(
        'locale',
        'EN',
      );
      _qualtrics.setString('brand', 'foodpanda');
      _qualtrics.setString(
        'userName',
        'anyUser',
      );
      _qualtrics.setString(
        'countryCode',
        'anyCountry',
      );
      // STEP 03 EVALUATE PROJECT
      final result = await _qualtrics.evaluateProject();
      if (result.entries.isNotEmpty) {
        _getQualtricsData(result);
      } else {
        setState(() {
          errorMessage = 'project is not evaluated properly';
        });
      }
    } else {
      setState(() {
        errorMessage = 'project is not initialized';
      });
    }
  }

  void _getQualtricsData(Map<String, Map<String, String>> result) {
    for (var interceptId in result.keys) {
      final interceptData = result[interceptId];
      if (interceptData!['creativeType'] == 'MobilePopOver') {
        // STEP 04 DISPLAY SURVERY
        _displayTarget(interceptData['surveyUrl']!);
        break;
      }
    }
  }

  void _displayTarget(String url) {
    // on this call you will get exception in logs.
    // exception only caused in android
    _qualtrics.displayTarget(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _initQualtircs,
              child: const Text(
                'Click',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(errorMessage)
          ],
        ),
      ),
    );
  }
}
