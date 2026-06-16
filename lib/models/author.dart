class Author {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;
  final bool verified;

  Author({
    required this.id,
    required this.name,
    this.bio = '',
    this.avatarUrl = '',
    this.verified = false,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json['id'] as String,
        name: json['name'] as String,
        bio: json['bio'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
        verified: json['verified'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bio': bio,
        'avatarUrl': avatarUrl,
        'verified': verified,
      };
}
