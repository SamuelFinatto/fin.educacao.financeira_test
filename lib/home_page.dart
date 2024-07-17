import 'package:fin.educacao.financeira/configuracoes.dart';
import 'package:fin.educacao.financeira/dicas_financeiras.dart';
import 'package:fin.educacao.financeira/indicacoes.dart';
import 'package:flutter/material.dart';
import 'package:fin.educacao.financeira/doacao.dart';
import 'glossario.dart';
import 'juros_compostos.dart';
import 'metas.dart';
import 'orientadores.dart';
import 'sobre.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/custom_snack_bar.dart';


class HomePage extends StatelessWidget {
  final String userName;
  final String email;
  final Function(BuildContext) signOut; // Modifique o tipo da função para aceitar uma função assíncrona

  const HomePage(this.userName, this.email, this.signOut);

  void _showCustomSnackBar(BuildContext context, String message) {

    bool _isSnackBarVisible = false;

    if (_isSnackBarVisible) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _isSnackBarVisible = false;
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomSnackBar(message: message),
        duration: Duration(milliseconds: 2500),
        behavior: SnackBarBehavior.floating,
        elevation: 6, // Adiciona elevação para garantir espaço suficiente
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    _isSnackBarVisible = true;
  }


  // Função para abrir URLs
  _launchURL(String url) async {
    await launch(url);
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
      body: Padding(
        padding: EdgeInsets.only(right: 2), // Adiciona espaço à direita da tela
        child: Scrollbar(
          thumbVisibility: true, // Define para sempre mostrar a barra de rolagem
          child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Texto na parte superior da tela
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    'Obrigado pelo acesso, $userName!',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 17, // Tamanho da fonte desejado
                      // Outras propriedades de estilo podem ser adicionadas aqui, se necessário
                    ),
                  ),
                ),
                const SizedBox(height: 35), // Espaçamento entre o texto e os botões


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
                            'Dicas Financeiras',
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
                        MaterialPageRoute(builder: (context) => Indicacoes()),
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
                            Icons.add_chart_outlined, // Ícone de pontuação, você pode alterar para o ícone desejado
                            color: Colors.white, // Cor do ícone
                          ),
                          SizedBox(width: 15), // Espaçamento entre o ícone e o texto
                          Text(
                            'Indicações',
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
                      colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (userName == 'usuário Anônimo') {
                        // Exibir o aviso personalizado se o userName for "Usuário Anônimo"
                        _showCustomSnackBar(context, 'Você precisa fazer login com sua conta do Gmail para acessar esta tela.');
                      } else {
                        // Se userName for diferente de "Usuário Anônimo", permitir acesso normalmente
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Metas(email: this.email)
                          ), // Passando o email como argumento
                        );
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 70,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Metas e Investimentos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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
    // Cria um controlador de rolagem dedicado
    final ScrollController _scrollController = ScrollController();

    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            child: UserAccountsDrawerHeader(
              accountName: Text(
                '$userName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text('$email'),
              decoration: BoxDecoration(
                color: Colors.green.shade800,
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _scrollController, // Utiliza o controlador de rolagem aqui
              thumbVisibility: false,
              thickness: 0.0,
              child: SingleChildScrollView(
                controller: _scrollController, // E aqui também
                child: Column(
                  children: <Widget>[
                    _buildListTile(context, Icons.auto_graph, 'Simular juros compostos', JurosCompostos()),
                    _buildListTile(context, Icons.text_snippet_outlined, 'Glossário sobre\nEducação Financeira', Glossario()),
                    _buildListTile(context, Icons.thumb_up_alt_outlined, 'Dicas Financeiras', DicasFinanceiras()),
                    _buildListTile(context, Icons.add_chart_outlined, 'Indicações', Indicacoes()),
                    if (userName != 'usuário Anônimo')
                      _buildListTile(context, Icons.task_alt_outlined, 'Metas e Investimentos', Metas(email: this.email)),
                    _buildListTile(context, Icons.person_add_outlined, 'Contatar Orientador Financeiro', Orientador()),
                    _buildListTile(context, Icons.attach_money_outlined, 'Doação ao projeto', Doacao()),
                    _buildListTile(context, Icons.settings, 'Configurações da conta', Configuracoes(this.onSignOut,userEmail: this.email)),
                    _buildListTile(context, Icons.info_outline, 'Sobre', Sobre())
                  ],
                ),
              ),
            ),
          ),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
      title: Row(
        children: [
          Icon(icon),
          SizedBox(width: 17),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 165),
      child: Material(
        borderRadius: BorderRadius.circular(17),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => onSignOut(context),
          splashColor: Colors.white.withOpacity(0.5),
          highlightColor: Colors.transparent,
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.exit_to_app_outlined, color: Colors.black54),
                  SizedBox(width: 17),
                  Text(
                    'Sair',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
