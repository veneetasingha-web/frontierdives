import 'package:frontierdives/models/author.dart';
import 'package:frontierdives/models/story.dart';

final sampleAuthors = <Author>[
  Author(
    id: 'nimjn',
    name: 'NIMJN',
    bio: 'Editorial lead and field reporter in Kathmandu.',
    avatarUrl:
        'https://images.unsplash.com/photo-1531123414780-f0b0f3a0b5a6?w=400&h=400&fit=crop',
    verified: true,
  ),
  Author(
    id: 'writer1',
    name: 'Asha Mahato',
    bio: 'Contributor covering culture and food.',
    avatarUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop',
  ),
];

final sampleStories = <Story>[
  Story(
    id: 'kath-1',
    title: 'Streets of Kathmandu: A Morning Walk',
    subtitle: 'Markets, prayers, and dawn light',
    content:
        'Kathmandu wakes slowly. The scent of incense drifts across narrow alleys as shopkeepers sweep their thresholds. This piece follows a morning walk through markets and temples, listening to the city wake up.',
    heroImage:
        'https://images.unsplash.com/photo-1504198453319-5ce911bafcde?w=1200&h=600&fit=crop',
    authorId: 'nimjn',
    publishedAt: DateTime(2026, 6, 1),
    tags: ['Culture', 'Urban Life'],
    byline: 'NIMJN, Kathmandu desk',
    photoEssayUrls: [
      'https://images.unsplash.com/photo-1504198453319-5ce911bafcde?w=900&h=700&fit=crop',
      'https://images.unsplash.com/photo-1524492514796-2d3b8f0f5f68?w=900&h=700&fit=crop',
    ],
  ),
  Story(
    id: 'kath-2',
    title: 'Rivers and Rituals',
    subtitle: 'Life along the Bagmati',
    content:
        'Along the Bagmati river, communities gather for ritual and rest. This story explores how water shapes everyday life in Kathmandu.',
    heroImage:
        'https://images.unsplash.com/photo-1531974060506-7f7b8d1d0c5a?w=1200&h=600&fit=crop',
    authorId: 'writer1',
    publishedAt: DateTime(2026, 5, 20),
    tags: ['Climate', 'Urban Life'],
    byline: 'Asha Mahato, field contributor',
    verified: true,
  ),
  Story(
    id: 'kath-3',
    title: 'Municipal Promises, Street-Level Reality',
    subtitle: 'Politics at the ward office',
    content:
        'A closer look at how local policy announcements meet the realities of neighborhoods, traders, and daily commuters.',
    heroImage:
        'https://images.unsplash.com/photo-1488747279002-c8523379faaa?w=1200&h=600&fit=crop',
    authorId: 'nimjn',
    publishedAt: DateTime(2026, 5, 12),
    tags: ['Politics', 'Governance'],
    byline: 'NIMJN, politics desk',
  ),
  Story(
    id: 'kath-4',
    title: 'The New Computing Class in Patan',
    subtitle: 'Startups, code, and quiet ambition',
    content:
        'In Patan, a generation of builders is turning rooftop rooms into launchpads for software, services, and small AI experiments.',
    heroImage:
        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200&h=600&fit=crop',
    authorId: 'writer1',
    publishedAt: DateTime(2026, 4, 28),
    tags: ['Tech', 'Startups'],
    byline: 'Asha Mahato, technology contributor',
    audioUrl: 'https://example.com/audio/patan-tech-talk.mp3',
  ),
  Story(
    id: 'kath-5',
    title: 'Food, Memory, and the City Table',
    subtitle: 'A culture dispatch from the old lanes',
    content:
        'Kitchen rituals, shared recipes, and the stories that travel between generations shape this cultural portrait of the city.',
    heroImage:
        'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=1200&h=600&fit=crop',
    authorId: 'writer1',
    publishedAt: DateTime(2026, 4, 18),
    tags: ['Culture', 'Urban Life'],
    byline: 'Asha Mahato, culture desk',
    videoUrl: 'https://example.com/video/city-table.mp4',
  ),
  Story(
    id: 'kath-6',
    title: 'What AI Means for Nepali Language Publishing',
    subtitle: 'Translation, tooling, and newsroom trust',
    content:
        'Editors, translators, and technologists are figuring out how to use AI without flattening the nuance of Nepali language reporting.',
    heroImage:
        'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=1200&h=600&fit=crop',
    authorId: 'nimjn',
    publishedAt: DateTime(2026, 4, 5),
    tags: ['Tech', 'Politics'],
    byline: 'NIMJN, AI and media desk',
    verified: true,
    securityStatus: 'Verified Secure',
  ),
];

Author? authorForId(String id) =>
    sampleAuthors.firstWhere((a) => a.id == id, orElse: () => sampleAuthors.first);
