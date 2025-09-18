import 'package:get/get.dart';

// Document Model
class Document {
  String id;
  String title;
  String content;
  DateTime createdAt;
  String? imageUrl;

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
        imageUrl: 'https://example.com/sample-image.jpg',
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