import 'package:shared_preferences/shared_preferences.dart';

class BabyIdsStorage {
  static Future<void> saveBabyIds(List<int> babyIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'baby_ids', babyIds.map((id) => id.toString()).toList());
  }

  static Future<List<int>> getBabyIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList('baby_ids');
    return ids?.map((id) => int.parse(id)).toList() ?? [];
  }
  // Método para vaciar la lista de IDs de bebés
  static Future<void> clearBabyIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('baby_ids'); // Eliminar la lista de baby_ids
    print("Lista de IDs de bebés vaciada.");
  }
}

void addBabyId(int idBebe) async {
  final babyIds = await BabyIdsStorage.getBabyIds();
  print("Baby IDs actuales: $babyIds");
  if (!babyIds.contains(idBebe)) {
    babyIds.add(idBebe);
    await BabyIdsStorage.saveBabyIds(babyIds);
    print("ID $idBebe guardado.");
  } else {
    print("ID $idBebe ya existe.");
  }
}

class ParentIdsStorage {
  // Guardar los CIs de los padres
  static Future<void> saveParentCIs(List<String> parentCIs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'parent_cis', parentCIs); // Guardar los CIs como una lista de Strings
  }

  // Obtener los CIs de los padres
  static Future<List<String>> getParentCIs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? parentCIs = prefs.getStringList('parent_cis');
    return parentCIs ?? []; // Retorna una lista vacía si no hay CIs guardados
  }

  
}

void addParentCI(String parentCI) async {
  final parentCIs = await ParentIdsStorage.getParentCIs();
  print("Parent CIs actuales: $parentCIs");

  if (!parentCIs.contains(parentCI)) {
    parentCIs.add(parentCI);
    await ParentIdsStorage.saveParentCIs(parentCIs);
    print("CI $parentCI guardado.");
  } else {
    print("CI $parentCI ya existe.");
  }
}
