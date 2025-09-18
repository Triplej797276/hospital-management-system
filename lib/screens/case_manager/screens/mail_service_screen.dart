import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/case_manager/mail_service_controller.dart';


class MailServiceScreen extends StatefulWidget {
  const MailServiceScreen({super.key});

  @override
  State<MailServiceScreen> createState() => _MailServiceScreenState();
}

class _MailServiceScreenState extends State<MailServiceScreen> {
  final MailServiceController controller = Get.put(MailServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mail Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Mail Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.sendMail();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[700],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Send New Mail',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recent Mails',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.recentMails.length,
                        itemBuilder: (context, index) {
                          final mail = controller.recentMails[index];
                          final mailId = mail['id'] as String? ?? 'Unknown';
                          final mailTitle = mail['title'] as String? ?? 'Unknown';
                          final sentDate = mail['sentDate'] as String? ?? 'Unknown';
                          return ListTile(
                            leading: const Icon(Icons.mail, color: Colors.purple),
                            title: Text(mailTitle),
                            subtitle: Text('Sent on: $sentDate'),
                            trailing: IconButton(
                              icon: const Icon(Icons.info, color: Colors.purple),
                              onPressed: () {
                                controller.showMailDetails(mailId);
                              },
                            ),
                          );
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}