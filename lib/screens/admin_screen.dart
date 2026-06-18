import 'package:flutter/material.dart';
import 'package:frontierdives/data/sample_data.dart';
import 'package:frontierdives/models/story.dart';
import 'package:frontierdives/services/firestore_service.dart';

class AdminScreen extends StatefulWidget {
  final String userRole;

  const AdminScreen({super.key, this.userRole = 'guest'});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _contentController = TextEditingController();
  final _heroImageController = TextEditingController();
  final _authorIdController = TextEditingController();
  final _bylineController = TextEditingController();
  final _creditController = TextEditingController(text: 'Written with Claude / Gemini');
  final _photoEssayController = TextEditingController();
  final _audioUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _securityNoteController = TextEditingController();

  String _selectedTheme = 'Culture';
  bool _verified = true;
  String _securityStatus = 'Verified Secure';
  bool _isSaving = false;
  Story? _editingStory;

  bool get _hasAccess => widget.userRole == 'editor' || widget.userRole == 'contributor';

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    _heroImageController.dispose();
    _authorIdController.dispose();
    _bylineController.dispose();
    _creditController.dispose();
    _photoEssayController.dispose();
    _audioUrlController.dispose();
    _videoUrlController.dispose();
    _securityNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasAccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Panel')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 60, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 16),
                  Text(
                    'Editors and contributors only',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This panel is role-restricted. It manages Firestore stories, verification, and security status workflows.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor / Admin Panel'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                widget.userRole.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Story>>(
        stream: FirestoreService().storiesStream(),
        builder: (context, snapshot) {
          final stories = _mergeStories(snapshot.data ?? sampleStories);
          final verifiedCount = stories.where((story) => story.verified).length;
          final flaggedCount = stories.where((story) => !story.verified || story.securityStatus != 'Verified Secure').length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatChip(label: 'Verified Secure', value: verifiedCount.toString(), color: const Color(0xFF15803D)),
                  _StatChip(label: 'Flagged', value: flaggedCount.toString(), color: const Color(0xFFB42318)),
                  _StatChip(label: 'FireStore live', value: 'On', color: Theme.of(context).colorScheme.secondary),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.68),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fact-check and tone calibration', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        Chip(label: Text('Sources cross-checked')),
                        Chip(label: Text('Tone calibrated')),
                        Chip(label: Text('Human verified')),
                        Chip(label: Text('Anomaly scan passed')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 1100;
                  final editorPane = _buildEditorPane(context);
                  final storyPane = _buildStoryList(context, stories);
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: editorPane),
                            const SizedBox(width: 16),
                            Expanded(flex: 4, child: storyPane),
                          ],
                        )
                      : Column(
                          children: [
                            editorPane,
                            const SizedBox(height: 16),
                            storyPane,
                          ],
                        );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEditorPane(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _editingStory == null ? 'Upload a story' : 'Edit story',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _buildInput(_idController, 'Story ID', validator: (value) => value == null || value.isEmpty ? 'Required' : null),
            _buildInput(_titleController, 'Headline', validator: (value) => value == null || value.isEmpty ? 'Required' : null),
            _buildInput(_subtitleController, 'Subheadline'),
            _buildInput(_bylineController, 'Contributor byline', hint: 'By Frontier Dives / Writer Name'),
            _buildInput(_authorIdController, 'Author ID', hint: 'Firestore author document id', validator: (value) => value == null || value.isEmpty ? 'Required' : null),
            _buildInput(_heroImageController, 'Hero image URL', validator: (value) => value == null || value.isEmpty ? 'Required' : null),
            _buildInput(_photoEssayController, 'Photo essay URLs', hint: 'Comma-separated image URLs'),
            _buildInput(_audioUrlController, 'Audio URL'),
            _buildInput(_videoUrlController, 'Video URL'),
            _buildInput(_creditController, 'AI collaboration credit'),
            _buildInput(_securityNoteController, 'Security note'),
            DropdownButtonFormField<String>(
              initialValue: _selectedTheme,
              decoration: const InputDecoration(labelText: 'Theme', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Culture', child: Text('Culture')),
                DropdownMenuItem(value: 'Politics', child: Text('Politics')),
                DropdownMenuItem(value: 'Tech', child: Text('Tech')),
                DropdownMenuItem(value: 'Climate', child: Text('Climate')),
                DropdownMenuItem(value: 'Urban Life', child: Text('Urban Life')),
              ],
              onChanged: (value) => setState(() => _selectedTheme = value ?? 'Culture'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _securityStatus,
              decoration: const InputDecoration(labelText: 'Security integrity', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Verified Secure', child: Text('Verified Secure')),
                DropdownMenuItem(value: 'Flagged', child: Text('Flagged')),
                DropdownMenuItem(value: 'Needs Review', child: Text('Needs Review')),
              ],
              onChanged: (value) => setState(() => _securityStatus = value ?? 'Verified Secure'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _verified,
              onChanged: (value) => setState(() => _verified = value),
              title: const Text('Human verified'),
              subtitle: const Text('Surface the verification badge in feed and story detail screens.'),
            ),
            _buildInput(_contentController, 'Full narrative', maxLines: 8, validator: (value) => value == null || value.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: _isSaving ? null : _saveStory,
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: Text(_editingStory == null ? 'Publish to Firestore' : 'Update story'),
                ),
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryList(BuildContext context, List<Story> stories) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Manage stories', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          SizedBox(
            height: 720,
            child: ListView.separated(
              itemCount: stories.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final story = stories[index];
                return _ManagedStoryTile(
                  story: story,
                  onEdit: () => _loadStoryIntoForm(story),
                  onDelete: () => _deleteStory(story.id),
                  onFlag: () => _updateSecurity(story, story.securityStatus == 'Flagged' ? 'Verified Secure' : 'Flagged'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _saveStory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final story = Story(
        id: _idController.text.trim(),
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim(),
        content: _contentController.text.trim(),
        heroImage: _heroImageController.text.trim(),
        authorId: _authorIdController.text.trim(),
        publishedAt: _editingStory?.publishedAt ?? DateTime.now(),
        tags: [_selectedTheme],
        byline: _bylineController.text.trim(),
        verified: _verified,
        collaborationCredit: _creditController.text.trim(),
        photoEssayUrls: _splitCsv(_photoEssayController.text),
        audioUrl: _audioUrlController.text.trim().isEmpty ? null : _audioUrlController.text.trim(),
        videoUrl: _videoUrlController.text.trim().isEmpty ? null : _videoUrlController.text.trim(),
        securityStatus: _securityStatus,
        securityNote: _securityNoteController.text.trim(),
      );

      final service = FirestoreService();
      if (_editingStory == null) {
        await service.saveStory(story);
      } else {
        await service.updateStory(story);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_editingStory == null ? 'Story published' : 'Story updated')),
        );
        _resetForm();
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteStory(String storyId) async {
    await FirestoreService().deleteStory(storyId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story deleted')),
      );
    }
  }

  Future<void> _updateSecurity(Story story, String status) async {
    await FirestoreService().markStorySecurityStatus(
      storyId: story.id,
      securityStatus: status,
      securityNote: status == 'Flagged' ? 'Marked by admin review for anomaly follow-up.' : '',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Security status updated to $status')),
      );
    }
  }

  void _loadStoryIntoForm(Story story) {
    setState(() {
      _editingStory = story;
      _idController.text = story.id;
      _titleController.text = story.title;
      _subtitleController.text = story.subtitle;
      _contentController.text = story.content;
      _heroImageController.text = story.heroImage;
      _authorIdController.text = story.authorId;
      _bylineController.text = story.byline;
      _creditController.text = story.collaborationCredit;
      _photoEssayController.text = story.photoEssayUrls.join(', ');
      _audioUrlController.text = story.audioUrl ?? '';
      _videoUrlController.text = story.videoUrl ?? '';
      _securityNoteController.text = story.securityNote;
      _selectedTheme = story.tags.isNotEmpty ? story.tags.first : 'Culture';
      _verified = story.verified;
      _securityStatus = story.securityStatus;
    });
  }

  void _resetForm() {
    setState(() {
      _editingStory = null;
      _idController.clear();
      _titleController.clear();
      _subtitleController.clear();
      _contentController.clear();
      _heroImageController.clear();
      _authorIdController.clear();
      _bylineController.clear();
      _creditController.text = 'Written with Claude / Gemini';
      _photoEssayController.clear();
      _audioUrlController.clear();
      _videoUrlController.clear();
      _securityNoteController.clear();
      _selectedTheme = 'Culture';
      _verified = true;
      _securityStatus = 'Verified Secure';
      _isSaving = false;
    });
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

  List<String> _splitCsv(String value) {
    return value
        .split(',')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
  }
}

class _ManagedStoryTile extends StatelessWidget {
  final Story story;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onFlag;

  const _ManagedStoryTile({
    required this.story,
    required this.onEdit,
    required this.onDelete,
    required this.onFlag,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = story.securityStatus == 'Verified Secure'
        ? const Color(0xFF15803D)
        : const Color(0xFFB42318);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(story.title, style: Theme.of(context).textTheme.titleMedium),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  story.securityStatus,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            story.byline.isNotEmpty ? story.byline : 'By ${story.authorId}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            story.securityNote.isNotEmpty ? story.securityNote : 'No security flags noted.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton(onPressed: onEdit, child: const Text('Edit')),
              OutlinedButton(onPressed: onFlag, child: Text(story.securityStatus == 'Flagged' ? 'Unflag' : 'Flag')),
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(foregroundColor: const Color(0xFFB42318)),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}
