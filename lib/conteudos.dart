import 'package:flutter/material.dart';
import 'juros_compostos.dart';


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
      ),
      drawer: MyDrawer(signOut, userName, email), // Crie o Drawer como um widget separado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                fixedSize: const Size.fromHeight(70), // Ajuste a altura desejada aqui
              ),
              child: const Text(
                'Simular juros compostos',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Adicione a ação desejada para o botão 3
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 18),
                fixedSize: const Size.fromHeight(70), // Ajuste a altura desejada aqui
              ),
              child: const Text(
                'Conteúdos sobre Educação Financeira',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20), // Espaçamento entre os botões // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Adicione a ação desejada para o botão 2
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Botão 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione a ação desejada para o botão 4
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Botão 4'),
            ),

            // Texto na parte superior da tela
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                'Obrigado pelo acesso, $userName!\n\nPara maior eficácia do aprendizado:\n'
                    '- Utilize este app semanalmente;\n'
                    '- Acesse todas as funcionalidades disponíveis;\n'
                    '- Domine cada conteúdo existente;\n'
                    '- Busque outras fontes de conhecimento.',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 17, // Tamanho da fonte desejado
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
            // currentAccountPicture: CircleAvatar(
            //   backgroundImage: AssetImage('caminho_para_imagem.jpg'),
            // ),
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
