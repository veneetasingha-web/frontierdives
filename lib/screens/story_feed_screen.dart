import 'package:flutter/material.dart';
import 'package:frontierdives/data/sample_data.dart';
import 'package:frontierdives/models/story.dart';
import 'package:frontierdives/services/firestore_service.dart';
import 'package:frontierdives/screens/story_detail_screen.dart';

class StoryFeedScreen extends StatefulWidget {
  const StoryFeedScreen({super.key});

  @override
  State<StoryFeedScreen> createState() => _StoryFeedScreenState();
}

class _StoryFeedScreenState extends State<StoryFeedScreen> {
  static const _themes = [
    'All',
    'Culture',
    'Politics',
    'Tech',
    'Climate',
    'Urban Life',
  ];

  String _selectedTheme = 'All';
  int _visibleCount = 6;

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Feed'),
        actions: [
          TextButton(
            onPressed: () => setState(() => _visibleCount += 6),
            child: const Text('View all'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: StreamBuilder<List<Story>>(
        stream: service.storiesStream(),
        builder: (context, snapshot) {
          final stories = _mergeStories(snapshot.data ?? sampleStories);
          final filteredStories = _applyThemeFilter(stories);
          final visibleStories = filteredStories.take(_visibleCount).toList();
          final hasMore = filteredStories.length > _visibleCount;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(
                'Real-time stories from Firestore',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Filter by theme and follow human-verified dispatches as they land.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final theme in _themes)
                    ChoiceChip(
                      label: Text(theme),
                      selected: _selectedTheme == theme,
                      onSelected: (_) {
                        setState(() {
                          _selectedTheme = theme;
                          _visibleCount = 6;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 18),
              if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filteredStories.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      'No stories match this theme yet.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (final story in visibleStories) ...[
                      _FeedStoryCard(
                        story: story,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoryDetailScreen(story: story),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              if (hasMore)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _visibleCount += 6),
                      icon: const Icon(Icons.view_agenda_outlined),
                      label: const Text('View all'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Story> _applyThemeFilter(List<Story> stories) {
    if (_selectedTheme == 'All') {
      return stories;
    }

    return stories.where((story) {
      return story.tags.any(
        (tag) => tag.toLowerCase() == _selectedTheme.toLowerCase(),
      );
    }).toList();
  }

  List<Story> _mergeStories(List<Story> stories) {
    final merged = <String, Story>{};
    for (final story in [...stories, ...sampleStories]) {
      merged[story.id] = story;
    }
    final result = merged.values.toList();
    result.sort((left, right) => right.publishedAt.compareTo(left.publishedAt));
    return result;
  }
}

class _FeedStoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const _FeedStoryCard({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeLabel = story.tags.firstWhere(
      (tag) => const ['Culture', 'Politics', 'Tech', 'Climate', 'Urban Life']
          .map((value) => value.toLowerCase())
          .contains(tag.toLowerCase()),
      orElse: () => story.tags.isNotEmpty ? story.tags.first : 'Story',
    );

    final byline = story.byline.isNotEmpty
        ? story.byline
        : story.authorId.isNotEmpty
            ? 'By ${story.authorId}'
            : 'By Frontier Dives';

    return Material(
      color: Colors.white.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      themeLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  _VerificationBadge(verified: story.verified),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                story.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      height: 1.14,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                byline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78),
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(story.publishedAt),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  final bool verified;

  const _VerificationBadge({required this.verified});

  @override
  Widget build(BuildContext context) {
    final color = verified ? const Color(0xFF15803D) : const Color(0xFFB42318);
    final background = verified ? const Color(0xFFE7F6EC) : const Color(0xFFFDECEC);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        verified ? 'Human-verified' : 'Needs review',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
            ),
      ),
    );
  }
}

String _formatDate(DateTime publishedAt) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${monthNames[publishedAt.month - 1]} ${publishedAt.day}, ${publishedAt.year}';
}
