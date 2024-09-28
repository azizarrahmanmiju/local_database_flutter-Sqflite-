

class Contact {
   int id;
  final String name ;
  final String phone;

  Contact({required this.id, required this.name, required this.phone});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

}