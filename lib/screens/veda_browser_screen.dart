import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/veda_service.dart';
import '../models/veda.dart';
import 'veda_reader_screen.dart';

class VedaBrowserScreen extends StatefulWidget {
  const VedaBrowserScreen({super.key});

  @override
  State<VedaBrowserScreen> createState() => _VedaBrowserScreenState();
}

class _VedaBrowserScreenState extends State<VedaBrowserScreen> {
  String? _selectedVeda; // 'rigveda' or 'yajurveda'
  
  // Navigation stack within the Veda Browser
  // For Rigveda Mandala Method (0): null -> Mandala -> Sukta list
  RigMandala? _activeMandala;
  
  // For Rigveda Ashtaka Method (1): null -> Ashtaka -> Adhyaya -> Varga list
  int _rigvedaBrowseMethod = 0; // 0 = Mandala, 1 = Ashtaka
  RigAshtaka? _activeAshtaka;
  RigAdhyaya? _activeAdhyaya;
  
  // For Yajurveda: null -> Book -> Section -> Prashna list
  VedaBook? _activeBook;
  VedaSection? _activeSection;

  @override
  Widget build(BuildContext context) {
    final vedaService = context.watch<VedaService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _handleBack,
        ),
      ),
      body: _buildBody(vedaService, isDark),
    );
  }

  String _getAppBarTitle() {
    if (_selectedVeda == null) {
      return 'ವೇದ ಗ್ರಂಥಗಳು';
    }
    
    if (_selectedVeda == 'rigveda') {
      if (_rigvedaBrowseMethod == 0) {
        if (_activeMandala == null) {
          return 'ಋಗ್ವೇದ ಸಂಹಿತಾ';
        }
        return _activeMandala!.title;
      } else {
        if (_activeAshtaka == null) {
          return 'ಋಗ್ವೇದ (ಅಷ್ಟಕ ಕ್ರಮ)';
        }
        if (_activeAdhyaya == null) {
          return 'ಅಷ್ಟಕ ${_activeAshtaka!.number}';
        }
        return 'ಅಷ್ಟಕ ${_activeAshtaka!.number} - ಅಧ್ಯಾಯ ${_activeAdhyaya!.number}';
      }
    } else {
      if (_activeBook == null) {
        if (_selectedVeda == 'krishna_yajurveda') return 'ಕೃಷ್ಣ ಯಜುರ್ವೇದ';
        if (_selectedVeda == 'shukla_yajurveda') return 'ಶುಕ್ಲ ಯಜುರ್ವೇದ';
        if (_selectedVeda == 'samaveda') return 'ಸಾಮವೇದ ಸಂಹಿತಾ';
        return 'ಅಥರ್ವವೇದ ಸಂಹಿತಾ';
      }
      if (_activeSection == null) {
        return _activeBook!.title;
      }
      return _activeSection!.title;
    }
  }

  void _handleBack() {
    setState(() {
      if (_selectedVeda == 'rigveda') {
        if (_rigvedaBrowseMethod == 0) {
          if (_activeMandala != null) {
            _activeMandala = null;
          } else {
            _selectedVeda = null;
          }
        } else {
          if (_activeAdhyaya != null) {
            _activeAdhyaya = null;
          } else if (_activeAshtaka != null) {
            _activeAshtaka = null;
          } else {
            _selectedVeda = null;
          }
        }
      } else if (_selectedVeda != null) {
        if (_activeSection != null) {
          if (_activeBook!.sections.length == 1) {
            _activeSection = null;
            _activeBook = null;
          } else {
            _activeSection = null;
          }
        } else if (_activeBook != null) {
          _activeBook = null;
        } else {
          _selectedVeda = null;
        }
      } else {
        Navigator.pop(context);
      }
    });
  }

  Widget _buildBody(VedaService vedaService, bool isDark) {
    if (_selectedVeda == null) {
      return _buildVedaSelectionMenu(isDark);
    }

    if (_selectedVeda == 'rigveda') {
      if (vedaService.isRigvedaLoading) {
        return _buildLoadingState('ಋಗ್ವೇದ ಸಂಹಿತೆಯನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...');
      }
      if (!vedaService.isRigvedaLoaded) {
        return _buildErrorState(() => vedaService.loadRigveda());
      }
      return _buildRigvedaBrowser(vedaService, isDark);
    } else if (_selectedVeda == 'krishna_yajurveda') {
      if (vedaService.isYajurvedaLoading) {
        return _buildLoadingState('ಕೃಷ್ಣ ಯಜುರ್ವೇದವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...');
      }
      if (!vedaService.isYajurvedaLoaded) {
        return _buildErrorState(() => vedaService.loadYajurveda());
      }
      return _buildGenericVedaBrowser(vedaService.yajurveda, isDark, const Color(0xFFC41E3A));
    } else if (_selectedVeda == 'shukla_yajurveda') {
      if (vedaService.isShuklaYajurvedaLoading) {
        return _buildLoadingState('ಶುಕ್ಲ ಯಜುರ್ವೇದವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...');
      }
      if (!vedaService.isShuklaYajurvedaLoaded) {
        return _buildErrorState(() => vedaService.loadShuklaYajurveda());
      }
      return _buildGenericVedaBrowser(vedaService.shuklaYajurveda, isDark, const Color(0xFFF97316));
    } else if (_selectedVeda == 'samaveda') {
      if (vedaService.isSamavedaLoading) {
        return _buildLoadingState('ಸಾಮವೇದವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...');
      }
      if (!vedaService.isSamavedaLoaded) {
        return _buildErrorState(() => vedaService.loadSamaveda());
      }
      return _buildGenericVedaBrowser(vedaService.samaveda, isDark, const Color(0xFF0EA5E9));
    } else { // 'atharvaveda'
      if (vedaService.isAtharvavedaLoading) {
        return _buildLoadingState('ಅಥರ್ವವೇದವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...');
      }
      if (!vedaService.isAtharvavedaLoaded) {
        return _buildErrorState(() => vedaService.loadAtharvaveda());
      }
      return _buildGenericVedaBrowser(vedaService.atharvaveda, isDark, const Color(0xFF22C55E));
    }
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildErrorState(VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ಮಾಹಿತಿ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗುತ್ತಿಲ್ಲ.', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ'),
          ),
        ],
      ),
    );
  }

  Widget _buildVedaSelectionMenu(bool isDark) {
    final vedaService = context.read<VedaService>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 10),
        const Text(
          'ವೇದ ಸಂಹಿತಾ ಹಾಗೂ ಮಂತ್ರಗಳು',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'ಸ್ವರ ಸಹಿತ ಹಾಗೂ ಪದಪಾಠ ಸಹಿತ ವೈದಿಕ ಮಂತ್ರಗಳು',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        
        // Rigveda Card
        _buildVedaSelectionCard(
          title: 'ಋಗ್ವೇದ ಸಂಹಿತಾ',
          subtitle: 'ಸ್ವರ ಸಹಿತ ಹಾಗೂ ಪದಪಾಠ ಸಹಿತ (೧೦ ಮಂಡಲಗಳು)',
          icon: '🕉️',
          gradient: const [Color(0xFFE8722A), Color(0xFFD4A843)],
          onTap: () {
            setState(() => _selectedVeda = 'rigveda');
            vedaService.loadRigveda();
          },
        ),
        const SizedBox(height: 16),
        
        // Krishna Yajurveda Card
        _buildVedaSelectionCard(
          title: 'ಕೃಷ್ಣ ಯಜುರ್ವೇದ',
          subtitle: 'ತೈತ್ತಿರೀಯ ಸಂಹಿತಾ, ಬ್ರಾಹ್ಮಣ, ಆರಣ್ಯಕ ಮತ್ತು ಏಕಾಗ್ನಿ ಕಾಂಡ',
          icon: '🔥',
          gradient: const [Color(0xFF8B1A2B), Color(0xFFC41E3A)],
          onTap: () {
            setState(() => _selectedVeda = 'krishna_yajurveda');
            vedaService.loadYajurveda();
          },
        ),
        const SizedBox(height: 16),

        // Shukla Yajurveda Card
        _buildVedaSelectionCard(
          title: 'ಶುಕ್ಲ ಯಜುರ್ವೇದ',
          subtitle: 'ಮಾಧ್ಯನ್ದಿನ ಸಂಹಿತಾ (೪೦ ಅಧ್ಯಾಯಗಳು)',
          icon: '☀️',
          gradient: const [Color(0xFFC2410C), Color(0xFFF97316)],
          onTap: () {
            setState(() => _selectedVeda = 'shukla_yajurveda');
            vedaService.loadShuklaYajurveda();
          },
        ),
        const SizedBox(height: 16),

        // Samaveda Card
        _buildVedaSelectionCard(
          title: 'ಸಾಮವೇದ ಸಂಹಿತಾ',
          subtitle: 'ಕೌಥುಮ ಶಾಖಾ (ಪೂರ್ವಾರ್ಚಿಕ ಮತ್ತು ಉತ್ತರಾರ್ಚಿಕ)',
          icon: '🎵',
          gradient: const [Color(0xFF0369A1), Color(0xFF0EA5E9)],
          onTap: () {
            setState(() => _selectedVeda = 'samaveda');
            vedaService.loadSamaveda();
          },
        ),
        const SizedBox(height: 16),

        // Atharvaveda Card
        _buildVedaSelectionCard(
          title: 'ಅಥರ್ವವೇದ ಸಂಹಿತಾ',
          subtitle: 'ಶೌನಕ ಶಾಖಾ (೨೦ ಕಾಂಡಗಳು)',
          icon: '🌿',
          gradient: const [Color(0xFF15803D), Color(0xFF22C55E)],
          onTap: () {
            setState(() => _selectedVeda = 'atharvaveda');
            vedaService.loadAtharvaveda();
          },
        ),
      ],
    );
  }

  Widget _buildVedaSelectionCard({
    required String title,
    required String subtitle,
    required String icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.black38,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== RIGVEDA BROWSER =====================
  Widget _buildMethodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: SegmentedButton<int>(
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(
              value: 0,
              label: Text('ಮಂಡಲ ಕ್ರಮ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            ButtonSegment<int>(
              value: 1,
              label: Text('ಅಷ್ಟಕ ಕ್ರಮ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
          selected: <int>{_rigvedaBrowseMethod},
          onSelectionChanged: (Set<int> newSelection) {
            setState(() {
              _rigvedaBrowseMethod = newSelection.first;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRigvedaBrowser(VedaService vedaService, bool isDark) {
    if (_rigvedaBrowseMethod == 0) {
      if (_activeMandala == null) {
        // List Mandalas
        return Column(
          children: [
            _buildMethodSelector(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: vedaService.rigveda.length,
                itemBuilder: (context, index) {
                  final mandala = vedaService.rigveda[index];
                  return Card(
                    elevation: 2,
                    color: isDark ? const Color(0xFF1E1635) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => _activeMandala = mandala),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('ॐ', style: TextStyle(fontSize: 22, color: Color(0xFFD4A843))),
                            const SizedBox(height: 8),
                            Text(
                              mandala.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${mandala.suktas.length} ಸೂಕ್ತಗಳು',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        // List Suktas in Active Mandala
        return ListView.builder(
          itemCount: _activeMandala!.suktas.length,
          itemBuilder: (context, index) {
            final sukta = _activeMandala!.suktas[index];
            // Extrapolate index from label, e.g. [1] ಅಗ್ನಿಮೀಳ ...
            final label = sukta.label;
            final match = RegExp(r'^\[(\d+)\]').firstMatch(label);
            final suktaNum = match != null ? match.group(1) : '${index + 1}';
            
            // Clean display text by removing the bracket prefix if present
            final cleanLabel = label.replaceFirst(RegExp(r'^\[\d+\]\s*'), '').trim();

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: isDark ? const Color(0xFF1E1635) : Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE8722A).withOpacity(0.15),
                  child: Text(
                    suktaNum!,
                    style: const TextStyle(
                      color: Color(0xFFE8722A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'ಸೂಕ್ತ $suktaNum',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  cleanLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VedaReaderScreen(
                        title: 'ಋಗ್ವೇದ - ${_activeMandala!.title} - ಸೂಕ್ತ $suktaNum',
                        sukta: sukta,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      }
    } else {
      // Ashtaka Method
      if (_activeAshtaka == null) {
        return Column(
          children: [
            _buildMethodSelector(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: vedaService.rigAshtakas.length,
                itemBuilder: (context, index) {
                  final ashtaka = vedaService.rigAshtakas[index];
                  return Card(
                    elevation: 2,
                    color: isDark ? const Color(0xFF1E1635) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => _activeAshtaka = ashtaka),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('ॐ', style: TextStyle(fontSize: 22, color: Color(0xFFD4A843))),
                            const SizedBox(height: 8),
                            Text(
                              'ಅಷ್ಟಕ ${ashtaka.number}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${ashtaka.adhyayas.length} ಅಧ್ಯಾಯಗಳು',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else if (_activeAdhyaya == null) {
        // List Adhyayas of _activeAshtaka
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: _activeAshtaka!.adhyayas.length,
          itemBuilder: (context, index) {
            final adhyaya = _activeAshtaka!.adhyayas[index];
            return Card(
              elevation: 2,
              color: isDark ? const Color(0xFF1E1635) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _activeAdhyaya = adhyaya),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                      Text(
                        'ಅಧ್ಯಾಯ ${adhyaya.number}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${adhyaya.vargas.length} ವರ್ಗಗಳು',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        // List Vargas of _activeAdhyaya
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: _activeAdhyaya!.vargas.length,
          itemBuilder: (context, index) {
            final varga = _activeAdhyaya!.vargas[index];
            return Card(
              elevation: 1,
              color: isDark ? const Color(0xFF1E1635) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VedaReaderScreen(
                        title: 'ಅಷ್ಟಕ ${_activeAshtaka!.number} - ಅಧ್ಯಾಯ ${_activeAdhyaya!.number} - ವರ್ಗ ${varga.number}',
                        varga: varga,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ವರ್ಗ ${varga.number}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${varga.mantras.length} ಮಂತ್ರಗಳು',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  // ===================== GENERIC VEDA BROWSER =====================
  Widget _buildGenericVedaBrowser(List<VedaBook> books, bool isDark, Color accentColor) {
    if (_activeBook == null) {
      // List Books
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            color: isDark ? const Color(0xFF1E1635) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  _activeBook = book;
                  // If a book has only 1 section, skip Section Selection and go to Chapters directly
                  if (book.sections.length == 1) {
                    _activeSection = book.sections.first;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      _getVedaBookIcon(index),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${book.sections.length} ಭಾಗಗಳು',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: accentColor),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (_activeSection == null) {
      // List Sections in Active Book (e.g. Kandas in Samhita, Ashtakas in Brahmana)
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activeBook!.sections.length,
        itemBuilder: (context, index) {
          final section = _activeBook!.sections[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: isDark ? const Color(0xFF1E1635) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                section.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${section.chapters.length} ಅಧ್ಯಾಯಗಳು/ಪ್ರಶ್ನೆಗಳು/ಸೂಕ್ತಗಳು'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => setState(() => _activeSection = section),
            ),
          );
        },
      );
    } else {
      // List Chapters (Prashnas / Prapathakas / Suktas / Adhyayas) in Active Section
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activeSection!.chapters.length,
        itemBuilder: (context, index) {
          final chapter = _activeSection!.chapters[index];
          
          // Clean the title prefix if it exists to display it nicely
          final cleanTitle = chapter.title.replaceFirst(RegExp(r'^ಸೂಕ್ತ\s*\d+\s*-\s*'), '').trim();

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: isDark ? const Color(0xFF1E1635) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.menu_book_rounded, color: accentColor, size: 20),
              ),
              title: Text(
                cleanTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${chapter.anuvakas.length} ಮಂತ್ರಗಳು/ಅನುವಾಕಗಳು'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VedaReaderScreen(
                      title: '${_activeBook!.title} - $cleanTitle',
                      chapter: chapter,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  String _getVedaBookIcon(int index) {
    switch (index % 4) {
      case 0:
        return '📕';
      case 1:
        return '📙';
      case 2:
        return '📒';
      default:
        return '📗';
    }
  }
}


