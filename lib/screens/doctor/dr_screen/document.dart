import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Document Model
class Document {
  String id;
  String title;
  String content;
  DateTime createdAt;
  String? imageUrl; // Added imageUrl field for storing image path or URL

  Document({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imageUrl,
  });
}

// Documents Controller
class DocumentsController extends GetxController {
  RxList<Document> documents = RxList<Document>([]);

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  void fetchDocuments() {
    // Mock data with sample image URL
    documents.addAll([
      Document(
        id: '1',
        title: 'Patient Consent',
        content: 'Signed form',
        createdAt: DateTime.now(),
        imageUrl: 'https://example.com/sample-image.jpg', // Replace with a real image URL
      ),
    ]);
  }

  void createDocument(Document newDoc) {
    documents.add(newDoc);
    documents.refresh();
  }

  void updateDocument(String id, String title, String content, String? imageUrl) {
    int index = documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      documents[index] = Document(
        id: id,
        title: title,
        content: content,
        createdAt: documents[index].createdAt,
        imageUrl: imageUrl,
      );
      documents.refresh();
    }
  }

  void deleteDocument(String id) {
    documents.removeWhere((doc) => doc.id == id);
    documents.refresh();
  }
}

// Documents Screen
class DocumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DocumentsController controller = Get.put(DocumentsController());
    final ImagePicker _picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: Text('Documents'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.documents.length,
            itemBuilder: (context, index) {
              final doc = controller.documents[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(doc.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.content),
                      if (doc.imageUrl != null && doc.imageUrl!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: doc.imageUrl!.startsWith('http')
                                ? Image.network(
                                    doc.imageUrl!,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Text('Failed to load image'),
                                  )
                                : Image.file(
                                    File(doc.imageUrl!),
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Text('Failed to load image'),
                                  ),
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Edit dialog with image picker
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController titleController =
                                  TextEditingController(text: doc.title);
                              TextEditingController contentController =
                                  TextEditingController(text: doc.content);
                              RxString? imageUrl = doc.imageUrl?.obs;

                              return AlertDialog(
                                title: Text('Edit Document'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: titleController,
                                        decoration:
                                            InputDecoration(labelText: 'Title'),
                                      ),
                                      TextField(
                                        controller: contentController,
                                        decoration:
                                            InputDecoration(labelText: 'Content'),
                                      ),
                                      SizedBox(height: 16),
                                      Obx(() => imageUrl != null && imageUrl.value.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: imageUrl.value.startsWith('http')
                                                  ? Image.network(
                                                      imageUrl.value,
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(imageUrl.value),
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                            )
                                          : Text('No image selected')),
                                      TextButton(
                                        onPressed: () async {
                                          final XFile? image = await _picker
                                              .pickImage(source: ImageSource.gallery);
                                          if (image != null) {
                                            imageUrl?.value = image.path;
                                          }
                                        },
                                        child: Text('Pick Image'),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.updateDocument(
                                        doc.id,
                                        titleController.text,
                                        contentController.text,
                                        imageUrl?.value,
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => controller.deleteDocument(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Create new document dialog
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController contentController = TextEditingController();
              RxString? imageUrl = ''.obs;

              return AlertDialog(
                title: Text('Create Document'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: contentController,
                        decoration: InputDecoration(labelText: 'Content'),
                      ),
                      SizedBox(height: 16),
                      Obx(() => imageUrl != null && imageUrl.value.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(imageUrl.value),
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text('No image selected')),
                      TextButton(
                        onPressed: () async {
                          final XFile? image =
                              await _picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            imageUrl.value = image.path;
                          }
                        },
                        child: Text('Pick Image'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.createDocument(
                        Document(
                          id: '${controller.documents.length + 1}',
                          title: titleController.text.isEmpty
                              ? 'New Doc'
                              : titleController.text,
                          content: contentController.text.isEmpty
                              ? 'Content'
                              : contentController.text,
                          createdAt: DateTime.now(),
                          imageUrl: imageUrl.value,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Create'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}