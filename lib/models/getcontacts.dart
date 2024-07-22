import 'package:permission_handler/permission_handler.dart';

Future<void> requestContactPermission() async {
  var status = await Permission.contacts.status;

  if (!status.isGranted) {
    // İzin verilmemişse, izin iste
    if (await Permission.contacts.request().isGranted) {
      // İzin verildi, kişiler alınabilir
    } else {
      // İzin verilmedi, uygun bir mesaj göster
      print("Kişi erişim izni verilmedi");
    }
  } else {
    // İzin zaten verilmiş
    print("Kişi erişim izni zaten verilmiş");
  }
}
