import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/tiles/user_tile.dart';

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
               return UserTile();
              },
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
