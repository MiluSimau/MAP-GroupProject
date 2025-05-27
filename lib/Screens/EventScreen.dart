import 'package:flutter/material.dart';
import 'EventRegistration.dart';
import '../models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String imageUrl;
  final String title;
  final String date;
  final String location;

  Event({
    required this.imageUrl,
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
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6b/Tree_icon.png',
      title: 'FNB Classic Clash',
      date: '3-7 Jun',
      location: 'Windhoek',
    ),
    Event(
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/3e/Field_hockey_icon_2.png',
      title: 'Ladies 7-a-side Tournament',
      date: '8 Jun',
      location: 'Windhoek',
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView(
            children: [
              SizedBox(height: 18),
              Align(alignment: Alignment.centerLeft),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Calender',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              SizedBox(height: 12),
              CalendarWidget(),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Events',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
...events.map((event) => EventCard(
  imageUrl: event.imageUrl,
  title: event.title,
  date: event.date,
  location: event.location,
)),

SizedBox(height: 12),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Text(
    'Live Events',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  ),
),

FirestoreEventList(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEvent,
        backgroundColor: Colors.red,
        child: Icon(Icons.add, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: Colors.grey),
              Text('May 2025', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 4),
          ...List.generate(
            5,
            (week) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (day) {
                int date = week * 7 + day - 2;
                bool isToday = (date == 15);
                return Expanded(
                  child: Center(
                    child: Text(
                      date > 0 && date <= 31 ? '$date' : '',
                      style: TextStyle(
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String location;

  const EventCard({super.key, 
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(date, style: TextStyle(color: Colors.grey[700])),
                    SizedBox(width: 8),
                    Text(location, style: TextStyle(color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
class FirestoreEventList extends StatelessWidget {
  const FirestoreEventList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('timestamp', descending: true) // optional ordering
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Firestore events yet."));
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return EventCard(
              imageUrl: data['imageUrl'] ?? '',
              title: data['name'] ?? 'Untitled Event',
              date: data['startTime'] ?? '',
              location: data['location'] ?? 'Unknown',
            );
          }).toList(),
        );
      },
    );
  }
}
