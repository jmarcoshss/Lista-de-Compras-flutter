
import 'package:lista_de_compras/database/app_database.dart';
import 'package:lista_de_compras/models/cart_model.dart';

class CartRepository {
  Future<List<CartModel>> getCartDatabase() async {
    List<CartModel> cartlist = [];
    var db = await ListaDeComprasDataBase().getDatabase();
    var result = await db.rawQuery('SELECT id, name, description FROM cartlist');
    for (var element in result) {
      cartlist.add(
        CartModel(
          int.parse(element['id'].toString()),
          element['name'].toString(),
          element['description'].toString(),
          
          
        ),
      );
    }
    return cartlist;
  }

  Future<void> save(CartModel cart) async {
    var db = await ListaDeComprasDataBase().getDatabase();
    await db.rawInsert(
        'INSERT INTO cartlist(name, description) values(?,?)',
        [cart.name, cart.description]);
  }
  Future<void> remove(int id) async {
    var db = await ListaDeComprasDataBase().getDatabase();
    await db.rawInsert(
        'DELETE FROM cartlist WHERE id = ?',
        [id]);
  }
  
  Future<void> update(CartModel cartModel) async {
    var db = await ListaDeComprasDataBase().getDatabase();
    await db.rawInsert(
        'UPDATE cartlist SET name = ?, description = ? WHERE id = ?', [
      cartModel.name,
      cartModel.description,
      cartModel.id
    ]);}
}