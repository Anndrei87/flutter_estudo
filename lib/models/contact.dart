class Contact {
  final int? id;
  final String name;
  final int accountNumber;

  Contact(this.name,
      this.accountNumber,
      this.id,);

  @override
  String toString() {
    return 'Contact{ id:$id, name: $name, account: $accountNumber}';
  }

  Contact.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        accountNumber = json['accountNumber'];


  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'name': name,
        'accountNumber': accountNumber,
      };
}