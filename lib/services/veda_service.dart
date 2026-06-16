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
  List<VedaBook> _yajurveda = [];
  
  bool _isRigvedaLoading = false;
  bool _isYajurvedaLoading = false;
  
  bool _isRigvedaLoaded = false;
  bool _isYajurvedaLoaded = false;

  List<RigMandala> get rigveda => _rigveda;
  List<VedaBook> get yajurveda => _yajurveda;
  
  bool get isRigvedaLoading => _isRigvedaLoading;
  bool get isYajurvedaLoading => _isYajurvedaLoading;
  
  bool get isRigvedaLoaded => _isRigvedaLoaded;
  bool get isYajurvedaLoaded => _isYajurvedaLoaded;

  Future<void> loadRigveda() async {
    if (_isRigvedaLoaded || _isRigvedaLoading) return;
    
    _isRigvedaLoading = true;
    notifyListeners();
    
    try {
      debugPrint('⌛ Starting async load of Rigveda JSON...');
      final jsonStr = await rootBundle.loadString('assets/data/rigveda_data.json');
      
      // Compute runs the parsing on a background thread, preventing UI jank
      _rigveda = await compute(_parseRigvedaData, jsonStr);
      _isRigvedaLoaded = true;
      debugPrint('✅ Loaded ${_rigveda.length} Rigveda Mandalas successfully!');
    } catch (e) {
      debugPrint('❌ Error loading Rigveda JSON: $e');
    } finally {
      _isRigvedaLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadYajurveda() async {
    if (_isYajurvedaLoaded || _isYajurvedaLoading) return;
    
    _isYajurvedaLoading = true;
    notifyListeners();
    
    try {
      debugPrint('⌛ Starting async load of Yajurveda JSON...');
      final jsonStr = await rootBundle.loadString('assets/data/yajurveda_data.json');
      
      _yajurveda = await compute(_parseYajurvedaData, jsonStr);
      _isYajurvedaLoaded = true;
      debugPrint('✅ Loaded ${_yajurveda.length} Yajurveda Books successfully!');
    } catch (e) {
      debugPrint('❌ Error loading Yajurveda JSON: $e');
    } finally {
      _isYajurvedaLoading = false;
      notifyListeners();
    }
  }
}
