class EventItemResponseDto {
  final String barcode;
  final String itemName;
  final int itemPrice;
  final String event;

  EventItemResponseDto({
    required this.barcode,
    required this.itemName,
    required this.itemPrice,
    required this.event,
  });

  factory EventItemResponseDto.fromJson(Map<String, dynamic> json) {
    return EventItemResponseDto(
      barcode: json['barcode'],
      itemName: json['itemName'],
      itemPrice: json['itemPrice'],
      event: json['event'],
    );
  }
}
