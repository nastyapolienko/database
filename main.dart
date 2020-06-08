import 'package:flutter/material.dart';
import 'package:adddatadb/ClientModel.dart';
import 'package:adddatadb/Database.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // data for testing
  List<Book> testBooks = [
    Book(bookname: "Test"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Book>>(
        future: DBProvider.db.getAllBooks(),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Book item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteBook(item.id);
                  },
                  child: ListTile(
                    title: Text(item.bookname),
                    leading: Text(item.id.toString()),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Book rnd = testBooks[math.Random().nextInt(testBooks.length)];
          await DBProvider.db.newBook(rnd);
          setState(() {});
        },
      ),
    );
  }
}
