import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/laboratorists/laboratorist_dashboard_controller.dart';
import '../../controllers/pharmacist/language_controller.dart';

class LaboratoristDashboardScreen extends StatelessWidget {
  const LaboratoristDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LaboratoristDashboardController());
    final langController = controller.langController;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              langController.getText(
                  en: 'Laboratorist Dashboard',
                  mr: 'प्रयोगशाळा कर्मचारी डॅशबोर्ड',
                  hi: 'प्रयोगशाला कर्मचारी डैशबोर्ड'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.teal,
        actions: [
          Obx(() => DropdownButton<Language>(
                value: langController.selectedLanguage.value,
                dropdownColor: Colors.teal,
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
      drawer: Drawer(
        child: Obx(() => ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.teal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.teal),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        langController.getText(
                            en: 'Laboratorist',
                            mr: 'प्रयोगशाळा कर्मचारी',
                            hi: 'प्रयोगशाला कर्मचारी'),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'laboratorist@example.com',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                ...controller.menuItems.map((item) => ListTile(
                      leading: Icon(item['icon'] as IconData, color: Colors.teal),
                      title: Text(controller.getTitle(item['key'] as String)),
                      onTap: () {
                        controller.navigateTo(item['route'] as String);
                        Get.back();
                      },
                    )),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.teal),
                  title: Text(langController.getText(
                      en: 'Sign Out', mr: 'साइन आउट', hi: 'साइन आउट')),
                  onTap: controller.signOut,
                ),
              ],
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langController.getText(
                      en: 'Welcome, Laboratorist!',
                      mr: 'स्वागत आहे, प्रयोगशाळा कर्मचारी!',
                      hi: 'स्वागत है, प्रयोगशाला कर्मचारी!'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: controller.menuItems.map((item) {
                      return _buildDashboardCard(
                        context,
                        icon: item['icon'] as IconData,
                        title: controller.getTitle(item['key'] as String),
                        subtitle: controller.getSubtitle(item['key'] as String),
                        onTap: () => controller.navigateTo(item['route'] as String),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.langController.getText(
                              en: 'Recent Notice',
                              mr: 'अलीकडील सूचना',
                              hi: 'हाल की सूचना'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        const SizedBox(height: 10),
                        Text(controller.getRecentNotice(),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 40, color: Colors.teal),
            const SizedBox(height: 10),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade600)),
          ]),
        ),
      ),
    );
  }
}
