
class Story {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String heroImage;
  final String authorId;
  final DateTime publishedAt;
  final List<String> tags;

  Story({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.content,
    required this.heroImage,
    required this.authorId,
    required this.publishedAt,
    this.tags = const [],
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
        content: json['content'] as String,
        heroImage: json['heroImage'] as String,
        authorId: json['authorId'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
        tags: List<String>.from(json['tags'] ?? const []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'content': content,
        'heroImage': heroImage,
        'authorId': authorId,
        'publishedAt': publishedAt.toIso8601String(),
        'tags': tags,
      };

  String excerpt([int length = 140]) {
    if (content.length <= length) return content;
    return '${content.substring(0, length).trim()}…';
  }
}
