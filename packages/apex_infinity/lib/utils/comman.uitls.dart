List<String> getStringList({required dynamic list}) {
  List<String> stringList = [];

  if(list is List) {
    for (var data in list) {
      stringList.add(data.toString());
    }
  }

  return stringList;
}