class DegreesResponseModel {
  final List<DegreeResponseModel>? data;
  final int? count;

  DegreesResponseModel({this.data, this.count});

  factory DegreesResponseModel.fromJson(Map<String, dynamic> json) =>
      DegreesResponseModel(
        data: (json["data"] == null)
            ? []
            : List<DegreeResponseModel>.from(
                json["data"]!.map((x) => DegreeResponseModel.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "count": count,
      };
}

class DegreeResponseModel {
  final int? id;
  final String? name;

  DegreeResponseModel({
    this.id,
    this.name,
  });

  factory DegreeResponseModel.fromJson(Map<String, dynamic> json) =>
      DegreeResponseModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
