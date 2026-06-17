import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/veda.dart';

// Top-level parse functions for compute isolates to run on a background thread
List<RigMandala> _parseRigvedaData(String jsonStr) {
  final List<dynamic> decoded = json.decode(jsonStr);
  return decoded.map((item) => RigMandala.fromJson(Map<String, dynamic>.from(item))).toList();
}

List<VedaBook> _parseYajurvedaData(String jsonStr) {
  final List<dynamic> decoded = json.decode(jsonStr);
  return decoded.map((item) => VedaBook.fromJson(Map<String, dynamic>.from(item))).toList();
}

class VedaService extends ChangeNotifier {
  List<RigMandala> _rigveda = [];
  List<VedaBook> _yajurveda = []; // Krishna Yajurveda
  List<VedaBook> _shuklaYajurveda = [];
  List<VedaBook> _samaveda = [];
  List<VedaBook> _atharvaveda = [];
  List<RigAshtaka> _rigAshtakas = [];
  
  bool _isRigvedaLoading = false;
  bool _isYajurvedaLoading = false;
  bool _isShuklaYajurvedaLoading = false;
  bool _isSamavedaLoading = false;
  bool _isAtharvavedaLoading = false;
  
  bool _isRigvedaLoaded = false;
  bool _isYajurvedaLoaded = false;
  bool _isShuklaYajurvedaLoaded = false;
  bool _isSamavedaLoaded = false;
  bool _isAtharvavedaLoaded = false;
  bool _isAshtakaBuilt = false;

  List<RigMandala> get rigveda => _rigveda;
  List<VedaBook> get yajurveda => _yajurveda;
  List<VedaBook> get shuklaYajurveda => _shuklaYajurveda;
  List<VedaBook> get samaveda => _samaveda;
  List<VedaBook> get atharvaveda => _atharvaveda;
  List<RigAshtaka> get rigAshtakas => _rigAshtakas;
  
  bool get isRigvedaLoading => _isRigvedaLoading;
  bool get isYajurvedaLoading => _isYajurvedaLoading;
  bool get isShuklaYajurvedaLoading => _isShuklaYajurvedaLoading;
  bool get isSamavedaLoading => _isSamavedaLoading;
  bool get isAtharvavedaLoading => _isAtharvavedaLoading;
  
  bool get isRigvedaLoaded => _isRigvedaLoaded;
  bool get isYajurvedaLoaded => _isYajurvedaLoaded;
  bool get isShuklaYajurvedaLoaded => _isShuklaYajurvedaLoaded;
  bool get isSamavedaLoaded => _isSamavedaLoaded;
  bool get isAtharvavedaLoaded => _isAtharvavedaLoaded;

  Future<void> loadRigveda() async {
    if (_isRigvedaLoaded || _isRigvedaLoading) return;
    
    _isRigvedaLoading = true;
    notifyListeners();
    
    try {
      debugPrint('⌛ Starting async load of Rigveda JSON...');
      final jsonStr = await rootBundle.loadString('assets/data/rigveda_data.json');
      
      // Compute runs the parsing on a background thread, preventing UI jank
      _rigveda = await compute(_parseRigvedaData, jsonStr);
      
      // Build the Ashtaka hierarchical structure from the parsed numbering fields
      _buildAshtakaStructure();
      
      _isRigvedaLoaded = true;
      debugPrint('✅ Loaded ${_rigveda.length} Rigveda Mandalas successfully!');
    } catch (e) {
      debugPrint('❌ Error loading Rigveda JSON: $e');
    } finally {
      _isRigvedaLoading = false;
      notifyListeners();
    }
  }

  void _buildAshtakaStructure() {
    if (_isAshtakaBuilt) return;
    
    try {
      // Map format: Ashtaka -> Adhyaya -> Varga -> List<RigMantra>
      final Map<int, Map<int, Map<int, List<RigMantra>>>> temp = {};
      
      for (final mandala in _rigveda) {
        for (final sukta in mandala.suktas) {
          for (final mantra in sukta.mantras) {
            // numbering format: {1/9}{1.1.1}{1.1.1.1}{1.1.1.1}{1, 1, 1}
            // Brackets index 3 contains the Ashtaka coordinate (e.g. {1.1.1.1})
            final reg = RegExp(r'\{([^\}]+)\}');
            final matches = reg.allMatches(mantra.numbering).toList();
            if (matches.length >= 4) {
              final coordStr = matches[3].group(1) ?? '';
              final parts = coordStr.split('.');
              if (parts.length == 4) {
                final aNum = int.tryParse(parts[0]);
                final adNum = int.tryParse(parts[1]);
                final vNum = int.tryParse(parts[2]);
                if (aNum != null && adNum != null && vNum != null) {
                  temp.putIfAbsent(aNum, () => {});
                  temp[aNum]!.putIfAbsent(adNum, () => {});
                  temp[aNum]![adNum]!.putIfAbsent(vNum, () => []);
                  temp[aNum]![adNum]![vNum]!.add(mantra);
                }
              }
            }
          }
        }
      }
      
      _rigAshtakas = [];
      final sortedANums = temp.keys.toList()..sort();
      for (final aNum in sortedANums) {
        final adhyayasList = <RigAdhyaya>[];
        final sortedAdNums = temp[aNum]!.keys.toList()..sort();
        for (final adNum in sortedAdNums) {
          final vargasList = <RigVarga>[];
          final sortedVNums = temp[aNum]![adNum]!.keys.toList()..sort();
          for (final vNum in sortedVNums) {
            final mantras = temp[aNum]![adNum]![vNum]!;
            vargasList.add(RigVarga(number: vNum, mantras: mantras));
          }
          adhyayasList.add(RigAdhyaya(number: adNum, vargas: vargasList));
        }
        _rigAshtakas.add(RigAshtaka(number: aNum, adhyayas: adhyayasList));
      }
      
      _isAshtakaBuilt = true;
      debugPrint('⭐ Successfully built ${_rigAshtakas.length} Rigveda Ashtakas in memory!');
    } catch (e) {
      debugPrint('❌ Error building Ashtaka structure: $e');
    }
  }

  Future<void> loadYajurveda() async {
    if (_isYajurvedaLoaded || _isYajurvedaLoading) return;
    
    _isYajurvedaLoading = true;
    notifyListeners();
    
    try {
      debugPrint('⌛ Starting async load of Krishna Yajurveda JSON...');
      final jsonStr = await rootBundle.loadString('assets/data/yajurveda_data.json');
      
      _yajurveda = await compute(_parseYajurvedaData, jsonStr);
      _isYajurvedaLoaded = true;
      debugPrint('✅ Loaded ${_yajurveda.length} Krishna Yajurveda Books successfully!');
    } catch (e) {
      debugPrint('❌ Error loading Krishna Yajurveda JSON: $e');
    } finally {
      _isYajurvedaLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadShuklaYajurveda() async {
    if (_isShuklaYajurvedaLoaded || _isShuklaYajurvedaLoading) return;
    
    _isShuklaYajurvedaLoading = true;
    notifyListeners();
    
    try {
      debugPrint('⌛ Starting async load of Shukla Yajurveda JSON...');
      final jsonStr = await rootBundle.loadString('assets/data/shukla_yajurveda_data.json');
      
      _shuklaYajurveda = await compute(_parseYajurvedaData, jsonStr);
      _isShuklaYajurvedaLoaded = true;
      debugPrint('✅ Loaded ${_shuklaYajurveda.length} Shukla Yajurveda Books successfully!');
    } catch (e) {
      debugPrint('❌ Error loading Shukla Yajurveda JSON: $e');
    } finally {
      _isShuklaYajurvedaLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSamaveda() async {
    if (_isSamavedaLoaded || _isSamavedaLoading) return;
    
    _isSamavedaLoading = true;
    notifyListeners();
    
    try {
      debugPrint('⌛ Starting async load of Samaveda JSON...');
      final jsonStr = await rootBundle.loadString('assets/data/samaveda_data.json');
      
      _samaveda = await compute(_parseYajurvedaData, jsonStr);
      _isSamavedaLoaded = true;
      debugPrint('✅ Loaded ${_samaveda.length} Samaveda Books successfully!');
    } catch (e) {
      debugPrint('❌ Error loading Samaveda JSON: $e');
    } finally {
      _isSamavedaLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAtharvaveda() async {
    if (_isAtharvavedaLoaded || _isAtharvavedaLoading) return;
    
    _isAtharvavedaLoading = true;
    notifyListeners();
    
    try {
      debugPrint('⌛ Starting async load of Atharvaveda JSON...');
      final jsonStr = await rootBundle.loadString('assets/data/atharvaveda_data.json');
      
      _atharvaveda = await compute(_parseYajurvedaData, jsonStr);
      _isAtharvavedaLoaded = true;
      debugPrint('✅ Loaded ${_atharvaveda.length} Atharvaveda Books successfully!');
    } catch (e) {
      debugPrint('❌ Error loading Atharvaveda JSON: $e');
    } finally {
      _isAtharvavedaLoading = false;
      notifyListeners();
    }
  }
}
