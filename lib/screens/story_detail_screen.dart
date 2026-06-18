import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontierdives/models/author.dart';
import 'package:frontierdives/models/story.dart';
import 'package:frontierdives/services/firestore_service.dart';

class StoryDetailScreen extends StatelessWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    final byline = story.byline.isNotEmpty ? story.byline : 'By Frontier Dives';

    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        actions: [
          IconButton(
            tooltip: 'Share story',
            onPressed: () => _showShareSheet(context),
            icon: const Icon(Icons.ios_share_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (story.heroImage.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      story.heroImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        child: const Center(child: Icon(Icons.image_outlined, size: 44)),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _VerificationBadge(verified: story.verified),
                          const SizedBox(width: 10),
                          _SecurityBadge(status: story.securityStatus),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        story.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              height: 1.05,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        byline,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatDate(story.publishedAt),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        story.collaborationCredit,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        story.subtitle.isNotEmpty
                            ? story.subtitle
                            : 'Ambient storytelling for the Kathmandu AI frontier.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        story.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (story.photoEssayUrls.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionBlock(
                  title: 'Photo Essay',
                  child: SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: story.photoEssayUrls.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final url = story.photoEssayUrls[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: AspectRatio(
                            aspectRatio: 1.35,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
                                alignment: Alignment.center,
                                child: const Icon(Icons.photo_outlined),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          if (story.audioUrl != null || story.videoUrl != null)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionBlock(
                  title: 'Media',
                  child: Column(
                    children: [
                      if (story.audioUrl != null)
                        _MediaTile(
                          icon: Icons.graphic_eq,
                          title: 'Audio support',
                          subtitle: story.audioUrl!,
                          actionLabel: 'Copy URL',
                          onAction: () => _copyToClipboard(context, story.audioUrl!),
                        ),
                      if (story.videoUrl != null) ...[
                        if (story.audioUrl != null) const SizedBox(height: 12),
                        _MediaTile(
                          icon: Icons.play_circle_outline,
                          title: 'Video support',
                          subtitle: story.videoUrl!,
                          actionLabel: 'Copy URL',
                          onAction: () => _copyToClipboard(context, story.videoUrl!),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            sliver: SliverToBoxAdapter(
              child: _SectionBlock(
                title: 'Author / Collaborator',
                child: FutureBuilder<Author?>(
                  future: service.getAuthor(story.authorId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('Author data unavailable: ${snapshot.error}');
                    }
                    final author = snapshot.data;
                    if (author == null) {
                      return const Text('Author information not available.');
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (author.avatarUrl.isNotEmpty)
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(author.avatarUrl),
                            onBackgroundImageError: (_, _) {},
                          )
                        else
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                            child: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.secondary),
                          ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(author.name, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(author.bio, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Share story', style: Theme.of(sheetContext).textTheme.headlineSmall),
                const SizedBox(height: 10),
                const Text('Copy this story text into your preferred app or channel.'),
                const SizedBox(height: 16),
                SelectableText('${story.title}\n\n${story.content}'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: '${story.title}\n\n${story.content}'));
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Story copied for sharing')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy story text'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionBlock({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const _MediaTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
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
        verified ? 'Human-in-the-loop' : 'Needs review',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  final String status;

  const _SecurityBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final flagged = status != 'Verified Secure';
    final color = flagged ? const Color(0xFFB42318) : const Color(0xFF15803D);
    final background = flagged ? const Color(0xFFFDECEC) : const Color(0xFFE7F6EC);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
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
