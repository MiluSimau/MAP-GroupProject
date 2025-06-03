import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> newsArticles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHockeyNews();
  }

  Future<void> fetchHockeyNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=ice+hockey&pageSize=10&sortBy=publishedAt&apiKey=5e8ff512ea564ebf86f3cba10b4b1ee8');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          newsArticles = data['articles'];
          isLoading = false;
        });
      } else {
        print('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  List<dynamic> get newsOnly =>
      newsArticles.where((article) => article['title'] != null).toList();

  List<dynamic> get announcementsOnly => []; // Placeholder

  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Ice Hockey News',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          centerTitle: false,
          toolbarHeight: 48,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Material(
              color: Colors.white,
              elevation: 2,
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'News'),
                      Tab(text: 'Announcements'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              NewsListView(articles: newsArticles, isLoading: isLoading),
              NewsListView(articles: newsOnly, isLoading: isLoading),
              const AnnouncementsPlaceholder(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchHockeyNews,
          backgroundColor: Colors.red,
          child: const Icon(Icons.refresh, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class NewsListView extends StatefulWidget {
  final List<dynamic> articles;
  final bool isLoading;

  const NewsListView({super.key, required this.articles, required this.isLoading});

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.articles.length,
      itemBuilder: (context, index) {
        final article = widget.articles[index];
        return AnnouncementCard(
          title: article['title'] ?? 'No Title',
          date: article['publishedAt']?.substring(0, 10) ?? '',
          description: article['description'] ?? 'No description',
          imageUrl: article['urlToImage'],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AnnouncementsPlaceholder extends StatelessWidget {
  const AnnouncementsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No announcements yet.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String? imageUrl;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[100],
                radius: 24,
                child: const Icon(Icons.campaign, color: Colors.red),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(date,
                        style: TextStyle(
                            color: Colors.grey[700], fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
