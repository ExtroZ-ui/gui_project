import 'package:flutter/material.dart';
import 'package:gui_project/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  static const values = <String>['TCP', 'Library'];
  String selectedValue = values.first;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildRadios(),
              button(),
            ],
          ),
        ),
      );

  Widget buildRadios() => Column(
        children: values.map(
          (value) {
            return RadioListTile<String>(
                value: value,
                groupValue: selectedValue,
                title: Text(value),
                onChanged: (value) => setState(
                      () => selectedValue = value.toString(),
                    ));
          },
        ).toList(),
      );

  Widget button() => Column(
        children: [
          OutlinedButton(
            onPressed: () {
              checkTcp();
            },
            child: const Text('Применить'),
          ),
        ],
      );

  dynamic checkTcp() {
    if (selectedValue.toString() == 'TCP') {
      TCP = true;
    } else {
      TCP = false;
    }
  }
}
