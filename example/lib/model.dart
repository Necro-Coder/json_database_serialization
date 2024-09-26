import 'package:json_database_serialization/json_database_serialization.dart';

@reflector
class Model extends BaseDao {

  Model();

  Model.db() : super.db();

  Model.all(
      {this.username,
      this.age,
      this.actualPrice,
      this.isAdmin,
      this.password,
      this.email,
      this.status});

  @DataType(type: 'varchar(255)')
  String? username;

  @DataType(type: 'integer')
  int? age;

  @DataType(type: 'decimal(6,2)')
  double? actualPrice;

  @DataType(type: 'bool')
  bool? isAdmin;

  @DataType(type: 'varchar(255)')
  String? password;

  @Unique()
  @Nullable()
  @DataType(type: 'varchar(255)')
  String? email;

  @DataType(type: 'varchar(255)')
  @Default(value: 'active')
  String? status;
}
