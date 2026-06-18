import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontierdives/data/sample_data.dart';
import 'package:frontierdives/screens/home_screen.dart';

void main() {
  testWidgets('renders the Frontier Dives landing page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(storiesStream: Stream.value(sampleStories)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('FRONTIER DIVES / फ्रन्टियर डाइभ्स'), findsOneWidget);
    expect(find.text("Human-Verified Stories from Kathmandu's AI Frontier"), findsOneWidget);
    expect(find.text('Writer Login'), findsOneWidget);
    expect(find.text('Join Now'), findsWidgets);
  });
}
