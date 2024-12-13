class BitrateModel {
  int index;
  int width;
  int height;
  int bitrate;

  // Constructor
  BitrateModel({
    required this.index,
    required this.width,
    required this.height,
    required this.bitrate,
  });

  // fromJson method to create a BitrateModel from a JSON map
  factory BitrateModel.fromJson(Map<String, dynamic> json) {
    return BitrateModel(
      index: json['index'],
      width: json['width'],
      height: json['height'],
      bitrate: json['bitrate'],
    );
  }

  // copyWith method to create a copy of BitrateModel with optional modifications
  BitrateModel copyWith({
    int? index,
    int? width,
    int? height,
    int? bitrate,
  }) {
    return BitrateModel(
      index: index ?? this.index,
      width: width ?? this.width,
      height: height ?? this.height,
      bitrate: bitrate ?? this.bitrate,
    );
  }

  // Optional: toJson method to convert BitrateModel to a JSON map (if you need it)
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'width': width,
      'height': height,
      'bitrate': bitrate,
    };
  }
}