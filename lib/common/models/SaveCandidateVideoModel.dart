class SaveCandidateVideoModel {
  final String codeAdd;
  final String linkGroup;
  final String idCaller;
  final String nameCaller;
  final String idListCallee;

  SaveCandidateVideoModel({
    required this.codeAdd,
    required this.linkGroup,
    required this.idCaller,
    required this.nameCaller,
    required this.idListCallee,
  });

  factory SaveCandidateVideoModel.fromMap(
      Map<String, dynamic> map) {
    return SaveCandidateVideoModel(
      codeAdd: map['codeAccess'],
      linkGroup: map['linkGroup'],
      idCaller: map['caller'],
      nameCaller: map['userCaller'],
      idListCallee: map['listUser'],
    );
  }
}
