import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gui_project/data/menu_items.dart';
import 'package:gui_project/model/menu_item_model.dart';
import 'package:gui_project/settings_page.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'model/weather_control.dart';
import 'model/viewpoint_control.dart';
import 'package:gui_project/drawable/shape/widget_text_box.dart';

/// 🕷🕷🕷🕷🕷🕷

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'GUI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// ignore: non_constant_identifier_names
bool TCP = true;

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  int _step = 2;

  // "UnigTime"
  double _timerHourCurrentSliderValue = 0;
  double _timerMinuteCurrentSliderValue = 0;

  // "UnigClouds"
  double _layerValue = 0;
  int _cloudTypeValue = 0;
  double _elevationValue = 0;
  double _thicknessValue = 0;
  double _coverageValue = 0;

  // "UnigVisibility"
  double _visibilityDistanceValue = 600;

  // "UnigClouds"
  double _idCam = 0;
  double _idEntity = 0;

  double _pitch = 0;
  double _roll = 0;
  double _yaw = 0;

  _keyD() {
    dynamic temp = double.parse(_xNumValue.text);
    _xNumValue.text = (temp + _step).toString();
    return _xNumValue.text.toString();
  }

  _keyA() {
    dynamic temp = double.parse(_xNumValue.text);
    _xNumValue.text = (temp - _step).toString();
    return _xNumValue.text.toString();
  }

  _keyW() {
    dynamic temp = double.parse(_zNumValue.text);
    _zNumValue.text = (temp + _step).toString();
    return _zNumValue.text.toString();
  }

  _keyS() {
    dynamic temp = double.parse(_zNumValue.text);
    _zNumValue.text = (temp - _step).toString();
    return _zNumValue.text.toString();
  }

  _keyE() {
    dynamic temp = double.parse(_yNumValue.text);
    _yNumValue.text = (temp + _step).toString();
    return _yNumValue.text.toString();
  }

  _keyQ() {
    dynamic temp = double.parse(_yNumValue.text);
    _yNumValue.text = (temp - _step).toString();
    return _yNumValue.text.toString();
  }

  _sendView() {
    final mapidCam = {
      "UnigView": {
        'idCam': _idCam,
        'idEntity': _idEntity,
        'offset_x': _xNumValue.text,
        'offset_y': _yNumValue.text,
        'offset_z': _zNumValue.text,
        'pitch': _pitch,
        'roll': _roll,
        'yaw': _yaw
      }
    };
    final jsonidCam = jsonEncode(mapidCam);
    Server().send(jsonidCam);
  }

  _sendTime() {
    int tempMinut = _timerMinuteCurrentSliderValue.toInt();
    int tempHour = _timerHourCurrentSliderValue.toInt();
    final mapTime = {
      "UnigTime": {'hour': tempHour, 'minute': tempMinut}
    };
    final jsonTime = jsonEncode(mapTime);
    Server().send(jsonTime);
  }

  _sendCloud() {
    final mapLayer = {
      "UnigClouds": {
        'layer': _layerValue,
        'cloudType': _cloudTypeValue,
        'elevation': _elevationValue,
        'thickness': _thicknessValue,
        'coverage': _coverageValue
      }
    };
    final json = jsonEncode(mapLayer);
    Server().send(json);
  }

  _sendDistance() {
    final mapVisibilityDistance = {
      "UnigVisibility": {'visibilityDistance': _visibilityDistanceValue}
    };
    final jsonVisibilityDistance = jsonEncode(mapVisibilityDistance);
    Server().send(jsonVisibilityDistance);
  }

  @override
  void initState() {
    super.initState();
    Server().connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            log('test');
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyW)) {
            log(_keyW());
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyA)) {
            log(_keyA());
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyS)) {
            log(_keyS());
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyD)) {
            log(_keyD());
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyQ)) {
            log(_keyQ());
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyE)) {
            log(_keyE());
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                PopupMenuButton<MenuItemModel>(
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                    ...MenuItems.itemsFirst.map(buildItem).toList(),
                  ],
                ),
              ],
            ),
            body: Scaffold(
              body: Center(
                child: Row(children: <Widget>[
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: <NavigationRailDestination>[
                      WeatherControl(),
                      viewpointControl(),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  selectBody(_selectedIndex),
                ]),
              ),
            )));
  }

  double con = 100 / 60;

  selectBody(value) {
    switch (value) {
      case 0:
        return oneExpanded();
      case 1:
        return twoExpanded();
    }
  }

  dynamic typeCloud(name) {
    switch (name) {
      case 'Нет':
        return _cloudTypeValue = 0;
      case 'Высококучевые':
        return _cloudTypeValue = 1;
      case 'Выскослоистые':
        return _cloudTypeValue = 2;
      case 'Перисто-кучевые':
        return _cloudTypeValue = 3;
      case 'Перисто-слоистые':
        return _cloudTypeValue = 4;
      case 'Перистые':
        return _cloudTypeValue = 5;
      case 'Кучево-дождевые':
        return _cloudTypeValue = 6;
      case 'Кучевые':
        return _cloudTypeValue = 7;
      case 'Слоисто-дождевые':
        return _cloudTypeValue = 8;
      case 'Слоисто-кучевые':
        return _cloudTypeValue = 9;
      case 'Слоистые':
        return _cloudTypeValue = 10;
    }
  }

  String dropdownValue = 'Нет';

  Widget oneExpanded() {
    return Flexible(
        child: AspectRatio(
            aspectRatio: 2,
            child: Column(children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                // "UnigTime"
                'Время суток',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 40),
              Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  const SizedBox(width: 0),
                  Expanded(
                    child: SleekCircularSlider(
                      initialValue: 0,
                      min: 0.0,
                      max: 24.0,
                      innerWidget: (double val) {
                        return Center(
                            child: Text(
                          _timerHourCurrentSliderValue.truncate().toString() +
                              " ч\t" +
                              _timerMinuteCurrentSliderValue
                                  .truncate()
                                  .toString() +
                              " м",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ));
                      },
                      appearance: const CircularSliderAppearance(
                        size: 150,
                        angleRange: 360,
                      ),
                      onChange: (double value) {
                        setState(() => {
                              _timerHourCurrentSliderValue = value,
                              _sendTime(),
                              _timerMinuteCurrentSliderValue = value % 1 * 60
                            });
                      },
                    ),
                  ),
                ],
              ),

              //  "UnigClouds"
/*
//         "layer": 10,
//         "cloudType": 11,
//         "elevation": 12,
//         "thickness": 12,
//         "coverage": 12
*/
              const SizedBox(
                height: 40,
              ),

              const Text('Облака',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

              const SizedBox(
                height: 40,
              ),

              Row(textDirection: TextDirection.ltr, children: <Widget>[
                const SizedBox(width: 40),
                const Flexible(
                    child: Text(
                  'Высота',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(width: 85),
                Flexible(
                    child: Slider(
                        value: _elevationValue,
                        min: -360,
                        max: 360.00,
                        divisions: 720,
                        label: _elevationValue.round().toString(),
                        onChanged: (double value) {
                          setState(
                              () => {_elevationValue = value, _sendCloud()});
                        })),
                const SizedBox(width: 50),
                Flexible(
                    child: SpinBox(
                  min: 0,
                  max: 10,
                  decoration: const InputDecoration(
                      labelText: 'Слой', labelStyle: TextStyle(fontSize: 20)),
                  onChanged: (value) {
                    setState(() => {_layerValue = value, _sendCloud()});
                  },
                ))
              ]),

              Row(textDirection: TextDirection.ltr, children: <Widget>[
                const SizedBox(width: 40),
                const Flexible(
                    child: Text(
                  'Толщина',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(width: 70),
                Flexible(
                    child: Slider(
                        value: _thicknessValue,
                        min: 0,
                        max: 12,
                        divisions: 12,
                        label: _thicknessValue.round().toString(),
                        onChanged: (double value) {
                          setState(
                              () => {_thicknessValue = value, _sendCloud()});
                        })),
                Flexible(
                    child: Center(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    //icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() => {
                            dropdownValue = newValue!,
                            typeCloud(newValue),
                            _sendCloud()
                          });
                    },
                    items: <String>[
                      'Нет',
                      'Высококучевые',
                      'Выскослоистые',
                      'Перисто-кучевые',
                      'Перисто-слоистые',
                      'Перистые',
                      'Кучево-дождевые',
                      'Кучевые',
                      'Слоисто-дождевые',
                      'Слоисто-кучевые',
                      'Слоистые'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ))
              ]),

              Row(textDirection: TextDirection.ltr, children: <Widget>[
                const SizedBox(width: 40),
                const Flexible(
                    child: Text(
                  'Покрытие',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(width: 60),
                Flexible(
                    child: Slider(
                        value: _coverageValue,
                        min: 0,
                        max: 12,
                        divisions: 12,
                        label: _coverageValue.round().toString(),
                        onChanged: (double value) {
                          setState(
                              () => {_coverageValue = value, _sendCloud()});
                        }))
              ]),

// добавить на проверку изменилось ли значение если да то отправлять если нет то не отправлять на сервер

              OutlinedButton(
                onPressed: () {
                  int tempMinut = _timerMinuteCurrentSliderValue.toInt();
                  final mapTime = {
                    "UnigTime": {
                      'hour': _timerHourCurrentSliderValue,
                      'minute': tempMinut
                    }
                  };
                  final jsonTime = jsonEncode(mapTime);
                  Server().send(jsonTime);

                  final mapLayer = {
                    "UnigClouds": {
                      'layer': _layerValue,
                      'cloudType': _cloudTypeValue,
                      'elevation': _elevationValue,
                      'thickness': _thicknessValue,
                      'coverage': _coverageValue
                    }
                  };
                  final json = jsonEncode(mapLayer);
                  Server().send(json);
                },
                child: const Text('Применить'),
              ),
            ])));
  }

  final TextEditingController _xNumValue = TextEditingController();
  final TextEditingController _yNumValue = TextEditingController();
  final TextEditingController _zNumValue = TextEditingController();

  dynamic creation(int val) {
    switch (val) {
      case 1:
        if (_xNumValue.text == '') {
          _xNumValue.text = '0';
        }
        return textBoxCustom().setTextBox(_xNumValue);
      case 2:
        if (_yNumValue.text == '') {
          _yNumValue.text = '0';
        }
        return textBoxCustom().setTextBox(_yNumValue);
      case 3:
        if (_zNumValue.text == '') {
          _zNumValue.text = '0';
        }
        return textBoxCustom().setTextBox(_zNumValue);
      default:
        // ignore: avoid_print
        print('Ошибка $val');
    }
  }

  Widget twoExpanded() {
    return Expanded(
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Видимость',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(width: 40),
              const Flexible(
                  child: Text(
                'Дальность видимости',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 90),
              Expanded(
                child: Slider(
                    value: _visibilityDistanceValue,
                    min: 0,
                    max: 1000,
                    divisions: 1000,
                    label: _visibilityDistanceValue.round().toString(),
                    onChanged: (double value) {
                      setState(() =>
                          {_visibilityDistanceValue = value, _sendDistance()});
                    }),
              )
            ]),
            const SizedBox(height: 20),
            const Text(
              'Настройки камеры',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(width: 40),
              const Flexible(
                  child: Text(
                'id Камеры',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 90),
              Expanded(
                child: Slider(
                    value: _idCam,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _idCam.round().toString(),
                    onChanged: (double value) {
                      setState(() => {_idCam = value, _sendView()});
                    }),
              )
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(width: 36),
              const Flexible(
                  child: Text(
                'id Объекта',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 90),
              Expanded(
                child: Slider(
                    value: _idEntity,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _idEntity.round().toString(),
                    onChanged: (double value) {
                      setState(() => {_idEntity = value, _sendView()});
                    }),
              )
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(height: 40),
              const SizedBox(width: 40),
              const Flexible(
                  child: Text(
                'Смещение X',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 70),
              Expanded(
                  child: Column(
                children: [creation(1)],
              ))
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(height: 40),
              const SizedBox(width: 40),
              const Flexible(
                  child: Text(
                'Смещение Y',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 70),
              Expanded(
                  child: Column(
                children: [creation(2)],
              ))
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(height: 40),
              const SizedBox(width: 40),
              const Flexible(
                  child: Text(
                'Смещение Z',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 70),
              Expanded(
                  child: Column(
                children: [creation(3)],
              ))
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(height: 40),
              const SizedBox(width: 40),
              const Flexible(
                  child: Text(
                'Шаг смещения',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 70),
              Expanded(
                  child: Column(
                children: [
                  Slider(
                      value: _step.toDouble(),
                      min: 2,
                      max: 16,
                      divisions: 50,
                      label: _step.round().toString(),
                      onChanged: (double value) {
                        setState(() => {_step = value.toInt()});
                      })
                ],
              ))
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(width: 40),
              const Flexible(
                  child: Text(
                'Тангаж',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              Expanded(
                child: Slider(
                    value: _pitch,
                    min: -360,
                    max: 360,
                    divisions: 360,
                    label: _pitch.round().toString(),
                    onChanged: (double value) {
                      setState(() => {_pitch = value, _sendView()});
                    }),
              )
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(width: 45),
              const Flexible(
                  child: Text(
                'Крен',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 10),
              Expanded(
                child: Slider(
                    value: _roll,
                    min: -360,
                    max: 360,
                    divisions: 360,
                    label: _roll.round().toString(),
                    onChanged: (double value) {
                      setState(() => {_roll = value, _sendView()});
                    }),
              )
            ]),
            Row(textDirection: TextDirection.ltr, children: <Widget>[
              const SizedBox(width: 48),
              const Flexible(
                  child: Text(
                'Курс',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 16),
              )),
              const SizedBox(width: 10),
              Expanded(
                child: Slider(
                    value: _yaw,
                    min: -360,
                    max: 360,
                    divisions: 360,
                    label: _yaw.round().toString(),
                    onChanged: (double value) {
                      setState(() => {_yaw = value, _sendView()});
                    }),
              )
            ]),
            OutlinedButton(
              onPressed: () {
                final mapVisibilityDistance = {
                  "UnigVisibility": {
                    'visibilityDistance': _visibilityDistanceValue
                  }
                };
                final jsonVisibilityDistance =
                    jsonEncode(mapVisibilityDistance);
                Server().send(jsonVisibilityDistance);

                final mapidCam = {
                  "UnigView": {
                    'idCam': _idCam,
                    'idEntity': _idEntity,
                    'offset_x': _xNumValue.text,
                    'offset_y': _yNumValue.text,
                    'offset_z': _zNumValue.text,
                    'pitch': _pitch,
                    'roll': _roll,
                    'yaw': _yaw
                  }
                };
                final jsonidCam = jsonEncode(mapidCam);
                Server().send(jsonidCam);
              },
              child: const Text('Применить'),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<MenuItemModel> buildItem(MenuItemModel item) =>
      PopupMenuItem<MenuItemModel>(
        value: item,
        child: Row(children: [
          Icon(item.icon, color: Colors.black, size: 20),
          const SizedBox(width: 12),
          Text(item.text),
        ]),
      );

  onSelected(BuildContext context, MenuItemModel item) {
    switch (item) {
      case MenuItems.itemSettings:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        log('$TCP');
        break;
    }
  }
}

class Server {
  void connectToServer() async {
    try {
      Socket _socket = await Socket.connect('127.0.0.1', 7890);
      log('connected: ${_socket.address}:${_socket.port}');
    } catch (e) {
      log(e.toString());
    }
  }

  void send(temp) async {
    Socket _socket = await Socket.connect('127.0.0.1', 7890);

    _socket.listen((List<int> event) {
      log(utf8.decode(event));
    });

    _socket.add(utf8.encode(temp));
  }
}
