import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  final String userName;
  final Future<void> Function(BuildContext) signOut; // Modifique o tipo da função para aceitar uma função assíncrona

  HomePage(this.userName, this.signOut);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),
      ),
      drawer: MyDrawer(signOut), // Crie o Drawer como um widget separado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bem-vindo à sua página inicial, $userName!'),
            ElevatedButton(
              onPressed: () async {
                await signOut(context); // Chame a função signOut assíncrona quando o botão for pressionado
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {

  final Function(BuildContext) onSignOut; // Função para realizar o sign out
  MyDrawer(this.onSignOut);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Seu nome'),
            accountEmail: Text('seu_email@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('caminho_para_imagem.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Login'),
            onTap: () {
              Navigator.of(context).pop(); // Ação quando o item é selecionado
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              // Ação quando o item é selecionado
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20), // Ajuste o valor conforme necessário
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sair'),
                  onTap: () {
                    onSignOut(context); // Chame a função de sign out
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
