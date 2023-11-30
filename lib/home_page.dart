import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'juros_compostos.dart';


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
          mainAxisAlignment: MainAxisAlignment.start, // Ajuste para alinhar no início do eixo vertical
          crossAxisAlignment: CrossAxisAlignment.center, // Alinha no centro do eixo horizontal
          children: <Widget>[
            // Botões centralizados
            // Texto na parte superior da tela
            Padding(
              padding: EdgeInsets.only(top: 50.0), // Ajuste o espaçamento conforme necessário
              child: Text(
                'Obrigado pelo acesso, $userName!\nAproveite as funcionalidades deste app.',
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 150),
                ElevatedButton(
                  onPressed: () async {
                    // Navegar para a nova página quando o botão for pressionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JurosCompostos()),
                    );
                  },
                  child: Text('Simular\njuros compostos',
                      textAlign: TextAlign.center),
                ),
                SizedBox(width: 80), // Espaçamento entre os botões
                ElevatedButton(
                  onPressed: () {
                    // Adicione a ação desejada para o botão 2
                  },
                  child: Text('Botão 2'),
                ),
              ],
            ),
            // Espaçamento entre os grupos de botões
            SizedBox(height: 80),
            // Botões na parte inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Adicione a ação desejada para o botão 3
                  },
                  child: Text('Botão 3'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Adicione a ação desejada para o botão 4
                  },
                  child: Text('Botão 4'),
                ),
              ],
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
          // ListTile(
          //   leading: Icon(Icons.home),
          //   title: Text('Login'),
          //   onTap: () {
          //     Navigator.of(context).pop(); // Ação quando o item é selecionado
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Simular juros compostos'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JurosCompostos(),
                ),
              );
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
