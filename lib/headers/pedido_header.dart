import 'package:flutter/material.dart';

class PedidoCabecalho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Teste'),
              Text('Teste qualuqer coisa'),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Teste'),
            Text('Teste qualuqer coisa'),
          ],
        ),
      ],
    );
  }
}
