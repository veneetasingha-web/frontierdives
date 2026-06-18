import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontierdives/models/author.dart';
import 'package:frontierdives/models/story.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Story>> storiesStream() {
    return _firestore
        .collection('stories')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Story.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> saveStory(Story story) async {
    await _firestore.collection('stories').doc(story.id).set(story.toJson());
  }

  Future<void> updateStory(Story story) async {
    await _firestore.collection('stories').doc(story.id).update(story.toJson());
  }

  Future<void> deleteStory(String storyId) async {
    await _firestore.collection('stories').doc(storyId).delete();
  }

  Future<void> markStorySecurityStatus({
    required String storyId,
    required String securityStatus,
    String securityNote = '',
  }) async {
    await _firestore.collection('stories').doc(storyId).update({
      'securityStatus': securityStatus,
      'securityNote': securityNote,
    });
  }

  Stream<List<Author>> authorsStream() {
    return _firestore.collection('authors').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Author.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  Future<Author?> getAuthor(String id) async {
    final doc = await _firestore.collection('authors').doc(id).get();
    if (!doc.exists) return null;
    return Author.fromJson({...doc.data()!, 'id': doc.id});
  }
}
