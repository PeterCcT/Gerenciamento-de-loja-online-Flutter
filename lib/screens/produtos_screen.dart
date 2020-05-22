import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/blocs/produtos_bloc.dart';
import 'package:gerenciadorlojavirtual/tiles/images_tile.dart';
import 'package:gerenciadorlojavirtual/validators/produtos_validator.dart';
import 'package:gerenciadorlojavirtual/widgets/produtos_tamanho.dart';

class ProdutoScreen extends StatefulWidget {
  final String categoriaId;
  final DocumentSnapshot produto;

  ProdutoScreen({this.categoriaId, this.produto});

  @override
  _ProdutoScreenState createState() =>
      _ProdutoScreenState(categoriaId, produto);
}

class _ProdutoScreenState extends State<ProdutoScreen> with ProdutoValidator {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _produtoBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? 'Editar Produto' : 'Criar produto');
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _produtoBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder(
                  stream: _produtoBloc.outLoading,
                  initialData: false,
                  builder: (context, snapshot) {
                    return IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _produtoBloc.deleteProd();
                                Navigator.of(context).pop();
                              });
                  },
                );
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _produtoBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveProduto,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
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
                    ImagesTile(
                      context: context,
                      initialValue: snapshot.data['images'],
                      onSaved: _produtoBloc.saveImages,
                      validator: validadeteImages,
                    ),
                    TextFormField(
                      initialValue: snapshot.data['title'],
                      style: _fieldStyle,
                      decoration: _buildDecoration('Título'),
                      onSaved: _produtoBloc.saveTitle,
                      validator: validateTitle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: snapshot.data['preco']?.toStringAsFixed(2),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: _fieldStyle,
                      decoration: _buildDecoration('Preço'),
                      onSaved: _produtoBloc.savePreco,
                      validator: validatePreco,
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
                      onSaved: _produtoBloc.saveDescricao,
                      validator: validateDescription,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Tamanhos',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    ProdutoTamanho(
                      context: context,
                      initialValue: snapshot.data['tamanhos'],
                      onSaved: _produtoBloc.saveTamanho,
                      validator: validateTamanho,
                    ),
                  ],
                );
              },
            ),
          ),
          StreamBuilder<bool>(
            stream: _produtoBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                  color: snapshot.data ? Colors.black54 : Colors.transparent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void saveProduto() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.purpleAccent,
          content: Text(
            'Salvando o produto...',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 15),
        ),
      );

      bool sucesso = await _produtoBloc.saveProduto();
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.purpleAccent,
          content: Text(
            sucesso ? 'Produto salvo com sucesso' : 'Erro ao salvar o produto',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
