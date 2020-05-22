import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProdutoBloc extends BlocBase {
  String categoriaId;
  DocumentSnapshot produto;
  Map<String, dynamic> unsavedData;
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  ProdutoBloc({this.categoriaId, this.produto}) {
    if (produto != null) {
      unsavedData = Map.of(produto.data);
      unsavedData['images'] = List.of(produto.data['images']);
      unsavedData['tamanhos'] = List.of(produto.data['tamanhos']);
      _createdController.add(true);
    } else {
      unsavedData = {
        'descricao': null,
        'images': [],
        'preco': null,
        'tamanhos': [],
        'title': null
      };
      _createdController.add(false);
    }
    _dataController.add(unsavedData);
  }

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  void saveTitle(String title) {
    unsavedData['title'] = title;
  }

  void savePreco(String preco) {
    unsavedData['preco'] = double.parse(preco);
  }

  void saveDescricao(String descricao) {
    unsavedData['descricao'] = descricao;
  }

  void saveImages(List images) {
    unsavedData['images'] = images;
  }

  void saveTamanho(List tamanhos) {
    unsavedData['tamanhos'] = tamanhos;
  }

  Future<bool> saveProduto() async {
    _loadingController.add(true);
    try {
      if (produto != null) {
        await _uploadImages(produto.documentID);
        await produto.reference.updateData(unsavedData);
      } else {
        DocumentReference reference = await Firestore.instance
            .collection('produtos')
            .document(categoriaId)
            .collection('itens')
            .add(Map.from(unsavedData)..remove('images'));
        await _uploadImages(reference.documentID);
        await reference.updateData(unsavedData);
      }
      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (erro) {
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String produtoId) async {
    for (int i = 0; i < unsavedData['images'].length; i++) {
      if (unsavedData['images'][i] is String) continue;
      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoriaId)
          .child(produtoId)
          .child(UniqueKey().toString())
          .putFile(unsavedData['images'][i]);

      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String dowloadUrl = await snapshot.ref.getDownloadURL();

      unsavedData['images'][i] = dowloadUrl;
    }
  }

  void deleteProd() {
    produto.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
