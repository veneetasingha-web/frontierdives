import 'package:flutter/material.dart';
import 'package:frontierdives/models/story.dart';
import 'package:frontierdives/services/firestore_service.dart';
import 'package:frontierdives/widgets/hero_banner.dart';
import 'package:frontierdives/widgets/story_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    const fallbackImage = 'https://images.unsplash.com/photo-1504198453319-5ce911bafcde?w=1200&h=600&fit=crop';

    return Scaffold(
      appBar: AppBar(title: const Text('Frontier Dives')),
      body: Column(
        children: [
          StreamBuilder<List<Story>>(
            stream: service.storiesStream(),
            builder: (context, snapshot) {
              final stories = snapshot.data;
              return HeroBanner(
                title: 'Human-verified stories from Kathmandu',
                subtitle: 'Curated by NIMJN and contributors',
                imageUrl: stories?.isNotEmpty == true
                    ? stories!.first.heroImage
                    : fallbackImage,
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<Story>>(
              stream: service.storiesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading stories: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stories = snapshot.data ?? [];
                if (stories.isEmpty) {
                  return const Center(child: Text('No stories available yet.'));
                }

                return ListView.builder(
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return StoryCard(story: story);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
