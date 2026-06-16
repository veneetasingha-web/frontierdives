import 'package:flutter/material.dart';
import 'package:frontierdives/models/author.dart';
import 'package:frontierdives/models/story.dart';
import 'package:frontierdives/services/firestore_service.dart';

class StoryDetailScreen extends StatelessWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text(story.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (story.heroImage.isNotEmpty)
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Image.network(story.heroImage, fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Published ${story.publishedAt.toLocal().toIso8601String().split('T').first}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 16),
                  Text(story.content, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  FutureBuilder<Author?>(
                    future: service.getAuthor(story.authorId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Author data unavailable: ${snapshot.error}');
                      }
                      final author = snapshot.data;
                      if (author == null) {
                        return const Text('Author information not available.');
                      }
                      return Row(
                        children: [
                          if (author.avatarUrl.isNotEmpty)
                            CircleAvatar(
                              backgroundImage: NetworkImage(author.avatarUrl),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(author.name, style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 4),
                                Text(author.bio, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
