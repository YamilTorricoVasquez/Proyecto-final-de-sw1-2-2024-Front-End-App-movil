import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<void> seleccionarYGuardarImagen(int idBebe) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final File image = File(pickedFile.path);

    // Obtiene el directorio donde se guardarán las imágenes
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$idBebe.jpg';

    // Guarda la imagen con el id_bebe como nombre
    await image.copy(path);

    print('Imagen guardada en: $path');
  } else {
    print('No se seleccionó ninguna imagen');
  }
}
