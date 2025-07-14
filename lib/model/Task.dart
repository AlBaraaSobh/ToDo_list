class Task {
  int? id;

  late String title;
  late String Details;
  int status = 0; //0-task Uncomplete // 1-task Complete
  Task({required this.title, required this.Details});


  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['status'] = status;
    map['Details'] = Details;
    return map;
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];

    status = json['status'];
    Details = json['Details'];
  }

}
