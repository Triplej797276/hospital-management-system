import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/services_management_controller.dart';

class ServicesManagementScreen extends StatelessWidget {
  const ServicesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServicesManagementController());
    final primaryColor = Colors.blueAccent;
    final backgroundColor = Colors.blue[50];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Services Management'),
        backgroundColor: primaryColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final service = controller.services[index];
              final title = service['title'] as String;
              final route = service['route'] as String;
              final icon = service['icon'] as IconData;

              return GestureDetector(
                onTap: () => Get.toNamed(route),
                child: Card(
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 44,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
