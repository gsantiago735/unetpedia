class PagesModel {
  final int? next;
  final int? previous;

  PagesModel({this.next, this.previous});

  factory PagesModel.fromJson(Map<String, dynamic> json) => PagesModel(
        next: json["next"],
        previous: json["previous"],
      );
}
