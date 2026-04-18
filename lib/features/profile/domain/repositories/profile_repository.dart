import '../child.dart';

/// Contrato que define las operaciones permitidas para los perfiles.
/// La capa de Presentación usará esto sin saber qué base de datos hay detrás.
abstract class ProfileRepository {
  
  /// Guarda o actualiza el perfil de un niño
  Future<void> saveChild(Child child);

  /// Obtiene la lista de todos los niños registrados por el padre
  Future<List<Child>> getChildren();

  /// Elimina un perfil específico usando su ID
  Future<void> deleteChild(String id);
}