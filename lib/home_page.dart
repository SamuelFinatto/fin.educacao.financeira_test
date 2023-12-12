import 'package:flutter/material.dart';
import 'package:moneysense/doacao.dart';
import 'conteudos.dart';
import 'juros_compostos.dart';
import 'orientadores.dart';


class HomePage extends StatelessWidget {
  final String userName;
  final String email;
  final Function(BuildContext) signOut; // Modifique o tipo da função para aceitar uma função assíncrona

  const HomePage(this.userName, this.email, this.signOut);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        backgroundColor: Colors.green.shade800 // Defina a cor desejada para a barra superior desta tela
      ),
      drawer: MyDrawer(signOut, userName, email), // Crie o Drawer como um widget separado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Texto na parte superior da tela
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                'Obrigado pelo acesso, $userName!',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 17, // Tamanho da fonte desejado
                  // Outras propriedades de estilo podem ser adicionadas aqui, se necessário
                ),
              ),
            ),
            const SizedBox(height: 50), // Espaçamento entre o texto e os botões
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JurosCompostos()),
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                fixedSize: const Size(250,70), // Ajuste a largura e altura do botão respectivamente
              ),
              child: const Text(
                'Simular juros compostos',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Conteudos()),
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 18),
                fixedSize: const Size(250,70), // Ajuste a largura e altura do botão respectivamente
              ),
              child: const Text(
                'Conteúdos sobre Educação Financeira',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20), // Espaçamento entre os botões // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Doacao()),
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                fixedSize: const Size(250,70), // Ajuste a largura e altura do botão respectivamente
              ),
              child: const Text('Doação ao projeto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Orientador()),
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                fixedSize: const Size(250,70), // Ajuste a largura e altura do botão respectivamente
              ),
              child: const Text('Contatar um\nOrientador Financeiro',
                textAlign: TextAlign.center,),
            ),
            // Texto na parte superior da tela
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                'Para maior eficácia do aprendizado:\n'
                    '- Utilize este app semanalmente;\n'
                    '- Acesse todas as opções disponíveis;\n'
                    '- Domine cada conteúdo existente;\n'
                    '- Busque outras fontes de conhecimento.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16, // Tamanho da fonte desejado
                  // Outras propriedades de estilo podem ser adicionadas aqui, se necessário
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {

  final String userName;
  final String email;
  final Function(BuildContext) onSignOut; // Função para realizar o sign out
  MyDrawer(this.onSignOut, this.userName, this.email);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('$userName'),
            accountEmail: Text('$email'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/perfil_transparente_com_sombra.png'),
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
            leading: Icon(Icons.auto_graph),
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
            leading: Icon(Icons.text_snippet_rounded),
            title: Text('Conteúdos sobre\nEducação Financeira'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Conteudos(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money_outlined),
            title: Text('Doação ao projeto'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Doacao(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail_rounded),
            title: Text('Contatar Orientador Financeiro'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Orientador(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Configurações'),
          //   onTap: () {
          //     // Ação quando o item é selecionado
          //   },
          // ),
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
