import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/blocs/user_bloc.dart';
import 'package:gerenciadorlojavirtual/tab/user_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _p = 0;

  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.purpleAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _p,
          onTap: (page) {
            _pageController.animateToPage(
              page,
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutExpo,
            );
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Clientes')),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text('Pedidos')),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Produtos')),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _p = page;
              });
            },
            children: <Widget>[
              UserTab(),
              Container(color: Colors.blue),
              Container(color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
