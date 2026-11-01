import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/svara_mantra.dart';
import '../models/stotra.dart';
import '../services/stotra_service.dart';
import '../services/bookmark_service.dart';
import 'reader_screen.dart';

class SvaraCategoryScreen extends StatefulWidget {
  final SvaraCategory category;

  const SvaraCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<SvaraCategoryScreen> createState() => _SvaraCategoryScreenState();
}

class _SvaraCategoryScreenState extends State<SvaraCategoryScreen> {
  String _selectedSubgroupId = 'all';
  String _filter = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SvaraItemMeta> _getFilteredItems() {
    List<SvaraItemMeta> source = widget.category.items;

    if (_selectedSubgroupId != 'all' && widget.category.subgroups.isNotEmpty) {
      final subgroup = widget.category.subgroups.firstWhere(
        (g) => g.id == _selectedSubgroupId,
        orElse: () => widget.category.subgroups.first,
      );
      final idSet = subgroup.itemIds.toSet();
      source = source.where((item) => idSet.contains(item.id)).toList();
    }

    if (_filter.trim().isEmpty) return source;

    final q = _filter.trim().toLowerCase();
    return source.where((item) => item.title.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookmarks = context.watch<BookmarkService>();
    final stotraService = context.watch<StotraService>();
    final filteredItems = _getFilteredItems();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.category.count} ಸಸ್ವರ ಮಂತ್ರಗಳು',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _filter = val),
              decoration: InputDecoration(
                hintText: '${widget.category.title} ಹುಡುಕಿ...',
                hintStyle: GoogleFonts.notoSansKannada(fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _filter.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _filter = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1735) : const Color(0xFFF3F0FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Subgroup chips if present
          if (widget.category.subgroups.isNotEmpty)
            Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: widget.category.subgroups.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final sg = widget.category.subgroups[index];
                  final isSelected = sg.id == _selectedSubgroupId;
                  return FilterChip(
                    label: Text(
                      '${sg.title} (${sg.count})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: widget.category.color,
                    checkmarkColor: Colors.white,
                    backgroundColor: isDark ? const Color(0xFF1B142F) : const Color(0xFFEDE9F6),
                    onSelected: (val) {
                      setState(() {
                        _selectedSubgroupId = sg.id;
                      });
                    },
                  );
                },
              ),
            ),

          // Items List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      _filter.isEmpty ? 'ಯಾವುದೇ ಮಂತ್ರಗಳಿಲ್ಲ' : 'ಯಾವುದೇ ಫಲಿತಾಂಶ ದೊರೆತಿಲ್ಲ',
                      style: GoogleFonts.notoSansKannada(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isBookmarked = bookmarks.isBookmarked(item.id);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF120C24) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.grey.withOpacity(0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              final stotra = stotraService.getStotra(item.id) ??
                                  Stotra(
                                    id: item.id,
                                    title: item.title,
                                    content: '',
                                    font: 'brhknd',
                                    isUnicode: true,
                                    categoryId: item.categoryId,
                                    categoryTitle: item.categoryTitle,
                                    type: 'mantra',
                                    hasSvara: true,
                                  );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReaderScreen(stotra: stotra),
                                ),
                              );
                            },
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  // Left accent line
                                  Container(
                                    width: 4,
                                    color: widget.category.color,
                                  ),
                                  const SizedBox(width: 12),
                                  // Number badge
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.category.color.withOpacity(0.12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: widget.category.color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Title & Svara tag
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: GoogleFonts.notoSansKannada(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFD97706).withOpacity(0.14),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: const Color(0xFFD97706).withOpacity(0.3),
                                                    width: 0.8,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: const [
                                                    Icon(
                                                      Icons.auto_awesome_rounded,
                                                      size: 10,
                                                      color: Color(0xFFD97706),
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      'ಸಸ್ವರ',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFFD97706),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (item.categoryTitle.isNotEmpty) ...[
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    item.categoryTitle,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: isDark ? Colors.white54 : Colors.black45,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Bookmark button
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      size: 20,
                                      color: isBookmarked
                                          ? Colors.red
                                          : (isDark ? Colors.white38 : Colors.grey),
                                    ),
                                    onPressed: () {
                                      bookmarks.toggle(item.id);
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
