/// 0: [logout]
/// 
/// 1: [disconect]
enum UnauthType {
  logout,
  disconnect,
}

extension UnauthTypeExt on UnauthType {
  static fromId(int id) => UnauthType.values[id];
}
