import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum CriterioSort { READY_FIRST, READY_LAST }

class PedidosBloc extends BlocBase {
  final _pedidosController = BehaviorSubject<List>();

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _pedidos = [];

  Stream<List> get outPedidos => _pedidosController.stream;

  CriterioSort _criterio;

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
      _sort();
    });
  }

  void setCriterioSort(CriterioSort criterioSort) {
    _criterio = criterioSort;

    _sort();
  }

  void _sort() {
    switch (_criterio) {
      case CriterioSort.READY_FIRST:
        _pedidos.sort((a, b) {
          int sA = a.data['Status'];
          int sB = b.data['Status'];

          if (sA < sB)
            return 1;
          else if (sA > sB)
            return -1;
          else
            return 0;
        });
        break;
      case CriterioSort.READY_LAST:
        _pedidos.sort((a, b) {
          int sA = a.data['Status'];
          int sB = b.data['Status'];

          if (sA < sB)
            return 1;
          else if (sA < sB)
            return -1;
          else
            return 0;
        });
        break;
    }
    _pedidosController.add(_pedidos);
  }

  @override
  void dispose() {
    _pedidosController.close();
  }
}
