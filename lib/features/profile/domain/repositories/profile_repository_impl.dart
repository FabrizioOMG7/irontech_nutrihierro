import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementación concreta del contrato de perfiles usando Firebase Firestore.
class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepositoryImpl({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Colección principal en Firebase (podría estar anidada bajo el ID del usuario en el futuro)
  CollectionReference get _childrenCollection => 
      _firestore.collection('children');

  @override
  Future<void> saveChild(Child child) async {
    try {
      // 1. Convertimos la Entidad (Dart puro) a JSON (Formato de base de datos)
      final childData = {
        'id': child.id,
        'name': child.name,
        // Guardamos la fecha como un Timestamp de Firebase
        'birthDate': Timestamp.fromDate(child.birthDate), 
        'gender': child.gender.name, // Guarda 'male' o 'female' como texto
      };

      // 2. Guardamos o actualizamos en Firestore
      // Si el documento con ese ID ya existe, lo sobrescribe; si no, lo crea.
      await _childrenCollection.doc(child.id).set(childData);
    } catch (e) {
      // En una app real, aquí enviaríamos el error a un servicio de monitoreo (ej. Crashlytics)
      throw Exception('Error al guardar el perfil: $e');
    }
  }

  @override
  Future<List<Child>> getChildren() async {
    try {
      final snapshot = await _childrenCollection.get();
      
      // 3. Convertimos los JSON (Base de datos) de vuelta a Entidades (Dart puro)
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        return Child(
          id: data['id'],
          name: data['name'],
          // Convertimos el Timestamp de Firebase de vuelta a DateTime de Dart
          birthDate: (data['birthDate'] as Timestamp).toDate(),
          // Convertimos el texto ('male'/'female') de vuelta al Enum
          gender: Gender.values.firstWhere((e) => e.name == data['gender']),
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar los perfiles: $e');
    }
  }

  @override
  Future<void> deleteChild(String id) async {
    try {
      await _childrenCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar el perfil: $e');
    }
  }
}