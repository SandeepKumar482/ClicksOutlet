List<String> getStringList({required dynamic list}) {
  List<String> stringList = [];

  if(list is List) {
    list.forEach((data) {
      stringList.add(data.toString());
    });
  }

  return stringList;
}