import 'package:flutter/foundation.dart';

///
/// author : ciih
/// date : 2019-08-27 15:18
/// description : 
///
class RegisterTypeSelectorProvider extends ChangeNotifier{
  TypeData _currentSelect;

  TypeData get currentSelect => _currentSelect;
  static const List<TypeData> typeMap = [
    const TypeData(1, "学校保安"),
    const TypeData(2, "民警"),
  ];
  set currentSelect(TypeData value) {
    _currentSelect = value;
    notifyListeners();
  }

}

class TypeData{
  final int type;
  final String info;

  const TypeData(this.type, this.info);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TypeData &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              info == other.info;
  @override
  int get hashCode =>
      type.hashCode ^
      info.hashCode;




}