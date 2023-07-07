enum ModelsEnum {
  local(
    name: "local",
  ),
  pieceOfClothingType(
    name: "pieceOfClothingType",
  ),
  pieceOfClothing(
    name: "pieceOfClothing",
  ),
  typeUse(
    name: "typeUse",
  );

  final String name;

  const ModelsEnum({
    required this.name,
  });
}
