import 'package:flutter/material.dart';
import 'package:gui_project/model/menu_item_model.dart';

class MenuItems {
  static const List<MenuItemModel> itemsFirst = [
    itemSettings,
  ];

  static const itemSettings = MenuItemModel(
    text: 'Settings',
    icon: Icons.settings,
  );
}
