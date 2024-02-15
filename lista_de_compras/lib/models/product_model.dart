class ProductModel {
  int _id = 0;
  int _listid = 0;
  String _name = '';
  double _price = 0.0;
  String _unity = '';
  double _amount = 0.0;
  bool _checked ;
  ProductModel(
    this._id,
    this._listid,
    this._name,
    this._price,
    this._unity,
    this._amount,
    this._checked,
  );

  int get id => _id;
  int get listid => _listid;
  String get name => _name;
  double get price => _price;
  String get unity => _unity;
  double get amount => _amount;
  bool get checked =>_checked;

  set id (int id){
    _id = id;
  } 
  set listid (int listid){
    _listid = listid;
  }
  set name (String name){
    _name = name;
  }
  set price(double price){
    _price = price;
  }
  set unity (String unity){
    _unity = unity;
  }
  set amount (double amount){
    _amount = amount;
  }
  set checked (bool checked){
    _checked = checked;
  }

}
