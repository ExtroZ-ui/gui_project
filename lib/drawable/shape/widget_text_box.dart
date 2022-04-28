import 'package:flutter/material.dart';

dynamic xTextField() {
  return const TextField(
    decoration: InputDecoration(
      hintText: 'X',
      contentPadding: EdgeInsets.all(15.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
    ),
  );
}

dynamic yTextField() {
  return const TextField(
    decoration: InputDecoration(
      hintText: 'Y',
      contentPadding: EdgeInsets.all(15.0),
      isDense: true,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
    ),
  );
}

dynamic zTextField() {
  return const TextField(
    decoration: InputDecoration(
      hintText: 'Z',
      contentPadding: EdgeInsets.all(15.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
    ),
  );
}

// ignore: camel_case_types
class textBoxCustom {
  dynamic setTextBox(temp) {
    return Container(
      width: 462.0,
      height: 32.0,
      padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0.5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(8.0)), // 8
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
            height: 35.0,
            child: IconButton(
              color: Colors.red,
              iconSize: 20.0,
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(Icons.remove),
              onPressed: () {
                dynamic value = temp;
                if (value.text.isEmpty) {
                  value.text = '-1';
                } else {
                  onMinus(value);
                }
              },
            ),
          ),
          Container(
            width: 420.0,
            color: Colors.white,
            child: TextFormField(
              keyboardType: const TextInputType.numberWithOptions(),
              controller: temp,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(
            width: 20.0,
            height: 30.0,
            child: IconButton(
              color: Colors.green,
              iconSize: 20.0,
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(Icons.add),
              onPressed: () {
                dynamic value = temp;
                if (value.text.isEmpty) {
                  value.text = '1';
                } else {
                  onPlus(value);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void onPlus(tempValue) {
    double temp = double.parse(tempValue.text);
    temp++;
    tempValue.text = temp.toString();
  }

  void onMinus(tempValue) {
    int temp = int.parse(tempValue.text);
    temp--;
    tempValue.text = temp.toString();
  }
}
