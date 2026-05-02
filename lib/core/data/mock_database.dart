import 'package:flutter/material.dart';

// ── Models ───────────────────────────────────────────────────────────────────

class MockChapter {
  final int number;
  final String title;
  final String timeLabel;
  final bool isNew;
  final bool isRead;
  final int? wordCount; // Used for novels
  final String? content; // Used for novels

  const MockChapter({
    required this.number,
    required this.title,
    required this.timeLabel,
    this.isNew = false,
    this.isRead = false,
    this.wordCount,
    this.content,
  });
}

class MockReviewSummary {
  final double average;
  final String ratingsCountLabel;
  final Map<int, double> bars;

  const MockReviewSummary({
    required this.average,
    required this.ratingsCountLabel,
    required this.bars,
  });
}

class MockReview {
  final String author;
  final String timeLabel;
  final double rating;
  final String content;
  final int likes;
  final int comments;

  const MockReview({
    required this.author,
    required this.timeLabel,
    required this.rating,
    required this.content,
    required this.likes,
    required this.comments,
  });
}

class MockRelatedStory {
  final String title;
  final double rating;
  final Color coverColor;

  const MockRelatedStory({
    required this.title,
    required this.rating,
    required this.coverColor,
  });
}

class MockTitle {
  final String id;
  final String title;
  final String type; // 'Manga' or 'Novel'
  final String author;
  final String status;
  final double rating;
  final String ratingsCountLabel;
  final String readsLabel;
  final String synopsis;
  final List<String> genres;
  final Color coverColor;
  final List<MockChapter> chapters;
  final MockReviewSummary reviewSummary;
  final List<MockReview> reviews;
  final List<MockRelatedStory> relatedStories;
  final bool openAsGuest;

  const MockTitle({
    required this.id,
    required this.title,
    required this.type,
    required this.author,
    required this.status,
    required this.rating,
    required this.ratingsCountLabel,
    required this.readsLabel,
    required this.synopsis,
    required this.genres,
    required this.coverColor,
    required this.chapters,
    required this.reviewSummary,
    required this.reviews,
    required this.relatedStories,
    this.openAsGuest = false,
  });
}

// ── Shared Data ───────────────────────────────────────────────────────────────

const MockReviewSummary kDefaultReviewSummary = MockReviewSummary(
  average: 4.8,
  ratingsCountLabel: '12.5k',
  bars: {5: 0.92, 4: 0.16, 3: 0.04, 2: 0.01, 1: 0.02},
);

const List<MockReview> kDefaultReviews = [
  MockReview(
    author: 'Sarah Jenkins',
    timeLabel: '2d ago',
    rating: 5,
    content:
        'This series just keeps getting better! The character development in the latest arc is phenomenal. Can\'t wait for the next update.',
    likes: 245,
    comments: 12,
  ),
];

const List<MockRelatedStory> kDefaultRelatedStories = [
  MockRelatedStory(
    title: 'Omniscient Reader\'s Viewpoint',
    rating: 4.9,
    coverColor: Color(0xFF8BA1C2),
  ),
  MockRelatedStory(
    title: 'Solo Leveling',
    rating: 4.8,
    coverColor: Color(0xFF70839F),
  ),
  MockRelatedStory(
    title: 'Tower of God',
    rating: 4.7,
    coverColor: Color(0xFF8A98AF),
  ),
];

class MockDatabase {
  static const List<MockTitle> titles = [
    // 1. Final Quarter (Manga)
    MockTitle(
      id: 'final_quarter',
      title: 'Final Quarter',
      type: 'Manga',
      author: 'Jasper Hall',
      status: 'ONGOING',
      rating: 4.3,
      ratingsCountLabel: '8.2k',
      readsLabel: '640k',
      synopsis:
          'A last season comeback puts a fractured team against impossible odds.',
      genres: ['Manga', 'Sports', 'Drama'],
      coverColor: Color(0xFFE7E7E7),
      chapters: [
        MockChapter(number: 24, title: 'The Last Shot', timeLabel: '2 hours ago', isNew: true),
        MockChapter(number: 23, title: 'Breakdown', timeLabel: '1 week ago'),
        MockChapter(number: 22, title: 'Rebuilding', timeLabel: '2 weeks ago', isRead: true),
      ],
      reviewSummary: kDefaultReviewSummary,
      reviews: kDefaultReviews,
      relatedStories: kDefaultRelatedStories,
    ),

    // 2. Star-Crossed... (Manga)
    MockTitle(
      id: 'star_crossed',
      title: 'Star-Crossed...',
      type: 'Manga',
      author: 'Mina Cho',
      status: 'ONGOING',
      rating: 4.6,
      ratingsCountLabel: '11.5k',
      readsLabel: '980k',
      synopsis:
          'Two worlds collide when a comet awakens a forbidden bond between rival families.',
      genres: ['Manga', 'Romance', 'Drama', 'Fantasy'],
      coverColor: Color(0xFFD7E9F1),
      chapters: [
        MockChapter(number: 142, title: 'After the Rift', timeLabel: '30 minutes ago', isNew: true),
        MockChapter(number: 141, title: 'Reunion and Revelation', timeLabel: '2 hours ago', isNew: true),
        MockChapter(number: 140, title: 'The Calm Before', timeLabel: '3 days ago'),
        MockChapter(number: 139, title: 'Echoes of the Past', timeLabel: '1 week ago'),
      ],
      reviewSummary: kDefaultReviewSummary,
      reviews: kDefaultReviews,
      relatedStories: kDefaultRelatedStories,
    ),

    // 3. Solo Leveling (Manga)
    MockTitle(
      id: 'solo_leveling',
      title: 'Solo Leveling',
      type: 'Manga',
      author: 'Chugong, DUBU (REDICE STUDIO)',
      status: 'COMPLETED',
      rating: 4.9,
      ratingsCountLabel: '24.5k',
      readsLabel: '3.5M',
      synopsis:
          'In a world where hunters must battle deadly monsters to protect the human race from certain annihilation, a notoriously weak hunter named Sung Jinwoo finds himself in a seemingly endless struggle for survival. One day, after narrowly surviving an overwhelmingly powerful double dungeon that nearly wipes out his entire party, a mysterious program called the System chooses him as its sole player and in turn, gives him the extremely rare ability to level up in strength.',
      genres: ['Manga', 'Action', 'Fantasy'],
      coverColor: Color(0xFF0D2742),
      chapters: [
        MockChapter(number: 200, title: 'Side Story: Epilogue', timeLabel: '1 year ago'),
        MockChapter(number: 199, title: 'Side Story', timeLabel: '1 year ago'),
      ],
      reviewSummary: MockReviewSummary(
        average: 4.9,
        ratingsCountLabel: '24.5k',
        bars: {5: 0.95, 4: 0.03, 3: 0.01, 2: 0.005, 1: 0.005},
      ),
      reviews: kDefaultReviews,
      relatedStories: kDefaultRelatedStories,
      openAsGuest: true, // Allow opening as guest for demonstration
    ),

    // 4. The Azure Sentinel: Rebirth (Novel)
    MockTitle(
      id: 'azure_sentinel',
      title: 'The Azure Sentinel: Rebirth',
      type: 'Novel',
      author: 'Iris Vale',
      status: 'ONGOING',
      rating: 4.9,
      ratingsCountLabel: '12.5k',
      readsLabel: '1.8M',
      synopsis:
          'A sentinel returns to a shattered sky to rebuild a fallen order and defend the last city of light.',
      genres: ['Novel', 'Action', 'Sci-Fi', 'Fantasy'],
      coverColor: Color(0xFF6FAED6),
      chapters: [
        MockChapter(number: 68, title: 'Return of the Light', timeLabel: '2 days ago', isNew: true),
        MockChapter(number: 67, title: 'Shattered Skies', timeLabel: '1 week ago'),
      ],
      reviewSummary: kDefaultReviewSummary,
      reviews: kDefaultReviews,
      relatedStories: kDefaultRelatedStories,
    ),

    // 5. Elara and the Forgotten Kingdom (Novel)
    MockTitle(
      id: 'elara',
      title: 'Elara and the Forgotten Kingdom',
      type: 'Novel',
      author: 'Sylvia Moorcroft',
      status: 'ONGOING',
      rating: 4.7,
      ratingsCountLabel: '5.3k',
      readsLabel: '850k',
      synopsis:
          'Elara journeys into the lost city of Valdris, guided by a silver key and a creature older than time, to unfold the kingdom that her mother spent twenty years trying to find.',
      genres: ['Novel', 'Fantasy', 'Adventure'],
      coverColor: Color(0xFF3B1F6B),
      chapters: [
        MockChapter(
          number: 1,
          title: 'The Crumbling Gate',
          timeLabel: '2 weeks ago',
          wordCount: 3200,
          content: '''The gate had not been opened in a hundred years.

Elara pressed her palm against the cold iron, half expecting it to crumble at her touch. Rust flaked away like dried blood, drifting to the moss-slicked stones below. Beyond the gate, the outline of Valdris — or what remained of it — shivered in the morning mist.

"You don't have to do this," said Renn from somewhere behind her. He had been saying that for three days, ever since they left Ashenvale. Elara had stopped answering.

She pulled. The hinges screamed. The gate swung inward an inch, then two, then enough for a person to slip through sideways. She did.

Inside, the city breathed.

That was the only way to describe it — a slow, deep respiration that moved through the broken columns and shattered fountains, through the wild honeysuckle that had swallowed the old merchant district whole. The air tasted faintly of stone and something sweeter. Rain-soaked parchment, perhaps. The ghost of a library.

Renn appeared at her shoulder, hood up despite the cloudless sky. "Scouts reported movement in the northern quarter," he murmured. "Whatever is living here, it is not small."

Elara kept walking. Her boots crunched over a mosaic of blue and gold tiles, the portrait of some long-dead queen now only legible from the cheekbones down. She felt the weight of the silver key at her throat — her mother's key, her mother's obsession, her mother's last gift.

"Then we move quietly," she said.

The first true sign of life appeared near what had been the central bazaar. A fire-ring, recently used. Bones from a meal, stripped clean. The kind of care a person takes when they do not wish to be found.

Elara crouched and studied the ash. Still warm.

She stood, heart steady, and said the words she had rehearsed since childhood: "I am Elara of the Morvaine line. I carry the Crescent Key. I come not to claim what was lost, but to understand why it was."

Silence answered.

Then, from the honeysuckle, a pair of amber eyes.

The creature that stepped forward was neither beast nor man but something older than the word for either. It regarded her with the patience of architecture. Around its neck, on a cord of braided grass, hung the twin to her key.

"We have been waiting," it said, in a voice like wind through organ pipes, "for the one who would not try to take."''',
        ),
        MockChapter(
          number: 2,
          title: 'The Keeper of Keys',
          timeLabel: '2 weeks ago',
          wordCount: 2950,
          content: '''Its name was Sael — or rather, Sael was the syllable it permitted humans to use without their tongues going sideways. The rest of its name existed in frequencies that vibrated stone.

Elara sat cross-legged on a broken plinth and listened.

Renn kept his hand near his knife. Old habit. She had asked him to unlearn it before they arrived, but Renn's habits were architectural; they did not unlearn so much as get built around.

"The kingdom did not fall," Sael explained, moving through the ruins with a gait that was all wrong for its joints, yet entirely graceful. "It folded. There is a difference."

"Folded," Elara repeated.

"As a letter folds. The content is still present. Only the surface is hidden."

She thought about that for a long moment. Around them, a breeze passed through the honeysuckle and set it moving in waves, and for just a second the outlines of market stalls flickered — not real, not imaginary, but something in between.

"The king," she said carefully. "My great-uncle. He didn't die."

"He chose the fold," Sael said. "As did all who remained. They are here, Lady Elara. They simply require an unfolding."

The silver key was warm against her sternum.

"My mother spent twenty years trying to find this place," Elara said. Her voice did not crack. She had practiced that too. "She died three months before she would have succeeded. The fever."

Sael's amber eyes moved to her. "She gave the key forward. That is how the line works. Grief is not a detour in your family, Lady. It is the path."

Renn made a sound that might have been a protest or just a breath released.

"Tell me how to unfold it," Elara said.

"You must gather the four anchor-stones," Sael replied, settling onto its haunches with a sound like gravel shifting. "Each is held by a guardian. Each guardian has a question. Answer falsely and the stone becomes ash. Answer with precision and the stone comes to you."

"And if I answer truly but not precisely?" Elara asked, because she was her mother's daughter and she knew questions had shapes.

For the first time, something that might have been approval moved across Sael's features.

"Then the guardian offers you a second question."

Elara looked at the twin key around Sael's neck. "What is yours?"

A long pause. The city breathed.

"What do you want that cannot be given to you?"

She answered without hesitation. The stone — small, translucent, the color of first light — dropped from a crack in the ruined arch above and fell into her open palm.

Renn was staring at her.

"What did you say?" he asked.

She closed her fingers around the stone. "My answer."''',
        ),
        MockChapter(
          number: 3,
          title: 'The Road to the Second Stone',
          timeLabel: '1 week ago',
          wordCount: 3100,
          content: '''The map Sael gave them was not made of paper.

It was made of light — a pattern of luminous lines pressed into Elara's palm by a touch so brief she almost missed it. When she held her hand open in the shade, the lines glowed faintly: paths, landmarks, a circle marking where the second anchor-stone waited.

"Southeast," she told Renn. "A place called the Mirror Marsh."

He groaned. "Of course it is."

They left Valdris as the sun climbed to noon. Elara walked in the center of the old road, where the paving stones still held together under her boots. Renn walked to the left, eyes moving, cataloguing threats that were not yet threats.

"The creature," he said eventually. "Sael."

"Yes?"

"It knew your name before you said it."

"It did."

"That doesn't bother you."

Elara considered. "My mother used to say that being known was not the same as being vulnerable. Being seen is not the same as being cornered." She paused. "What bothers me is that it still had its key. My mother's research said the Keeper would surrender both keys at the first Morvaine's arrival."

Renn was quiet for a few paces. "Meaning?"

"Meaning whoever came here before us — whoever convinced Sael that we were not Morvaine — gave it back."

The road forked. She chose east.

The Mirror Marsh announced itself with smell before sight: an earthy sweetness, and underneath it something metallic and cold. By mid-afternoon, the trees thinned and the ground began to give slightly with each step, the grass hiding inches of water beneath.

At the marsh's edge stood a woman in a grey cloak, stirring the surface of a still pool with one finger, watching the ripples with the concentration of someone reading a particularly dense page.

She did not look up.

"You are not as late as I expected," the woman said. Her voice had an accent Elara could not place — consonants that seemed borrowed from another alphabet.

"Then you knew we were coming," Renn said.

"I know when the first stone has been claimed. The marsh knows too. You'll notice the path held for you." She gestured vaguely at the dry route through the wet. "It does not always."

"You are the second guardian," Elara said.

Now the woman looked up. Her eyes were grey and very old and set in a face that was perhaps forty, perhaps four hundred. "I am Mira. I keep the second stone for those who find the first." She tilted her head. "But you will not get it today."

Elara waited.

"The marsh is not safe past dusk," Mira said. "And you need to rest. You've been walking since before dawn and you ate nothing today, Lady Elara. The stone can wait one night. Your body cannot."

Elara blinked. Then she felt, suddenly and completely, how tired she was.

"My question," she started.

"Tomorrow," Mira said firmly, and turned back to the pool. "There is a dry hut to the north. I have left food there. Sleep."

Renn was already looking north.

"We are being managed," Elara murmured to him.

"Competently," he agreed, and started walking.''',
        ),
        MockChapter(
          number: 4,
          title: 'Mira\'s Question',
          timeLabel: '3 days ago',
          wordCount: 2800,
          content: '''She dreamed of her mother standing in a library that did not exist, pulling books from shelves with the focused urgency of someone who was running out of time.

In the dream, her mother turned and said: "You are looking for the wrong thing, Elara."

"Then what am I looking for?"

Her mother smiled — the real smile, not the careful one she wore in public. "You will know when you stop looking."

Elara woke to birdsong and the smell of something warm on the small fire that had appeared in the hut's hearth. She did not question it. She ate. She had learned that caring for her body was not weakness but maintenance, and she was a tool that needed to function for some time yet.

Renn was already awake, sitting outside with his back to the wall, watching the marsh catch the early light. The surface was glass-still and doubled the sky so perfectly that up and down became suggestions rather than facts.

"Beautiful," he said, which was unlike him, and she understood that the marsh was doing something to both of them, softening edges that stayed sharp in ordinary places.

Mira was at the pool when they arrived.

She was not stirring it now. She stood with her hands clasped, watching them approach with an expression of careful patience.

"Ready?" she asked.

"Ask," said Elara.

Mira turned to face her fully. "What have you broken that cannot be repaired, and what did you learn from it?"

The silence lasted longer than with Sael's question. This one had weight. It pressed.

Elara thought of her mother's last years — the obsession that became isolation, the research that consumed the time they might have spent together. She thought of a younger Elara, sixteen and furious, who had said things designed to wound. Who had, for six months, refused to participate in the search that she had later come to believe in.

Six months they could not have back. Words that had been taken back in apology but not erased.

"I broke the last ordinary years of my mother's life," she said. "I withdrew when I should have stayed. I was cruel with the particular cruelty of children who do not yet understand that parents are also people." She breathed. "I learned that love is not preserved by protecting yourself from the grief of it. That staying — even when it is hard — is the only antidote to the regret of having left."

The pool's surface trembled. From the center, rising slowly through the water, came a stone the color of deep water: blue-grey, smooth, perfectly round.

It floated to the surface.

Elara reached in and took it.

The cold was extraordinary. Then it passed.

Mira watched her with the old, grey eyes. "Two more," she said quietly. "The road north, then west. The guardians will expect you."

"Will it get harder?" Renn asked.

Mira's gaze moved to him, and something in it made him go still.

"No," she said. "But you will."''',
        ),
        MockChapter(
          number: 5,
          title: 'What the North Stone Demands',
          timeLabel: '2 hours ago',
          isNew: true,
          wordCount: 3050,
          content: '''The north road was three days through forest so old the trees had grown together overhead, turning the path into a cathedral of bark and lichen. Light fell in columns. Something about the scale of it required quiet.

Renn had, in fact, been quiet for most of two days.

On the third evening, when they made camp in a clearing where the roots had formed a natural bench, he said, "Mira's comment. About getting harder."

"Yes."

"She was looking at me."

"She was."

He fed a stick to the fire. "She knows something about what is coming."

Elara said, "The stones are not testing me. I had not understood that until she said it." She turned the two stones over in her palm, feeling the warmth from the first and the cold from the second. "They test the person who carries them. And you are the one who carries me."

He was quiet for a long time.

"I am afraid," he said at last, with the stripped-down plainness of someone who has run out of ways to avoid saying a thing.

"Of the guardians?"

"Of you getting in." He looked at the fire. "Of what you find when you unfold the kingdom. Of who you become in the service of a destiny this large." A pause. "Of returning home to Ashenvale and finding that the person beside me is not the person who left."

The forest breathed around them.

"That is a reasonable fear," she said.

"I don't want your comfort. I wanted to say it out loud."

"I know." She looked at him. "I am afraid of the same thing, but in reverse. That in completing this, I lose what I am instead of becoming more of it."

He met her eyes. After a moment, he nodded once, the way that meant he had filed something and was not going to speak it further.

The third guardian had no body.

The north stone was suspended in the hollow of a lightning-struck oak at the edge of a ridge, and the guardian was the tree itself: a slow, sub-vocal frequency that entered through the feet and moved upward until it settled behind the sternum like a second heartbeat.

The question arrived the same way. Not in words. In a sensation.

What do you carry that belongs to someone else, and what do you do about that?

Elara stood with her hands at her sides and felt the weight of her mother's work — twenty years of correspondence, of maps, of margin notes, of questions that had consumed a life. She felt the key at her throat.

She thought: I carry it forward. I do not make it mine. I carry it to its destination and then I set it down.

And then, more quietly: And I grieve, when it is over, that I cannot return it.

The stone fell from the hollow. It was the color of old amber, warm as a held hand.

Three down.

Renn caught it when it fell, without being asked, and placed it in her palm with the others.

"West," she said.

"West," he agreed.''',
        ),
      ],
      reviewSummary: kDefaultReviewSummary,
      reviews: kDefaultReviews,
      relatedStories: kDefaultRelatedStories,
    ),
  ];
}
