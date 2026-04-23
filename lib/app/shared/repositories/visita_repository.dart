import 'package:sqflite/sqflite.dart';
import 'package:crm_app/app/shared/database/sqlite_helper.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';

class VisitaRepository {
  Future<void> salvarVisita(VisitaEntity visita) async {
    try{
      //pega o BD aberto no helper
      final db = await SqliteHelper.instance.database;

      //manda swlite inserir o tomap para convertar a classe
      await db.insert(
        'visitas',
        visita.toMap(),
        //se ja tiver uma visita com o mesmo id ele substirui
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("Visita salva no SQLite");
    }catch (e) {
      print("Erro ao salvar no sqlite: $e");
      throw Exception("Não foi possivel salvar localmente");
    }
  }

  //biscar do banco (select)
  Future<List<VisitaEntity>> buscarVisitas() async {
    try {
      final db = await SqliteHelper.instance.database;

      //select from visitas
      final List<Map<String, dynamic>> resultado = await db.query('visitas');

      return resultado.map((map) => VisitaEntity.fromMap(map)).toList();
    }catch (e) {
      print("erro ao buscar visitas no banco: $e");
      return [];
    }
  }
}