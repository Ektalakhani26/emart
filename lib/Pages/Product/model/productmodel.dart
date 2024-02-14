class ProductModel{

  var Description;
  var Name;
  var Price;
  var Discount;
  var image;

  ProductModel(
  {this.Description, this.Name, this.Price, this.Discount, this.image});


  ProductModel.fromJson(dynamic json) {
    Description = json['Description'];
    Name = json['Name'];
    Price = json['Price'];
    Discount = json['Discount'];
    image = json['image'];
  }

  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      //id: id,
      Description: data['Description'] ?? '',
      Name: (data['Name'] ?? 0),
      Price: (data['Price'] ?? 0),
        Discount: data['Discount'] ?? '',
        image: data['image'] ?? ''
    );
  }
}