import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/blocs/user_bloc.dart';

class PedidoCabecalho extends StatelessWidget {
  final DocumentSnapshot pedido;
  PedidoCabecalho(this.pedido);
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);
    final _user = _userBloc.getUser(pedido.data['ClienteId']);
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_user['nome']}'),
              Text('${_user['email']}'),
              Text('${_user['endereco']}'),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
                'Produtos: R\$ ${pedido.data['ProdutosPreco'].toStringAsFixed(2)}'),
            Text('Total: R\$ ${pedido.data['Total'].toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}
