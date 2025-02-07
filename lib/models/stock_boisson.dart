import 'package:isar/isar.dart';
import 'boisson.dart';

part 'stock_boisson.g.dart';

@Collection()
class StockBoisson {
  Id id = Isar.autoIncrement;

  final IsarLink<Boisson> boisson = IsarLink();
  int quantite = 0;

  StockBoisson();
}
