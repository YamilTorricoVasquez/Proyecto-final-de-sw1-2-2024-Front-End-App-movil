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
