class ContactModel {
    ContactModel({
        required this.name,
        required this.number,
        required this.profile,
        required this.id,
    });

    String name;
    String number;
    String profile;
    String id;

    factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        name: json["name"],
        number: json["number"],
        profile: json["profile"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "profile": profile,
        "id": id,
    };
}