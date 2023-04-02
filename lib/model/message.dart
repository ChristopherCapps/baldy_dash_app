class Message {
  final String authorUuid;
  final String text;
  final String? imageUrl;

  Message({required this.authorUuid, required this.text, this.imageUrl});

  Message.fromJson(Map<String, Object?> json)
      : this(
          authorUuid: json['authorUuid']! as String,
          text: json['text']! as String,
          imageUrl: json['imageUrl'] as String,
        );

  Map<String, Object?> toJson() => {
        'authorUuid': authorUuid,
        'text': text,
        'imageUrl': imageUrl,
      };
}
