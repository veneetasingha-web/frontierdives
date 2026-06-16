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
    tags: ['Kathmandu', 'Culture'],
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
    tags: ['Religion', 'People'],
  ),
];

Author? authorForId(String id) =>
    sampleAuthors.firstWhere((a) => a.id == id, orElse: () => sampleAuthors.first);
