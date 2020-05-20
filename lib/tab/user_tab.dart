import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/blocs/user_bloc.dart';
import 'package:gerenciadorlojavirtual/tiles/user_tile.dart';

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(color: Colors.white),
            onChanged: _userBloc.onChangedSearch,
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
            child: StreamBuilder<List>(
                stream: _userBloc.outUser,
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
                        'Nenhum usuário encontrado',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return UserTile(snapshot.data[index]);
                    },
                    itemCount: snapshot.data.length,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
