class ListingOffer {
  int listings;
  int unitPrice;
  int quantity;

  ListingOffer({this.listings, this.unitPrice, this.quantity});

  ListingOffer.fromJson(Map<String, dynamic> json) {
    listings = json['listings'];
    unitPrice = json['unit_price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listings'] = this.listings;
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    return data;
  }
}