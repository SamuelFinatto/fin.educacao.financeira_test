import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;

class Database {
  late MySqlConnection _connection;

  String ip = '';
  int porta = 0;
  String schema = '';
  String senha = '';
  String usuario = '';

  Future<bool> loadEnvFile() async {
    try {
      String envContents = await rootBundle.loadString('.env');
      return true; // Arquivo carregado com sucesso
    } catch (e) {
      print("Erro ao carregar o arquivo .env: $e");
      return false; // Erro ao carregar o arquivo
    }
  }

  Future<void> connect() async {
    bool envLoaded = await loadEnvFile();
    if (!envLoaded) {
      print('Erro ao carregar o arquivo .env. Conexão abortada.');
      return; // Aborta a tentativa de conexão se o arquivo não for carregado corretamente
    }

    await dotenv.load(fileName: '.env');

    ip = dotenv.env['IP_BD_MYSQL']!;
    porta = int.parse(dotenv.env['PORTA_BD_MYSQL']!);
    schema = dotenv.env['SCHEMA_BD_MYSQL']!;
    senha = dotenv.env['SENHA_BD_MYSQL']!;
    usuario = dotenv.env['USUARIO_BD_MYSQL']!;

    try {
      _connection = await MySqlConnection.connect(ConnectionSettings(
        host: ip,
        port: porta,
        user: usuario,
        password: senha,
        db: schema,
      ));
      if (await _connection != null) {
        print('Conexão bem-sucedida!');
      } else {
        print('Erro: Falha ao estabelecer a conexão.');
      }
    } catch (e) {
      print('Falha ao conectar: $e');
    }
  }

  Future<void> close() async {
    await _connection.close();
  }

  Future<List<ResultRow>> buscarDadosDosConteudos() async {

    //var database = Database();
    //await database.connect();

    await connect(); // Utilize o método connect() da instância atual

    var results = await _connection.query('SELECT * FROM topico');

    print('Número de linhas retornadas: ${results.length}');

    if (results.isNotEmpty) {
      for (var row in results) {
        print('ID: ${row[0]}'); // Acessa a primeira coluna, substitua pelo nome da coluna conforme necessário
        print('idOrientador: ${row[1]}'); // Acessa a segunda coluna, substitua pelo nome da coluna conforme necessário
        // Adicione outros acessos às colunas conforme necessário
      }
    } else {
      print('Nenhum resultado retornado da consulta.');
    }
    return results.toList();
  }
}
