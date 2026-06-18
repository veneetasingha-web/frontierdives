
class Story {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String heroImage;
  final String authorId;
  final DateTime publishedAt;
  final List<String> tags;
  final String byline;
  final bool verified;
  final String collaborationCredit;
  final List<String> photoEssayUrls;
  final String? audioUrl;
  final String? videoUrl;
  final String securityStatus;
  final String securityNote;

  Story({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.content,
    required this.heroImage,
    required this.authorId,
    required this.publishedAt,
    this.tags = const [],
    this.byline = '',
    this.verified = true,
    this.collaborationCredit = 'Written with Claude / Gemini',
    this.photoEssayUrls = const [],
    this.audioUrl,
    this.videoUrl,
    this.securityStatus = 'Verified Secure',
    this.securityNote = '',
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
        byline: json['byline'] as String? ?? '',
        verified: json['verified'] as bool? ?? true,
        collaborationCredit: json['collaborationCredit'] as String? ?? 'Written with Claude / Gemini',
        photoEssayUrls: List<String>.from(json['photoEssayUrls'] ?? const []),
        audioUrl: json['audioUrl'] as String?,
        videoUrl: json['videoUrl'] as String?,
        securityStatus: json['securityStatus'] as String? ?? 'Verified Secure',
        securityNote: json['securityNote'] as String? ?? '',
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
        'byline': byline,
        'verified': verified,
        'collaborationCredit': collaborationCredit,
        'photoEssayUrls': photoEssayUrls,
        'audioUrl': audioUrl,
        'videoUrl': videoUrl,
        'securityStatus': securityStatus,
        'securityNote': securityNote,
      };

  Story copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? content,
    String? heroImage,
    String? authorId,
    DateTime? publishedAt,
    List<String>? tags,
    String? byline,
    bool? verified,
    String? collaborationCredit,
    List<String>? photoEssayUrls,
    String? audioUrl,
    String? videoUrl,
    String? securityStatus,
    String? securityNote,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      heroImage: heroImage ?? this.heroImage,
      authorId: authorId ?? this.authorId,
      publishedAt: publishedAt ?? this.publishedAt,
      tags: tags ?? this.tags,
      byline: byline ?? this.byline,
      verified: verified ?? this.verified,
      collaborationCredit: collaborationCredit ?? this.collaborationCredit,
      photoEssayUrls: photoEssayUrls ?? this.photoEssayUrls,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      securityStatus: securityStatus ?? this.securityStatus,
      securityNote: securityNote ?? this.securityNote,
    );
  }

  String excerpt([int length = 140]) {
    if (content.length <= length) return content;
    return '${content.substring(0, length).trim()}…';
  }
}
