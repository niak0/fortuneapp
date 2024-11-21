enum RelationshipStatus {
  single("Bekar"),
  inRelationship("İlişkisi var"),
  married("Evli"),
  divorced("Boşanmış"),
  complicated("Karışık");

  final String turkishName;
  const RelationshipStatus(this.turkishName);
}
