# gui_project

## Установка Flutter
Запустите следующие команды на терминале в Ubuntu:
 1. sudo snap install flutter --classic
 >Согласно документам, эта команда также должна установить зависимости, но в моем случае это было не так, поэтому мне пришлось установить их вручную:
 2. sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
 
## Настройка Flutter
Для создания настольных приложений нам необходимо выполнить следующие команды:
- flutter channel dev
- flutter upgrade
- flutter config --enable-linux-desktop

## Поиск проблемы
Если вы хотите проверить, все ли работает в какой-то момент, Flutter Doctor — отличный инструмент, который вы можете использовать. Просто запустите команду или найдите «Flutter Doctor» в IntelliJ или Visual Studio Code:
- flutter doctor
 >Если выйдут ошибки связанные с Android,не беспокойтесь о таких ошибках, если вы, конечно, не разрабатываете для Android!

## Установка кода Visual Studio Code
Чтобы установить привязку VS Code, откройте свой терминал и выполните следующую команду:
- sudo snap install --classic code
>Вот и все. Visual Studio Code установлен

## Настройка Flutter в Visual Studio Code
Для начало надо устоновить важные расширения для VS Code:
- Flutter
- Dart
>Так же для удобства понадобятся:
- Material Icon Theme
- [Deprecated] Bracket Pair Colorizer 2
