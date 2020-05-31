// Menu item
import 'package:docExpiry/util/dbhelper.dart';
import 'package:docExpiry/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:docExpiry/model/model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

const menuDelete = "Delete";
final List<String> menuOptions = const <String>[menuDelete];

class DocDetails extends StatefulWidget {
  final Doc doc;
  final DbHelper dbHelper = DbHelper();
  DocDetails(this.doc);

  @override
  _DocDetailsState createState() => _DocDetailsState();
}

class _DocDetailsState extends State<DocDetails> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();

  final int daysAhead = 5475; // 15 years in the future

  final TextEditingController titleController = TextEditingController();
  final TextEditingController expirationController =
      MaskedTextController(mask: '2000-00-00');

  bool fqYearCtrl = true;
  bool fqHalfYearCtrl = true;
  bool fqQuarterCtrl = true;
  bool fqMonthCtrl = true;
  bool fqLessMonthCtrl = true;

  // Initialization
  void _initCtrls() {
    titleController.text = widget.doc.title != null ? widget.doc.title : "";
    expirationController.text =
        widget.doc.expiration != null ? widget.doc.expiration : "";

    fqYearCtrl = widget.doc.fqYear != null
        ? Validate.intToBool(widget.doc.fqYear)
        : false;
    fqHalfYearCtrl = widget.doc.fqHalfYear != null
        ? Validate.intToBool(widget.doc.fqHalfYear)
        : false;
    fqQuarterCtrl = widget.doc.fqQuarter != null
        ? Validate.intToBool(widget.doc.fqQuarter)
        : false;
    fqMonthCtrl = widget.doc.fqMonth != null
        ? Validate.intToBool(widget.doc.fqMonth)
        : false;
  }

  // Date picker & Date function
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = DateUtils.convertToDate(initialDateString) ?? now;

    initialDate = (initialDate.year >= now.year && initialDate.isAfter(now)
        ? initialDate
        : now);

    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        DateTime dt = date;
        String dateAsStr = DateUtils.formatDateASStr(dt);
        expirationController.text = dateAsStr;
      });
    }, currentTime: initialDate);
  }

  // Upper menu
  void _selectmenu(String value) async {
    switch (value) {
      case menuDelete:
        if (widget.doc.id == -1) {
          return;
        }
        await _deleteDoc(widget.doc.id);
    }
  }

  // Delete doc
  void _deleteDoc(int id) async {
     await widget.dbHelper.deleteDoc(widget.doc.id);
    Navigator.pop(context, true);
  }

  // Save doc
  void _saveDoc() {
    widget.doc.title = titleController.text;
    widget.doc.expiration = expirationController.text;

    widget.doc.fqYear = Validate.boolToInt(fqYearCtrl);
    widget.doc.fqHalfYear = Validate.boolToInt(fqHalfYearCtrl);
    widget.doc.fqQuarter = Validate.boolToInt(fqQuarterCtrl);
    widget.doc.fqMonth = Validate.boolToInt(fqMonthCtrl);

    if (widget.doc.id > -1) {
      debugPrint("_update->Doc Id: " + widget.doc.id.toString());
      widget.dbHelper.updateDoc(widget.doc);
      Navigator.pop(context, true);
    } else {
      Future<int> idd = widget.dbHelper.getMaxId();
      idd.then((result) {
        debugPrint("_insert->Doc Id: " + widget.doc.id.toString());
        widget.doc.id = (result != null) ? result + 1 : 1;
        widget.dbHelper.insertDoc(widget.doc);
        Navigator.pop(context, true);
      });
    }
  }

  // Submit form
  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Some data is invalid. Please correct.');
    } else {
      _saveDoc();
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scafoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _initCtrls();
  }

  @override
  Widget build(BuildContext context) {
    const String cStrDays = "Enter a number of days";
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    String title = widget.doc.title;

    return Scaffold(
      key: _scafoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title != "" ? widget.doc.title : "New Document"),
        actions: (title == "")
            ? <Widget>[]
            : <Widget>[
                PopupMenuButton(
                    onSelected: _selectmenu,
                    itemBuilder: (BuildContext context) {
                      return menuOptions.map((choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    })
              ],
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: SafeArea(
          top: false,
          bottom: false,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
                ],
                controller: titleController,
                style: textStyle,
                validator: (val) => Validate.validateTitle(val),
                decoration: InputDecoration(
                  icon: const Icon(Icons.title),
                  hintText: 'Enter the document name',
                  labelText: 'Document Name',
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    controller: expirationController,
                    maxLength: 10,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'Expiry date (i.e. ' +
                            DateUtils.daysAheadAsStr(daysAhead) +
                            ')',
                        labelText: 'Expiry Date'),
                    keyboardType: TextInputType.number,
                    validator: (val) => DateUtils.isValidDate(val)
                        ? null
                        : 'Not a valid future date',
                  )),
                  IconButton(
                      icon: new Icon(Icons.more_horiz), 
                      tooltip: 'Chooce date',
                      onPressed: (() {
                        _chooseDate(context, expirationController.text);
                      }))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text(" ")),
                ],
              ),
              Row(children: <Widget>[
                Expanded(child: Text('a: Alert @ 1.5 & 1 year(s)')),
                Switch(value: fqYearCtrl, onChanged: (value){
                  setState(() {
                    fqYearCtrl = value;
                  });
                })
              ],),
              Row(
                children: <Widget>[
                  Expanded(child: Text(" ")),
                ],
              ),
              Row(children: <Widget>[
                Expanded(child: Text('b: Alert @ 6 month(s)')),
                Switch(value: fqHalfYearCtrl, onChanged: (value){
                  setState(() {
                    fqHalfYearCtrl = value;
                  });
                })
              ],),
              Row(
                children: <Widget>[
                  Expanded(child: Text(" ")),
                ],
              ),
               Row(children: <Widget>[
                Expanded(child: Text('b: Alert @ 3 month(s)')),
                Switch(value: fqQuarterCtrl, onChanged: (value){
                  setState(() {
                    fqQuarterCtrl = value;
                  });
                })
              ],),
              Row(
                children: <Widget>[
                  Expanded(child: Text(" ")),
                ],
              ),
              Row(children: <Widget>[
                Expanded(child: Text('c: Alert @ 1 monthor less')),
                Switch(value: fqMonthCtrl, onChanged: (value){
                  setState(() {
                    fqMonthCtrl = value;
                  });
                })
              ],),
              Row(
                children: <Widget>[
                  Expanded(child: Text(" ")),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 40.0, top:20.0
                ),
                child: RaisedButton(
                  child: Text("Save"),
                  onPressed: _submitForm)
              )
            ],
          ),
        ),
      ),
    );
  }
}
