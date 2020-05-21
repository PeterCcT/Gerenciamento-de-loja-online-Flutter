import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriaTile extends StatelessWidget {
  final DocumentSnapshot categoria;
  CategoriaTile(this.categoria);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text(
            categoria.data['title'],
            style: TextStyle(
              color: Colors.grey[850],
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(categoria.data['icon']),
          ),
          children: <Widget>[
            FutureBuilder(
                future: categoria.reference.collection('itens').getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return Column(
                      children: snapshot.data.documents.map<Widget>(
                        (item) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                item.data['images'][0],
                              ),
                            ),
                            title: Text('${item.data['title']}'),
                            trailing: Text(
                                'R\$ ${item.data['preco'].toStringAsFixed(2)}'),
                                onTap: (){},
                          );
                          
                        },
                      ).toList()
                        ..add(
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.add,
                                color: Colors.purpleAccent,
                              ),
                            ),
                            title: Text(
                              'Adicionar',
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {},
                          ),
                        ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
