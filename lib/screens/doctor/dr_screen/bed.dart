import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Bed Model
class Bed {
  String id;
  bool isOccupied;
  String patientId;
  String ward;

  Bed({required this.id, required this.isOccupied, this.patientId = '', required this.ward});
}

// Bed Management Controller
class BedManagementController extends GetxController {
  RxList<Bed> beds = RxList<Bed>([]);

  @override
  void onInit() {
    super.onInit();
    fetchBeds();
  }

  void fetchBeds() {
    // Mock data
    beds.addAll([
      Bed(id: 'B101', isOccupied: false, ward: 'General'),
      Bed(id: 'B102', isOccupied: true, patientId: 'P1', ward: 'ICU'),
    ]);
  }

  void assignBed(String bedId, String patientId) {
    int index = beds.indexWhere((bed) => bed.id == bedId);
    if (index != -1) {
      beds[index].isOccupied = true;
      beds[index].patientId = patientId;
      beds.refresh();
    }
  }

  void unassignBed(String bedId) {
    int index = beds.indexWhere((bed) => bed.id == bedId);
    if (index != -1) {
      beds[index].isOccupied = false;
      beds[index].patientId = '';
      beds.refresh();
    }
  }
}

// Document Model (assuming it's needed based on the provided screen)
class Document {
  String id;
  String title;
  String content;
  DateTime createdAt;

  Document({required this.id, required this.title, required this.content, required this.createdAt});
}

// Documents Controller (assuming it's needed based on the provided screen)
class DocumentsController extends GetxController {
  RxList<Document> documents = RxList<Document>([]);

  void createDocument(Document doc) {
    documents.add(doc);
    documents.refresh();
  }
}

// Bed Management Screen
class BedManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BedManagementController controller = Get.put(BedManagementController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Bed Management'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.beds.length,
        itemBuilder: (context, index) {
          final bed = controller.beds[index];
          return ListTile(
            title: Text('Bed ${bed.id}'),
            subtitle: Text(bed.isOccupied
                ? 'Occupied by Patient ${bed.patientId} in ${bed.ward}'
                : 'Available in ${bed.ward}'),
            trailing: bed.isOccupied
                ? IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => controller.unassignBed(bed.id),
                  )
                : null,
            onTap: bed.isOccupied
                ? null
                : () => controller.assignBed(bed.id, 'P${controller.beds.length + 1}'),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Example: Adding a new bed
          controller.beds.add(Bed(
            id: 'B${controller.beds.length + 101}',
            isOccupied: false,
            ward: 'General',
          ));
          controller.beds.refresh();
        },
      ),
    );
  }
}