class RecviceListMemberCallGroupPSDataModel {
  final String codeAdd;
  final String linkGroup;
  final String idCaller;
  final String nameCaller;
  final List<String> idListCallee;

  RecviceListMemberCallGroupPSDataModel({
    required this.codeAdd,
    required this.linkGroup,
    required this.idCaller,
    required this.nameCaller,
    required this.idListCallee,
  });

  factory RecviceListMemberCallGroupPSDataModel.fromMap(
      Map<String, dynamic> map) {
    return RecviceListMemberCallGroupPSDataModel(
      codeAdd: map['codeAccess'],
      linkGroup: map['linkGroup'],
      idCaller: map['caller'],
      nameCaller: map['userCaller'],
      idListCallee: map['listUser'] == null ? [] : List<String>.from(map['listUser'].map((e)=> e)),
    );
  }
}
