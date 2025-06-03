import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'EventRegistration.dart'; // your event creation screen

class Event {
  final ImageProvider imageProvider;
  final String title;
  final String date;
  final String location;

  Event({
    required this.imageProvider,
    required this.title,
    required this.date,
    required this.location,
  });
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> events = [
    Event(
      imageProvider: NetworkImage(
          'https://upload.wikimedia.org/wikipedia/commons/6/6b/Tree_icon.png'),
      title: 'FNB Classic Clash',
      date: '3-7 Jun',
      location: 'Windhoek',
    ),
    Event(
      imageProvider: NetworkImage(
          'https://upload.wikimedia.org/wikipedia/commons/3/3e/Field_hockey_icon_2.png'),
      title: 'Ladies 7-a-side Tournament',
      date: '8 Jun',
      location: 'Windhoek',
    ),
  ];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _navigateToCreateEvent() async {
    final newEvent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventCreationScreen()),
    );

    if (newEvent != null && newEvent is Event) {
      setState(() {
        events.add(newEvent);
      });
    }
  }

  void _navigateToCreateFixture() {
    // TODO: Implement fixture creation screen navigation
    // Example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => FixtureCreationScreen()),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fixture creation screen not implemented yet.')),
    );
  }

  void _updateScore(
      String eventId, String scoreField, int newScore, BuildContext context) {
    FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .update({scoreField: newScore}).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update score: $error')),
      );
    });
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> data,
      ImageProvider imageProvider, String eventId) {
    final teamA = data['teamA'] ?? 'Team A';
    final teamB = data['teamB'] ?? 'Team B';
    int scoreTeamA = data['scoreTeamA'] ?? 0;
    int scoreTeamB = data['scoreTeamB'] ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 32,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? 'Untitled Event',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${data['startTime'] ?? ''} | ${data['location'] ?? ''}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1.5),
                  Text(
                    'Live Score',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildScoreColumn(
                          teamA, scoreTeamA, eventId, 'scoreTeamA', context,
                          setState),
                      Container(
                        width: 1,
                        height: 60,
                        color: Colors.grey[300],
                      ),
                      _buildScoreColumn(
                          teamB, scoreTeamB, eventId, 'scoreTeamB', context,
                          setState),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Center(
                      child: Text('Close', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildScoreColumn(String team, int score, String eventId,
      String scoreField, BuildContext context, Function setState) {
    return Column(
      children: [
        Text(team,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: score > 0
                  ? () {
                      setState(() {
                        score--;
                      });
                      _updateScore(eventId, scoreField, score, context);
                    }
                  : null,
            ),
            Text(
              '$score',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              onPressed: () {
                setState(() {
                  score++;
                });
                _updateScore(eventId, scoreField, score, context);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Events Screen',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 48,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView(
            children: [
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Calendar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const SizedBox(height: 12),
              _buildCalendar(),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Events',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 8),
              ...events.map((event) => EventCard(
                    imageProvider: event.imageProvider,
                    title: event.title,
                    date: event.date,
                    location: event.location,
                  )),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Live Events',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 8),
              FirestoreEventList(
                onEventTap: (doc, data, imageProvider) {
                  _showEventDetails(context, data, imageProvider, doc.id);
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton.extended(
      onPressed: _navigateToCreateEvent,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.event),
      label: const Text('Create Event'),
      heroTag: 'createEventFAB',
    ),
    const SizedBox(width: 16),
    FloatingActionButton.extended(
      onPressed: _navigateToCreateFixture,
      backgroundColor: Colors.orange,
      icon: const Icon(Icons.sports_soccer),
      label: const Text('Create Fixture'),
      heroTag: 'createFixtureFAB',
    ),
  ],
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final ImageProvider imageProvider;
  final String title;
  final String date;
  final String location;

  const EventCard({
    super.key,
    required this.imageProvider,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: imageProvider),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$date • $location'),
      ),
    );
  }
}

class FirestoreEventList extends StatelessWidget {
  final Function(DocumentSnapshot, Map<String, dynamic>, ImageProvider)
      onEventTap;

  const FirestoreEventList({super.key, required this.onEventTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading events'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('No live events found.'));
        }
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final imageProvider = NetworkImage(data['imageUrl'] ??
                'https://upload.wikimedia.org/wikipedia/commons/6/6b/Tree_icon.png');
            return GestureDetector(
              onTap: () => onEventTap(doc, data, imageProvider),
              child: EventCard(
                imageProvider: imageProvider,
                title: data['name'] ?? 'Untitled Event',
                date: data['startTime'] ?? '',
                location: data['location'] ?? '',
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
