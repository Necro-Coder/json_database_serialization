import 'package:sqflite_simple_dao_backend/database/params/append.dart';

/* Remember to use the sqflite_simple_dao_backend */
class Parameters {

  Parameters(){
    _constants();
    _dbParameters();
  }

  void _dbParameters(){
    Append.dbParameters(param: 'name', value: 'Test');
    Append.dbParameters(param: 'version', value: 1);

    /* This will be used in case you have to modify the database */
    // Append.dbParameters(param: 'tables', value: Model, update: true);
  }

  void _constants(){
    Append.constant(type: 'varchar', key: '60', value: 'VARCHAR(10)');
    Append.constant(type: 'varchar', key: '60', value: 'VARCHAR(60)', override: true);
  }
}