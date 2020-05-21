import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/headers/pedido_header.dart';

class PedidoTile extends StatelessWidget {
  final DocumentSnapshot pedido;
  PedidoTile(this.pedido);
  final estado = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando entrega',
    'Entregue'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text(
            '#${pedido.documentID.substring(pedido.documentID.length - 7, pedido.documentID.length)} -- ${estado[pedido.data['Status']]}',
            style: TextStyle(color: pedido.data['Status'] != 4 ? Colors.grey[850]: Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 13, right: 13, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PedidoCabecalho(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: pedido.data['Produtos'].map<Widget>(
                      (prod) {
                        return ListTile(
                          title: Text(
                              '${prod['produto']['title']} -- ${prod['tamanho']}'),
                          subtitle: Text('${prod['categoria']}'),
                          trailing: Text(
                            '${prod['quantidade']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        child: Text('Excluir'),
                        textColor: Colors.red,
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Regredir'),
                        textColor: Colors.black,
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Avançar'),
                        textColor: Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
