import 'package:fin.educacao.financeira/dicas_financeiras.dart';
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DicasFinanceiras()),
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
                          Icons.thumb_up_alt_outlined, // Ícone de snippet de texto
                          color: Colors.white, // Cor do ícone
                        ),
                        SizedBox(width: 15), // Espaçamento entre o ícone e o texto
                        Text(
                          textAlign: TextAlign.center,
                          'Dicas de\nEducação Financeira',
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
          SizedBox(
            height: 120, // Define a altura desejada para o UserAccountsDrawerHeader
            child: UserAccountsDrawerHeader(
              accountName: Text(
                '$userName',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Define o estilo para negrito
                  fontSize: 16, // Define o tamanho da fonte para 16
                ),
              ),
              accountEmail: Text('$email'),
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: AssetImage('assets/images/perfil_transparente_com_sombra.png'),
              // ),
              decoration: BoxDecoration(
                color: Colors.green.shade800, // Define a cor de fundo como azul
              ),
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JurosCompostos(),
                ),
              );
            },
            title: Row(
              children: [
                Icon(Icons.auto_graph),
                SizedBox(width: 17), // Espaço entre o ícone e o texto
                Text('Simular juros compostos'),
              ],
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Glossario(),
                ),
              );
            },
            title: Row(
              children: [
                Icon(Icons.text_snippet_outlined),
                SizedBox(width: 17), // Espaço entre o ícone e o texto
                Text('Glossário sobre\nEducação Financeira'),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Doacao(),
                ),
              );
            },
            title: Row(
              children: [
                Icon(Icons.attach_money_outlined),
                SizedBox(width: 17), // Espaço entre o ícone e o texto
                Text('Doação ao projeto'),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              launchURL('https://www.serasa.com.br/score/');
            },
            title: Row(
              children: [
                Icon(Icons.add_chart_outlined),
                SizedBox(width: 17), // Espaço entre o ícone e o texto
                Text('Consultar Score'),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Orientador(),
                ),
              );
            },
            title: Row(
              children: [
                Icon(Icons.person_add_outlined),
                SizedBox(width: 17), // Espaço entre o ícone e o texto
                Text('Contatar Orientador Financeiro'),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Sobre(),
                ),
              );
            },
            title: Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 17), // Espaço entre o ícone e o texto
                Text('Sobre'),
              ],
            ),
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
              padding: EdgeInsets.only(bottom: 30, left: 10, right: 165), // Adicionando padding nos lados esquerdo e direito
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                  color: Colors.transparent, // Torna o Material transparente para permitir o gradiente de fundo
                  child: InkWell(
                    borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                    onTap: () {
                      onSignOut(context); // Chame a função de sign out
                    },
                    splashColor: Colors.white.withOpacity(0.5), // Define a cor do efeito de toque
                    highlightColor: Colors.transparent, // Define a cor de destaque como transparente para remover a cor padrão
                    child: Container(
                      width: 200, // Defina a largura desejada para o botão
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)], // Cores do gradiente
                          begin: Alignment.centerLeft, // Início do gradiente à esquerda
                          end: Alignment.centerRight, // Fim do gradiente à direita
                        ),
                        borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4), // Cor da sombra
                            spreadRadius: 2, // Espalhamento da sombra
                            blurRadius: 5, // Desfoque da sombra
                            offset: Offset(0, 0), // Deslocamento da sombra
                          ),
                        ],
                      ),
                      child: Material(
                        type: MaterialType.transparency, // Torna o Material transparente
                        borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                        child: InkWell(
                          onTap: () {
                            onSignOut(context); // Chame a função de sign out
                          },
                          borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25), // Adicione um padding horizontal
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.exit_to_app_outlined,
                                    color: Colors.black54), // Cor do ícone, // Ícone "Sair"
                                SizedBox(width: 17), // Espaço entre o ícone e o texto
                                Text(
                                  'Sair', // Texto "Sair"
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87, // Define a cor do texto como branco
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),



        ],
      ),
    );
  }
}
