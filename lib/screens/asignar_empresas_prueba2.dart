// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// void main() {
//   runApp(new MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   DatabaseClient _db = new DatabaseClient();
//   int number;
//   List listCategory;
//   List<Widget> tiles;

//   List colors = [
//     const Color(0xFFFFA500),
//     const Color(0xFF279605),
//     const Color(0xFF005959)
//   ];

//   createdb() async {
//     await _db.create().then(
//       (data){
//         _db.countCategory().then((list){
//           setState(() {
//             this.number = list[0][0]['COUNT(*)']; //3
//             this.listCategory = list[1];            
//             //[{name: foo1, color: 0}, {name: foo2, color: 1}, {name: foo3, color: 2}]
//           });          
//         });
//       }
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     createdb();    
//   }

//   void showCategoryDialog<T>({ BuildContext context, Widget child }) {
//     showDialog<T>(
//       context: context,
//       child: child,
//     )
//     .then<Null>((T value) {
//       if (value != null) {
//         setState(() { print(value); });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     List<Widget> buildTile(int counter) {
//       this.tiles = [];
//       for(var i = 0; i < counter; i++) {
//         this.tiles.add(
//           new DialogItem(
//             icon: Icons.brightness_1,
//             color: this.colors[
//               this.listCategory[i]['color']
//             ],
//             text: this.listCategory[i]['name'],
//             onPressed: () {
//               Navigator.pop(context, this.listCategory[i]['name']);
//             }
//           )
//         );
//       }
//       return this.tiles;
//     }

//     return new Scaffold(
//       appBar: new AppBar(),
//       body: new Center(
//         child: new RaisedButton(
//           onPressed: (){           
//             showCategoryDialog<String>(
//               context: context,
//               child: new SimpleDialog(
//                 title: const Text('Categories'),
//                 children: buildTile(this.number)
//               )
//             );
//           },
//           child: new Text("ListButton"),
//         )
//       ),
//     );
//   }
// }

// //Creating Database with some data and two queries
// class DatabaseClient {
//   Database db;

//   Future create() async {
//     Directory path = await getApplicationDocumentsDirectory();
//     String dbPath = join(path.path, "database.db");
//     db = await openDatabase(dbPath, version: 1, onCreate: this._create);
//   }

//   Future _create(Database db, int version) async {
//     await db.execute("""
//             CREATE TABLE category (
//               id INTEGER PRIMARY KEY,
//               name TEXT NOT NULL,
//               color INTEGER NOT NULL
//             )""");
//     await db.rawInsert("INSERT INTO category (name, color) VALUES ('foo1', 0)");
//     await db.rawInsert("INSERT INTO category (name, color) VALUES ('foo2', 1)");
//     await db.rawInsert("INSERT INTO category (name, color) VALUES ('foo3', 2)");
//   }

//   Future countCategory() async {
//     Directory path = await getApplicationDocumentsDirectory();
//     String dbPath = join(path.path, "database.db");
//     Database db = await openDatabase(dbPath);

//     var count = await db.rawQuery("SELECT COUNT(*) FROM category");
//     List list = await db.rawQuery('SELECT name, color FROM category');
//     await db.close();

//     return [count, list];
//   }
// }

// //Class of Dialog Item
// class DialogItem extends StatelessWidget {
//   DialogItem({ 
//     Key key,
//     this.icon,
//     this.size,
//     this.color,
//     this.text,
//     this.onPressed }) : super(key: key);

//   final IconData icon;
//   double size = 36.0;
//   final Color color;
//   final String text;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return new SimpleDialogOption(
//       onPressed: onPressed,
//       child: new Container(
//         child: new Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             new Container(              
//               child: new Container(
//                 margin: size == 16.0 ? new EdgeInsets.only(left: 7.0) : null,
//                 child: new Icon(icon, size: size, color: color),
//               )                
//             ),        
//             new Padding(
//               padding: size == 16.0 ?
//                 const EdgeInsets.only(left: 17.0) :
//                 const EdgeInsets.only(left: 16.0),
//               child: new Text(text),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }