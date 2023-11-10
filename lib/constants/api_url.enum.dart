enum ApiUrl {
  checkToken(
    path: "user/check",
  ),
  chunk(
    path: "chunk",
  ),
  local(
    path: "local",
  ),
  localList(
    path: "local/list",
  ),
  pieceOfClothingType(
    path: "type",
  ),
  pieceOfClothingTypeList(
    path: "type/list",
  ),
  pieceOfClothing(
    path: "piece_of_clothing",
  ),
  pieceOfClothingList(
    path: "piece_of_clothing/list",
  ),
  signIn(
    path: "user/sign_in",
  ),
  uses(
    path: "use/list",
  ),
  incrementUse(
    path: "use/increment",
  ),
  decrementUse(
    path: "use/decrement",
  ),
  typeUse(
    path: "type_use",
  );

  final String path;

  const ApiUrl({
    required this.path,
  });
}
