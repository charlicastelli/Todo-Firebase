import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tarefas/theme/theme.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List listTodos = List.empty();
  String title = "";
  String description = "";
  // int _selectedColor = 0;
  @override
  void initState() {
    super.initState();
    listTodos = ["Ola", "Tudo bem"];
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Todos").doc(title);

    Map<String, String> todoList = {"title": title, "desc": description};

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Todos").doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Todos").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado!');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                padding: const EdgeInsets.only(top: 4, left: 1, right: 1),
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return Slidable(
                    key: Key(index.toString()),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Get.isDarkMode
                          ? darkHeaderClr
                          : white, //_getBGClr(_selectedColor), // mudar cores
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          (documentSnapshot != null)
                              ? (documentSnapshot["title"])
                              : "",
                          style: subTitleStyle,
                        ),
                        subtitle: Text(
                          (documentSnapshot != null)
                              ? ((documentSnapshot["desc"] != null)
                                  ? documentSnapshot["desc"]
                                  : "")
                              : "",
                          style: subTitleStyle,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Get.isDarkMode ? pinkClr : red,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor: Get.isDarkMode
                                          ? darkHeaderClr
                                          : white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      title: Center(
                                          child: Text(
                                        'APAGAR TAREFA',
                                        style: headingStyle,
                                      )),
                                      content: Text(
                                          'Você tem certeza que deseja apagar está tarefa?',
                                          style: subTitleStyle),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            RaisedButton(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: const Text(
                                                "Cancelar",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              color: Get.isDarkMode
                                                  ? greenClr
                                                  : primaryClr,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            RaisedButton(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: const Text(
                                                "Apagar",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              color: Get.isDarkMode
                                                  ? greenClr
                                                  : primaryClr,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  deleteTodo(
                                                      (documentSnapshot != null)
                                                          ? (documentSnapshot[
                                                              "title"])
                                                          : "");
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));
                          },
                        ),
                      ),
                    ),
                    actionExtentRatio: 0.25,
                    actionPane: const SlidableStrechActionPane(),
                    // deslizar para esquerda
                    // secondaryActions: [
                    //   IconSlideAction(
                    //     color: Colors.red,
                    //     icon: Icons.delete,
                    //     caption: 'Deletar',
                    //     onTap: () {
                    //       setState(() {
                    //         deleteTodo((documentSnapshot != null)
                    //             ? (documentSnapshot["todoTitle"])
                    //             : "");
                    //       });
                    //     },
                    //   )
                    // ],
                    // deslizar para direita
                    actions: [
                      IconSlideAction(
                        color: Get.isDarkMode ? pinkClr : red,
                        icon: Icons.delete,
                        caption: 'Deletar',
                        onTap: () {
                          setState(() {
                            deleteTodo((documentSnapshot != null)
                                ? (documentSnapshot["title"])
                                : "");
                          });
                        },
                      )
                    ],
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  //scrollable: true,
                  backgroundColor: Get.isDarkMode ? darkHeaderClr : white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Center(
                    child: Column(
                      children: [
                        Text(
                          "ADICIONAR TAREFA",
                          style: headingStyle,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Image.asset(
                          "image/bob.png",
                          width: 150,
                          height: 150,
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                  content: Container(
                    width: 400,
                    height: 250,
                    //color: Colors.red,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            cursorColor:
                                Get.isDarkMode ? Colors.grey[100] : primaryClr,
                            textCapitalization: TextCapitalization
                                .sentences, // primeira letra maiuscula
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Adicione uma tarefa',
                              labelStyle: TextStyle(
                                color: Get.isDarkMode ? white : darkHeaderClr,
                              ),
                              hintText: 'Ex: Pagar cartão',
                              //Trocar a cor da borda
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color:
                                        Get.isDarkMode ? white : darkHeaderClr,
                                    width: 1,
                                  )),
                            ),
                            onChanged: (String value) {
                              title = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            cursorColor:
                                Get.isDarkMode ? Colors.grey[100] : primaryClr,
                            textCapitalization: TextCapitalization
                                .sentences, // primeira letra maiuscula
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Descrição',
                              labelStyle: TextStyle(
                                color: Get.isDarkMode ? white : darkHeaderClr,
                              ),
                              hintText: 'Descrição',
                              //Trocar a cor da borda
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color:
                                        Get.isDarkMode ? white : darkHeaderClr,
                                    width: 1,
                                  )),
                            ),
                            onChanged: (String value) {
                              description = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          color: Get.isDarkMode ? greenClr : primaryClr,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text(
                            "Adicionar",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          color: Get.isDarkMode ? greenClr : primaryClr,
                          onPressed: () {
                            setState(() {
                              createToDo();
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Get.isDarkMode ? greenClr : primaryClr,
      ),
    );
  }

  // _colorPallete() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Cor",
  //         style: titleStyle,
  //       ),
  //       const SizedBox(
  //         height: 8.0,
  //       ),
  //       Wrap(
  //         children: List<Widget>.generate(5, (int index) {
  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 _selectedColor = index;
  //               });
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(right: 8.0),
  //               child: CircleAvatar(
  //                   radius: 14,
  //                   backgroundColor: index == 0
  //                       ? primaryClr
  //                       : index == 1
  //                           ? pinkClr
  //                           : index == 3 //yellowClr

  //                               ? yellowClr
  //                               : index == 4
  //                                   ? Colors.cyanAccent
  //                                   : Colors.green,
  //                   child: _selectedColor == index
  //                       ? const Icon(
  //                           Icons.done,
  //                           color: Colors.white,
  //                           size: 16,
  //                         )
  //                       : Container()),
  //             ),
  //           );
  //         }),
  //       )
  //     ],
  //   );
  // }

  // _getBGClr(int no) {
  //   switch (no) {
  //     case 0:
  //       return bluishClr;
  //     case 1:
  //       return pinkClr;
  //     case 2:
  //       return Colors.green;
  //     case 3:
  //       return yellowClr;
  //     case 4:
  //       return Colors.cyan;
  //     default:
  //       return bluishClr;
  //   }
  // }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
          onTap: (() {
            Get.back();
          }),
          child: Icon(Icons.arrow_back_ios_new,
              size: 26, color: Get.isDarkMode ? Colors.white : Colors.black)),
    );
  }
}
