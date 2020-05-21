import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenciadorlojavirtual/blocs/user_bloc.dart';
import 'package:gerenciadorlojavirtual/tab/pedidos_tab.dart';
import 'package:gerenciadorlojavirtual/tab/produtos_tab.dart';
import 'package:gerenciadorlojavirtual/tab/user_tab.dart';
import 'package:gerenciadorlojavirtual/blocs/pedidos_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _p = 0;

  UserBloc _userBloc;
  PedidosBloc _pedidosBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _pedidosBloc = PedidosBloc();
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
          child: BlocProvider<PedidosBloc>(
            bloc: _pedidosBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _p = page;
                });
              },
              children: <Widget>[
                UserTab(),
                PedidosTab(),
                ProdutosTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_p) {
      case 0:
        return null;
        break;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort, color: Colors.white),
          backgroundColor: Colors.purple,
          overlayOpacity: 0.6,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.purpleAccent,
                ),
                backgroundColor: Colors.black,
                label: 'Concluido abaixo',
                labelStyle: TextStyle(color: Colors.black),
                onTap: () {
                  _pedidosBloc.setCriterioSort(CriterioSort.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.purpleAccent,
                ),
                backgroundColor: Colors.black,
                label: 'Concluido acima',
                labelStyle: TextStyle(color: Colors.black),
                onTap: () {
                  _pedidosBloc.setCriterioSort(CriterioSort.READY_FIRST);
                }),
          ],
        );
      default: return Container();
    }
  }
}
