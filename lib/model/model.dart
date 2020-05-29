import 'package:docExpiry/util/utils.dart';

class Doc {

  // represents document read and written to  the SQLite database
  int id;
  String title;
  String expiration;

  int fqYear;
  int fqHalfYear;
  int fqQuarter;
  int fqMonth;

  // Constructor used if we dont want to assign an id immediately 
  Doc(this.title, this.expiration, this.fqYear, this.fqHalfYear, this.fqQuarter,
      this.fqMonth);
  
  // Constructor used if we want to assign an id immediately 
  Doc.withId(this.id, this.title, this.expiration, this.fqYear, this.fqHalfYear,
      this.fqQuarter, this.fqMonth);
  
  // Document write to the database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['title'] = this.title;
    map['expiration'] = this.expiration;
    map['fqYear'] = this.fqYear;
    map['fqHalfYear'] = this.fqHalfYear;
    map['fqQuarter'] = this.fqQuarter;
    map['fqMonth'] = this.fqMonth;

    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }

  // Document read from the database
  Doc.fromObject(dynamic o) {
    this.id = o["id"];
    this.title = o["title"];
    this.expiration = DateUtils.trimDate(o["expiration"]);
    this.fqYear = o["fqYear"];
    this.fqHalfYear = o["fqHalfYear"];
    this.fqQuarter = o["fqQuarter"];
    this.fqMonth = o["fqMonth"];
  }
}
