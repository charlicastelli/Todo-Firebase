import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarefas/dropdown/dropdown.dart';
import 'package:tarefas/theme/theme.dart';
import 'package:tarefas/theme/theme_services.dart';
import 'package:tarefas/ui/market_list.dart';
import 'package:tarefas/ui/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                    borderRadius: BorderRadius.circular(15),
                    hint: Text('O que quer fazer?', style: subTitleStyle),
                    dropdownColor: Get.isDarkMode ? darkHeaderClr : white,
                    icon: Icon(Icons.arrow_drop_down,
                        color: Get.isDarkMode ? white : primaryClr),
                    iconSize: 36,
                    isExpanded: true,
                    underline: const SizedBox(),
                    style: subTitleStyle,
                    value: selected,
                    onChanged: (newValue) {
                      setState(() {
                        selected = newValue as String?;
                        _nextTodo();
                        _nextMarket();
                      });
                    },
                    items: primary.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList()),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                child: Center(child: Image.asset('image/bob.png')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _nextTodo() async {
    if (selected == 'Lista de tarefas') {
      await Get.to(() => const TodoList());
    }
  }

  Future<void> _nextMarket() async {
    if (selected == 'Lista de mercado') {
      await Get.to(() => const MarketList());
    }
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
          onTap: (() {
            ThemeService().switchThemeMode();
          }),
          child: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nights_stay_rounded,
              size: 26,
              color: Get.isDarkMode ? Colors.white : Colors.black)),
    );
  }
}
