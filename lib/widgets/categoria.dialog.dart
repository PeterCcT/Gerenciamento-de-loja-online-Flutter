import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/blocs/categoria_bloc.dart';
import 'package:gerenciadorlojavirtual/widgets/image_search_sheet.dart';

class CategoriaDialog extends StatelessWidget {
  final CategoriaBloc _categoriaBloc;
  final TextEditingController _controller;
  CategoriaDialog({DocumentSnapshot categoria})
      : _categoriaBloc = CategoriaBloc(categoria),
        _controller = TextEditingController(
            text: categoria != null ? categoria.data['title'] : '');
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSearchSheet(
                            onImageSelected: (image) {
                              Navigator.of(context)
                                  .pop(_categoriaBloc.setImage(image));
                            },
                          ));
                },
                child: StreamBuilder<dynamic>(
                  stream: _categoriaBloc.outImage,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return CircleAvatar(
                        child: snapshot.data is File
                            ? Image.file(snapshot.data, fit: BoxFit.cover)
                            : Image.network(
                                snapshot.data,
                                fit: BoxFit.cover,
                              ),
                        backgroundColor: Colors.transparent,
                      );
                    } else
                      return Icon(Icons.image);
                  },
                ),
              ),
              title: StreamBuilder<String>(
                  stream: _categoriaBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _controller,
                      onChanged: _categoriaBloc.setTitle,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoriaBloc.outDelete,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FlatButton(
                          onPressed: snapshot.data
                              ? () {
                                  _categoriaBloc.delete();
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Text('Excluir'),
                          textColor: Colors.red,
                        );
                      } else
                        return Container();
                    }),
                StreamBuilder<bool>(
                    stream: _categoriaBloc.submitValid,
                    builder: (context, snapshot) {
                      return FlatButton(
                        onPressed: snapshot.hasData
                            ? () {
                                _categoriaBloc.saveCategoria();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text('Salvar'),
                        textColor: Colors.green,
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
