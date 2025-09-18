import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/nurse/nurse_dashboard_controller.dart';
import '../../controllers/pharmacist/language_controller.dart';

class NurseDashboardScreen extends StatelessWidget {
  const NurseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NurseDashboardController());
    final langController = controller.langController;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              langController.getText(
                  en: 'Nurse Dashboard',
                  mr: 'नर्स डॅशबोर्ड',
                  hi: 'नर्स डैशबोर्ड'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        backgroundColor: const Color(0xFF0077B6),
        actions: [
          Obx(() => DropdownButton<Language>(
                value: langController.selectedLanguage.value,
                dropdownColor: const Color(0xFF0077B6),
                underline: const SizedBox(),
                icon: const Icon(Icons.language, color: Colors.white),
                items: const [
                  DropdownMenuItem(
                      value: Language.english,
                      child: Text('English', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(
                      value: Language.marathi,
                      child: Text('मराठी', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(
                      value: Language.hindi,
                      child: Text('हिंदी', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (val) {
                  if (val != null) langController.changeLanguage(val);
                },
              )),
          IconButton(icon: const Icon(Icons.logout), onPressed: controller.signOut),
        ],
      ),
      drawer: Obx(() => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF0077B6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        langController.getText(
                            en: 'Nurse Portal', mr: 'नर्स पोर्टल', hi: 'नर्स पोर्टल'),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        langController.getText(
                            en: 'Welcome, Nurse', mr: 'स्वागत आहे, नर्स', hi: 'स्वागत है, नर्स'),
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ...controller.menuItems.map((item) => ListTile(
                      leading: Icon(item['icon'] as IconData, color: const Color(0xFF0077B6)),
                      title: Text(controller.getTitle(item['key'] as String)),
                      onTap: () {
                        controller.navigateTo(item['route'] as String);
                        Get.back();
                      },
                    )),
              ],
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langController.getText(
                      en: 'Welcome, Nurse!', mr: 'स्वागत आहे, नर्स!', hi: 'स्वागत है, नर्स!'),
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF023E8A)),
                ),
                const SizedBox(height: 20),
                Text(
                  langController.getText(
                      en: 'Assigned Tasks', mr: 'संपादित कार्य', hi: 'सौंपे गए कार्य'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF023E8A)),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTaskCard(
                        icon: Icons.favorite,
                        title: langController.getText(
                            en: 'Check Patient Vitals - Room 101',
                            mr: 'रुग्णाची जीवनशैली तपासा - रूम 101',
                            hi: 'मरीज की स्वास्थ्य जांच - कक्ष 101'),
                        subtitle: 'Due: 10:00 AM',
                      ),
                      _buildTaskCard(
                        icon: Icons.medical_services,
                        title: langController.getText(
                            en: 'Administer Medication - Room 102',
                            mr: 'औषध द्या - रूम 102',
                            hi: 'दवा दें - कक्ष 102'),
                        subtitle: 'Due: 11:00 AM',
                      ),
                      _buildTaskCard(
                        icon: Icons.description,
                        title: langController.getText(
                            en: 'Update Patient Chart - Room 103',
                            mr: 'रुग्ण चार्ट अपडेट करा - रूम 103',
                            hi: 'मरीज चार्ट अपडेट करें - कक्ष 103'),
                        subtitle: 'Due: 12:00 PM',
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildTaskCard(
      {required IconData icon, required String title, required String subtitle}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0077B6)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
