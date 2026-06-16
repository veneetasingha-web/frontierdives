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
