import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CategoriaBloc extends BlocBase {
  final _titlecontroller = BehaviorSubject<String>();
  final _imagecontroller = BehaviorSubject<dynamic>();
  final _deletecontroller = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titlecontroller.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
        if (title.isEmpty) {
          sink.addError('Insira um título');
        } else {
          sink.add(title);
        }
      }));
  Stream<dynamic> get outImage => _imagecontroller.stream;
  Stream<bool> get outDelete => _deletecontroller.stream;
  Stream<bool> get submitValid =>
      Observable.combineLatest2(outImage, outTitle, (a, b) => true);

  DocumentSnapshot categoria;
  File image;
  String title;

  CategoriaBloc(this.categoria) {
    if (categoria != null) {
      title = categoria.data['title'];
      _titlecontroller.add(categoria.data['title']);
      _imagecontroller.add(categoria.data['icon']);
      _deletecontroller.add(true);
    } else {
      _deletecontroller.add(false);
    }
  }

  void setImage(File file) {
    image = file;
    _imagecontroller.add(file);
  }

  void setTitle(String title) {
    this.title = title;
    _titlecontroller.add(title);
  }

  Future saveCategoria() async {
    if (image == null && categoria != null && title == categoria.data['title'])
      return;

    Map<String, dynamic> dataUpdate = {};
    if (image != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('icon')
          .child(title)
          .putFile(image);
      StorageTaskSnapshot snapshot = await task.onComplete;
      dataUpdate['icon'] = await snapshot.ref.getDownloadURL();
    }
    if (categoria == null || title != categoria.data['title']) {
      dataUpdate['title'] = title;
    }

    if (categoria == null) {
      await Firestore.instance
          .collection('produtos')
          .document(title.toLowerCase())
          .setData(dataUpdate);
    } else {
      await categoria.reference.updateData(dataUpdate);
    }
  }

  void delete() {
    categoria.reference.delete();
  }

  @override
  void dispose() {
    _titlecontroller.close();
    _imagecontroller.close();
    _deletecontroller.close();
  }
}
