import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementación concreta del contrato de perfiles usando Firebase Firestore.
class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _childrenCollection =>
      _firestore.collection('children');

  @override
  Future<void> saveChild(Child child) async {
    try {
      final childData = {
        'id': child.id,
        'name': child.name,
        'birthDate': Timestamp.fromDate(child.birthDate),
        'gender': child.gender.name,
      };

      await _childrenCollection.doc(child.id).set(childData);
    } catch (e) {
      throw Exception('Error al guardar el perfil: $e');
    }
  }

  @override
  Future<List<Child>> getChildren() async {
    try {
      final snapshot = await _childrenCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Child(
          id: data['id'],
          name: data['name'],
          birthDate: (data['birthDate'] as Timestamp).toDate(),
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
