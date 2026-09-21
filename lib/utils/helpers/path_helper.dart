enum ImageType { png, jpg, svg }

String setImagePath(String name, ImageType imageType) {
  return "assets/images/$name.${imageType.name}";
}

String setIconPath(String name, ImageType imageType) {
  return "assets/icons/$name.${imageType.name}";
}

String setJsonPath(String name) {
  return "assets/jsonfile/$name.json";
}

String setLottiePath(String name) {
  return "assets/lotties/$name.json";
}
