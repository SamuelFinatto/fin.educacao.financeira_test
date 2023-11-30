import 'package:mysql1/mysql1.dart';

class Database {
  late MySqlConnection _connection;

  bool get isConnected => false;

  Future<void> connect() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: '177.44.248.66',
      port: 3306,
      user: 'admin',
      password: 'mysqlapp',
      db: 'moneysense',
    ));
  }

  Future<void> close() async {
    await _connection.close();
  }

  Future<void> fetchSomeData() async {

    var database = Database();

    try {
      await database.connect();

      if (database.isConnected) {
        print('Conexão bem-sucedida!');
        await database.close();
      } else {
        print('Falha ao conectar.');
      }
    } catch (e) {
      print('Erro ao conectar: $e');
    }

    var results = await _connection.query('SELECT * FROM topico');

    if (results.isNotEmpty) {
      for (var row in results) {
        print('ID: ${row[0]}'); // Acessa a primeira coluna, substitua pelo nome da coluna conforme necessário
        print('idOrientador: ${row[1]}'); // Acessa a segunda coluna, substitua pelo nome da coluna conforme necessário
        // Adicione outros acessos às colunas conforme necessário
      }
    } else {
      print('Nenhum resultado retornado da consulta.');
    }
  }
}
