import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/notemodel.dart';

class DataService {
  static final DataService _instance = DataService._internal();
 

  factory DataService() {
    return _instance;
  }
  
  
  DataService._internal() {
    
  }

  CollectionReference<Map<String, dynamic>> noteInstance =
      FirebaseFirestore.instance.collection('notes');
  CollectionReference<Map<String, dynamic>> mainTagsInstance =
      FirebaseFirestore.instance.collection('maintag');



     
}
