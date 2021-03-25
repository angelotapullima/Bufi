import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class FiltroPage extends StatefulWidget {
  FiltroPage({Key key, @required this.idItemSub}) : super(key: key);
  //final String title;
  final String idItemSub;

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {
  List<User> selectedUserList = [];

  @override
  Widget build(BuildContext context) {
    final itemSubcatBloc = ProviderBloc.itemSubcategoria(context);
    itemSubcatBloc.listarBienesServiciosXIdItemSubcategoria(widget.idItemSub);
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      bottomNavigationBar: FlatButton(
        onPressed: () async {
          var list = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(
                
                //idItem: widget.idItemSub ,
                allTextList: userList,
                selectedUserList: selectedUserList,
              ),
            ),
          );
          if (list != null) {
            setState(() {
              selectedUserList = List.from(list);
            });
          }
        },
        child: Text(
          "Filter Page",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          selectedUserList == null || selectedUserList.length == 0
              ? Expanded(
                  child: Center(
                    child: Text('No text selected'),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(selectedUserList[index].name),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: selectedUserList.length),
                ),
        ],
      ),
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({Key key, this.allTextList, this.selectedUserList})
      : super(key: key);
  final List<User> allTextList;
  final List<User> selectedUserList;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter list Page"),
      ),
      body: SafeArea(
        child: StreamBuilder(
         // stream: 
          builder: (context, snapshot) {
            return FilterListWidget(
              listData: userList,
              selectedListData: selectedUserList,
              hideheaderText: true,
              onApplyButtonClick: (list) {
                Navigator.pop(context, list);
              },
              label: (item) {
                /// Used to print text on chip
                return item.name;
              },
              validateSelectedItem: (list, val) {
                ///  identify if item is selected or not
                return list.contains(val);
              },
              onItemSearch: (list, text) {
                /// When text change in search text field then return list containing that text value
                ///
                ///Check if list has value which matchs to text
                if (list.any((element) =>
                    element.name.toLowerCase().contains(text.toLowerCase()))) {
                  /// return list which contains matches
                  return list
                      .where((element) =>
                          element.name.toLowerCase().contains(text.toLowerCase()))
                      .toList();
                }
              },
            );
          }
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String avatar;
  User({this.name, this.avatar});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or whereever you want
List<User> userList = [
  User(name: "Jon", avatar: "asd"),
  User(name: "Lindsey ", avatar: "asd"),
  User(name: "Valarie ", avatar: "asd"),
  User(name: "Elyse ", avatar: "asd"),
  User(name: "Ethel ", avatar: "asd"),
  User(name: "Emelyan ", avatar: "asd"),
  User(name: "Catherine ", avatar: "asd"),
  User(name: "Stepanida  ", avatar: "asd"),
  User(name: "Carolina ", avatar: "asd"),
  User(name: "Nail  ", avatar: "asd"),
];


List<MarcaProductoModel> marcaList = [];
