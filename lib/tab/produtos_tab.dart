import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/tiles/categoria_tile.dart';

class ProdutosTab extends StatefulWidget {
  @override
  _ProdutosTabState createState() => _ProdutosTabState();
}

class _ProdutosTabState extends State<ProdutosTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('produtos').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return CategoriaTile(snapshot.data.documents[index]);
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
