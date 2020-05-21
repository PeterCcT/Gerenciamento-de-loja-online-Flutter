import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class PedidosBloc extends BlocBase {
  final _pedidosController = BehaviorSubject<List>();

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _pedidos = [];

  Stream<List> get outPedidos => _pedidosController.stream;

  PedidosBloc() {
    _addPedidosListener();
  }

  void _addPedidosListener() {
    _firestore.collection('Pedidos').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((pedido) {
        String id = pedido.document.documentID;

        switch (pedido.type) {
          case DocumentChangeType.added:
            _pedidos.add(pedido.document);
            break;
          case DocumentChangeType.modified:
            _pedidos.removeWhere((pedido) => pedido.documentID == id);
            _pedidos.add(pedido.document);
            break;

          case DocumentChangeType.removed:
            _pedidos.retainWhere((pedido) => pedido.documentID == id);
            break;
        }
      });
      _pedidosController.add(_pedidos);
    });
  }

  @override
  void dispose() {
    _pedidosController.close();
  }
}
