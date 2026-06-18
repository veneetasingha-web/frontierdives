import 'package:flutter/material.dart';
import 'package:frontierdives/models/story.dart';
import 'package:frontierdives/data/sample_data.dart';
import 'package:frontierdives/services/firestore_service.dart';
import 'package:frontierdives/widgets/story_card.dart';

class HomeScreen extends StatelessWidget {
  final Stream<List<Story>>? storiesStream;

  const HomeScreen({super.key, this.storiesStream});

  @override
  Widget build(BuildContext context) {
    final feedStream = storiesStream ?? FirestoreService().storiesStream();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const _MastheadWordmark(),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Writer Login'),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text('Join Now'),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Story>>(
        stream: feedStream,
        builder: (context, snapshot) {
          final hasError = snapshot.hasError;
          final isLoading = snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData;
          final stories = _featuredStories(snapshot.data ?? sampleStories);
          final latestStories = (snapshot.data?.isNotEmpty == true ? snapshot.data! : sampleStories)
              .take(5)
              .toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: _sectionPadding(context).copyWith(bottom: 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading)
                        _PillBanner(
                          label: 'Syncing the latest dives from the feed',
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                        ),
                      if (hasError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PillBanner(
                            label: 'Feed unavailable, showing editorial fallback stories',
                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
                          ),
                        ),
                      _MastheadPanel(
                        accentLabel: 'FRONTIER DIVES / फ्रन्टियर डाइभ्स',
                        title: 'Human-Verified Stories from Kathmandu\'s AI Frontier',
                        description:
                            'Minimalist reporting, bilingual framing, and a steady editorial hand for the city\'s AI era.',
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: _sectionPadding(context).copyWith(top: 6),
                sliver: SliverToBoxAdapter(
                  child: _HeroFeature(
                    imageUrl: stories.first.heroImage,
                    eyebrow: 'Editorial signal',
                    title: 'Human-Verified Stories from Kathmandu\'s AI Frontier',
                    description:
                        'A bilingual editorial surface where culture, politics, and technology stories are checked, framed, and shipped with care.',
                    primaryAction: 'Join Now',
                    secondaryAction: 'Subscribe',
                  ),
                ),
              ),
              SliverPadding(
                padding: _sectionPadding(context).copyWith(top: 8, bottom: 4),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Frontier Dives (Upcoming)',
                    subtitle: 'Six featured stories arranged as a two-row editorial grid.',
                  ),
                ),
              ),
              SliverPadding(
                padding: _sectionPadding(context).copyWith(top: 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => StoryCard(story: stories[index]),
                    childCount: stories.length,
                  ),
                ),
              ),
              SliverPadding(
                padding: _sectionPadding(context).copyWith(top: 28, bottom: 4),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Latest Dives',
                    subtitle: 'REST/API feed panel for the newest dispatches and daily updates.',
                  ),
                ),
              ),
              SliverPadding(
                padding: _sectionPadding(context).copyWith(top: 0),
                sliver: SliverToBoxAdapter(
                  child: _LatestDivesPanel(stories: latestStories),
                ),
              ),
              SliverPadding(
                padding: _sectionPadding(context).copyWith(top: 28, bottom: 24),
                sliver: SliverToBoxAdapter(
                  child: _NewsletterSection(
                    title: 'Stay Inspired',
                    subtitle: 'Subscribe for weekly briefs, notes from the field, and bilingual story drops.',
                  ),
                ),
              ),
              SliverPadding(
                padding: _sectionPadding(context).copyWith(bottom: 24),
                sliver: const SliverToBoxAdapter(child: _FooterCredit()),
              ),
            ],
          );
        },
      ),
    );
  }

  EdgeInsets _sectionPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1200
        ? 72.0
        : width >= 840
            ? 40.0
            : 20.0;
    return EdgeInsets.symmetric(horizontal: horizontal);
  }

  List<Story> _featuredStories(List<Story> stories) {
    final merged = <String, Story>{};
    for (final story in [...stories, ...sampleStories]) {
      merged[story.id] = story;
    }
    return merged.values.toList()
      ..sort((left, right) => right.publishedAt.compareTo(left.publishedAt));
  }
}

class _MastheadWordmark extends StatelessWidget {
  const _MastheadWordmark();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'FRONTIER DIVES',
          style: textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          'फ्रन्टियर डाइभ्स',
          style: textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _PillBanner extends StatelessWidget {
  final String label;
  final Color color;

  const _PillBanner({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}

class _MastheadPanel extends StatelessWidget {
  final String accentLabel;
  final String title;
  final String description;

  const _MastheadPanel({
    required this.accentLabel,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PillBanner(
            label: accentLabel,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 680 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: isWide ? 38 : 30,
                            height: 1.05,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          ),
                          child: const Text('Join Now'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.onSurface,
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          ),
                          child: const Text('Subscribe'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isWide ? 240 : double.infinity,
                child: const _EditorialAccent(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditorialAccent extends StatelessWidget {
  const _EditorialAccent();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3FAF2),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.28)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 18,
              child: _AccentDot(color: Theme.of(context).colorScheme.primary, size: 22),
            ),
            Positioned(
              top: 34,
              right: 24,
              child: Transform.rotate(
                angle: 0.35,
                child: _PuzzleTile(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Positioned(
              bottom: 18,
              left: 26,
              child: Transform.rotate(
                angle: -0.3,
                child: _PuzzleTile(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.72)),
              ),
            ),
            Positioned(
              bottom: 26,
              right: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  'AI + EDITORIAL',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 114,
                height: 114,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.9),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16)),
                ),
                child: Icon(
                  Icons.extension_outlined,
                  size: 58,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Positioned(
              top: 66,
              left: 92,
              right: 86,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccentDot extends StatelessWidget {
  final Color color;
  final double size;

  const _AccentDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  final Color color;

  const _PuzzleTile({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Center(
        child: Icon(Icons.extension, color: color, size: 30),
      ),
    );
  }
}

class _HeroFeature extends StatelessWidget {
  final String imageUrl;
  final String eyebrow;
  final String title;
  final String description;
  final String primaryAction;
  final String secondaryAction;

  const _HeroFeature({
    required this.imageUrl,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.primaryAction,
    required this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 560 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: isWide ? 46 : 34,
                        height: 1.02,
                      ),
                ),
                const SizedBox(height: 14),
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: Text(primaryAction),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: Text(secondaryAction),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: isWide ? 340 : double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: isWide ? 0.88 : 1.15,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.22),
                              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.18),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.auto_awesome,
                          size: 54,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.44),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Editorial image cue from the live feed',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _LatestDivesPanel extends StatelessWidget {
  final List<Story> stories;

  const _LatestDivesPanel({required this.stories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < stories.length; index++) ...[
            _LatestDiveRow(story: stories[index]),
            if (index != stories.length - 1) const SizedBox(height: 12),
            if (index != stories.length - 1)
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
              ),
            if (index != stories.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _LatestDiveRow extends StatelessWidget {
  final Story story;

  const _LatestDiveRow({required this.story});

  @override
  Widget build(BuildContext context) {
    final category = story.tags.isNotEmpty ? story.tags.first : 'Update';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            story.heroImage,
            width: 84,
            height: 84,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 84,
              height: 84,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
              alignment: Alignment.center,
              child: Icon(
                Icons.image_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 6),
              Text(story.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(_formatStoryDate(story.publishedAt), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_rounded, color: Theme.of(context).colorScheme.secondary),
      ],
    );
  }
}

class _NewsletterSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const _NewsletterSection({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.22)),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          SizedBox(
            width: 360,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.82),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text('Subscribe'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterCredit extends StatelessWidget {
  const _FooterCredit();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Intelligence Orchestrated by Gemini',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
          ),
    );
  }
}

String _formatStoryDate(DateTime publishedAt) {
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
