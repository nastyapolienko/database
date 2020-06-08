import 'dart:convert';

Book bookFromJson(String str) {
  final jsonData = json.decode(str);
  return Book.fromMap(jsonData);
}

String bookToJson(Book data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Book {
  int id;
  String bookname;

  Book({
    this.id,
    this.bookname,
  });

  factory Book.fromMap(Map<String, dynamic> json) => new Book(
    id: json["id"],
    bookname: json["bookname"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "bookname": bookname,
  };
}
