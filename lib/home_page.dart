import 'package:flutter/material.dart';
import 'package:fin.educacao.financeira/doacao.dart';
import 'glossario.dart';
import 'juros_compostos.dart';
import 'orientadores.dart';
import 'sobre.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatelessWidget {
  final String userName;
  final String email;
  final Function(BuildContext) signOut; // Modifique o tipo da função para aceitar uma função assíncrona

  const HomePage(this.userName, this.email, this.signOut);

  // Método para abrir a URL no navegador
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir a URL $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Página Inicial'),
          backgroundColor: Colors.green.shade800 // Defina a cor desejada para a barra superior desta tela
      ),
      drawer: MyDrawer(signOut, userName, email, _launchURL), // Crie o Drawer como um widget separado
      backgroundColor: Colors.white, // Cor de fundo da tela
      body: SingleChildScrollView(
        child: Center(
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


              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)], // Cores base do gradiente
                    begin: Alignment.topCenter, // Início do gradiente (cima)
                    end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                  ),
                  borderRadius: BorderRadius.circular(8), // Adicione bordas arredondadas conforme necessário
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JurosCompostos()),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 70,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_graph, // Ícone de gráfico automático
                          color: Colors.white, // Cor do ícone
                        ),
                        SizedBox(width: 15), // Espaçamento entre o ícone e o texto
                        Text(
                          'Simular juros\ncompostos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Cor do texto branca para melhor contraste
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 20), // Espaçamento entre os botões

              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)], // Cores base do gradiente
                    begin: Alignment.topCenter, // Início do gradiente (cima)
                    end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                  ),
                  borderRadius: BorderRadius.circular(8), // Adicione bordas arredondadas conforme necessário
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Glossario()),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 70,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.text_snippet_outlined, // Ícone de snippet de texto
                          color: Colors.white, // Cor do ícone
                        ),
                        SizedBox(width: 15), // Espaçamento entre o ícone e o texto
                        Text(
                          'Glossário sobre\nEducação Financeira',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Cor do texto branca para melhor contraste
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 20), // Espaçamento entre os botões // Espaçamento entre os botões

              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)], // Cores base do gradiente
                    begin: Alignment.topCenter, // Início do gradiente (cima)
                    end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                  ),
                  borderRadius: BorderRadius.circular(8), // Adicione bordas arredondadas conforme necessário
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Doacao()),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 70,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money_outlined, // Ícone de dinheiro
                          color: Colors.white, // Cor do ícone
                        ),
                        SizedBox(width: 10), // Espaçamento entre o ícone e o texto
                        Text(
                          'Doação ao projeto',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Cor do texto branca para melhor contraste
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 20),

              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)], // Cores base do gradiente
                    begin: Alignment.topCenter, // Início do gradiente (cima)
                    end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                  ),
                  borderRadius: BorderRadius.circular(8), // Adicione bordas arredondadas conforme necessário
                ),
                child: InkWell(
                  onTap: () {
                    _launchURL('https://www.serasa.com.br/score/');
                  },
                  child: Container(
                    width: 250,
                    height: 70,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_chart_outlined, // Ícone de pontuação, você pode alterar para o ícone desejado
                          color: Colors.white, // Cor do ícone
                        ),
                        SizedBox(width: 15), // Espaçamento entre o ícone e o texto
                        Text(
                          'Consultar Score',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Cor do texto branca para melhor contraste
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 20),

              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1000D3),Color(0xFF1A6BFF)], // Cores base do gradiente
                    begin: Alignment.topCenter, // Início do gradiente (cima)
                    end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                  ),
                  borderRadius: BorderRadius.circular(8), // Adicione bordas arredondadas conforme necessário
                ),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Orientador()),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 70,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_outlined, // Ícone de uma pessoa, você pode mudar para o ícone desejado
                          color: Colors.white, // Cor do ícone
                        ),
                        SizedBox(width: 15), // Espaçamento entre o ícone e o texto
                        Text(
                          'Contatar um\nOrientador Financeiro',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Cor do texto branca para melhor contraste
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),



              const SizedBox(height: 20),

              // Texto na parte inferior da tela
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0), // Adicione um espaçamento inferior para separar o texto do rodapé
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {

  final String userName;
  final String email;
  final Function(BuildContext) onSignOut; // Função para realizar o sign out
  final Function(String) launchURL; // Função para lançar URLs

  MyDrawer(this.onSignOut, this.userName, this.email, this.launchURL);

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
            leading: Icon(Icons.text_snippet_outlined),
            title: Text('Glossário sobre\nEducação Financeira'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Glossario(),
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
            leading: Icon(Icons.add_chart_outlined),
            title: Text('Consultar Score'),
            onTap: () {
              launchURL('https://www.serasa.com.br/score/');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add_outlined),
            title: Text('Contatar Orientador Financeiro'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Orientador(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Sobre'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Sobre(),
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
