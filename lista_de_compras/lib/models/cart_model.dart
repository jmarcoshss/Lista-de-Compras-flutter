
class CartModel {
  int _id = 0;
  String _name = '';
  String _description = '';
  CartModel(
    this._id,
    this._name,
    this._description,
  );

  int get id => _id;
  String get name => _name;
  String get description => _description;

  set id(int id) {
    _id = id;
  }
  set name(String name){
    _name = name;
  }
  set description(String description){
    _description = description;
  }
}
