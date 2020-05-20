import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _userController = BehaviorSubject<List>();
  Map<String, Map<String, dynamic>> _users = {};
  Stream<List> get outUser => _userController.stream;

  Firestore _firestore = Firestore.instance;

  UserBloc() {
    _addUsersListener();
  }
  void _addUsersListener() {
    _firestore.collection('Users').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            _userController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeOrdes(uid);
            _userController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]['subscription'] = _firestore
        .collection('Users')
        .document(uid)
        .collection('Pedidos')
        .snapshots()
        .listen((pedidos) async {
      int quantOrders = pedidos.documents.length;
      double gasto = 0;
      for (DocumentSnapshot doc in pedidos.documents) {
        DocumentSnapshot order = await _firestore
            .collection('Pedidos')
            .document(doc.documentID)
            .get();
        if (order.data == null) continue;
        gasto += order.data['Total'];
      }
      _users[uid].addAll({'Gasto': gasto, 'Pedidos': quantOrders});
      _userController.add(_users.values.toList());
    });
  }

  void _unsubscribeOrdes(String uid) {
    _users[uid]['subscriptionu'].cancel();
  }

  void onChangedSearch(String pesquisa) {
    if (pesquisa.trim().isEmpty) {
      _userController.add(_users.values.toList());
    } else {
      _userController.add(_filter(pesquisa.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String pesquisa) {
    List<Map<String, dynamic>> listaFiltrada =
        List.from(_users.values.toList());
    listaFiltrada.retainWhere((user) {
      return user['nome'].toUpperCase().contains(pesquisa.toUpperCase());
    });
    return listaFiltrada;
  }

  @override
  void dispose() {
    _userController.close();
  }
}
