import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stotra_service.dart';
import '../models/stotra.dart';
import '../widgets/nudi_text.dart';
import 'reader_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Stotra> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final stotraService = context.read<StotraService>();
    setState(() {
      _results = stotraService.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'ಸ್ತೋತ್ರ ಹುಡುಕಿ...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                setState(() => _results = []);
              },
            ),
        ],
      ),
      body: _controller.text.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_rounded,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('ಸ್ತೋತ್ರದ ಹೆಸರು ಟೈಪ್ ಮಾಡಿ',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            )
          : _results.isEmpty
              ? const Center(child: Text('ಯಾವುದೇ ಫಲಿತಾಂಶ ಇಲ್ಲ'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final stotra = _results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: NudiText(
                          text: stotra.title,
                          fontSize: 15,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          height: 1.3,
                        ),
                        subtitle: Text(stotra.categoryTitle,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary)),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReaderScreen(stotra: stotra)),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
