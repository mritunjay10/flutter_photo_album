
class User{

  String _id;
  String _user;
  String _userName;
  String _phoneNumber;
  String _address;
  String _password;
  String _isActive;
  String _createdAt;
  String _updatedAt;

  User({
        String id,
        String user,
        String userName,
        String phoneNumber,
        String address,
        String password,
        String isActive,
        String createdAt,
        String updatedAt}) {
    this._id = id;
    this._user = user;
    this._userName = userName;
    this._phoneNumber = phoneNumber;
    this._address = address;
    this._password = password;
    this._isActive = isActive;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get user => _user;
  set user(String user) => _user = user;
  String get userName => _userName;
  set userName(String userName) => _userName = userName;
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;
  String get address => _address;
  set address(String address) => _address = address;
  String get password => _password;
  set password(String password) => _password = password;
  String get isActive => _isActive;
  set isActive(String isActive) => _isActive = isActive;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _user = json['user'];
    _userName = json['user_name'];
    _phoneNumber = json['phone_number'];
    _address = json['address'];
    _password = json['password'];
    _isActive = json['is_active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user'] = this._user;
    data['user_name'] = this._userName;
    data['phone_number'] = this._phoneNumber;
    data['address'] = this._address;
    data['password'] = this._password;
    data['is_active'] = this._isActive;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }

}