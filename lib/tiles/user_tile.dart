import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;
  UserTile(this.user);
  @override
  Widget build(BuildContext context) {
      if (user.containsKey('Gasto'))
      return Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          dense: true,
          title: Text(
            user['nome'],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          subtitle: Text(
            user['email'],
            style: TextStyle(color: Colors.white),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'Pedidos: ${user['Pedidos']}',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                'Total: ${user['Gasto'].toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    else 
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 500,
            height: 50,
            child: Shimmer.fromColors(
                child: Container(color: Colors.white.withAlpha(50)),
                baseColor: Colors.white,
                highlightColor: Colors.grey),
          ),
        ],
      ),
    );
  }
}
