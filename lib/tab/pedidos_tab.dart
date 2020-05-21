import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/tiles/pedidos_tile.dart';
import 'package:gerenciadorlojavirtual/blocs/pedidos_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class PedidosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pedidodosBloc = BlocProvider.of<PedidosBloc>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<List>(
          stream: _pedidodosBloc.outPedidos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'Nenhum pedido encontrado',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return PedidoTile(snapshot.data[index]);
              },
            );
          }),
    );
  }
}
