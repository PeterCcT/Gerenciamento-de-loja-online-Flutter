import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/blocs/produtos_bloc.dart';
import 'package:gerenciadorlojavirtual/tiles/images_tile.dart';

class ProdutoScreen extends StatefulWidget {
  final String categoriaId;
  final DocumentSnapshot produto;

  ProdutoScreen({this.categoriaId, this.produto});

  @override
  _ProdutoScreenState createState() =>
      _ProdutoScreenState(categoriaId, produto);
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final _formKey = GlobalKey<FormState>();

  final ProdutoBloc _produtoBloc;

  _ProdutoScreenState(String categoriaId, DocumentSnapshot produto)
      : _produtoBloc = ProdutoBloc(categoriaId: categoriaId, produto: produto);

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        title: Text('Criar produto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.remove), onPressed: () {}),
          IconButton(icon: Icon(Icons.save), onPressed: () {}),
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
          stream: _produtoBloc.outData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              Container();
            }
            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Text(
                  'Imagens',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                ImagesTile(),
                TextFormField(
                  initialValue: snapshot.data['title'],
                  style: _fieldStyle,
                  decoration: _buildDecoration('Título'),
                  onSaved: (text) {},
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: snapshot.data['preco']?.toStringAsFixed(2),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: _fieldStyle,
                  decoration: _buildDecoration('Preço'),
                  onSaved: (text) {},
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: snapshot.data['descricao'],
                  style: _fieldStyle,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onSaved: (text) {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
