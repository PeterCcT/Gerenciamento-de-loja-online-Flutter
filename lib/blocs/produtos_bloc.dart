import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProdutoBloc extends BlocBase {
  String categoriaId;
  DocumentSnapshot produto;
  Map<String, dynamic> unsavedData;
  final _dataController = BehaviorSubject<Map>();

  ProdutoBloc({this.categoriaId, this.produto}) {
    if (produto != null) {
      unsavedData = Map.of(produto.data);
      unsavedData['images'] = List.of(produto.data['images']);
      unsavedData['tamanhos'] = List.of(produto.data['tamanhos']);
    } else {
      unsavedData = {
        'descricao': null,
        'images': [],
        'preco': null,
        'tamanhos': [],
        'title': null
      };
    }
    _dataController.add(unsavedData);
  }

  Stream<Map> get outData => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
