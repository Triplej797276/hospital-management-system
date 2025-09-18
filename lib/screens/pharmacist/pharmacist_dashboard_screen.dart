import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';

import '../../controllers/pharmacist/language_controller.dart';

class PharmacistDashboardScreen extends StatelessWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final LanguageController langController = Get.put(LanguageController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = authController.user.value;
          final userName = user?.displayName ?? user?.email ?? 'Pharmacist';
          return Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 8),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          );
        }),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          Obx(() => DropdownButton<Language>(
                value: langController.selectedLanguage.value,
                dropdownColor: Colors.blue[800],
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[800]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.medical_services, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                        langController.getText(
                            en: 'Pharmacist Portal',
                            mr: 'फार्मासिस्ट पोर्टल',
                            hi: 'फार्मासिस्ट पोर्टल'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Obx(() => Text(
                        langController.getText(
                            en: 'Hospital Management System',
                            mr: 'रुग्णालय व्यवस्थापन प्रणाली',
                            hi: 'अस्पताल प्रबंधन प्रणाली'),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      )),
                ],
              ),
            ),
            Obx(() => _buildDrawerItem(
                  icon: Icons.category,
                  title: langController.getText(
                      en: 'Medicine Categories',
                      mr: 'औषध श्रेण्या',
                      hi: 'दवाइयों की श्रेणियाँ'),
                  onTap: () => Get.toNamed('/pharmacist/medicine-categories'),
                )),
            Obx(() => _buildDrawerItem(
                  icon: Icons.medical_services,
                  title: langController.getText(
                      en: 'Medicines', mr: 'औषधे', hi: 'दवाइयाँ'),
                  onTap: () => Get.toNamed('/pharmacist/medicines'),
                )),
            Obx(() => _buildDrawerItem(
                  icon: Icons.receipt,
                  title: langController.getText(
                      en: 'Medicine Bills', mr: 'औषध बिल', hi: 'दवा बिल'),
                  onTap: () => Get.toNamed('/pharmacist/medicine-bills'),
                )),
            Obx(() => _buildDrawerItem(
                  icon: Icons.announcement,
                  title: langController.getText(en: 'Notices', mr: 'सूचना', hi: 'सूचनाएँ'),
                  onTap: () => Get.toNamed('/notices'),
                )),
            Obx(() => _buildDrawerItem(
                  icon: Icons.person,
                  title: langController.getText(en: 'Profile', mr: 'प्रोफाइल', hi: 'प्रोफ़ाइल'),
                  onTap: () => Get.toNamed('/pharmacist/profile'),
                )),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[300]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.medical_services, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => Text(
                            langController.getText(
                                en: 'Welcome to the Pharmacist Portal',
                                mr: 'फार्मासिस्ट पोर्टल मध्ये आपले स्वागत आहे',
                                hi: 'फार्मासिस्ट पोर्टल में आपका स्वागत है'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(() => GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildDashboardCard(
                          context,
                          title: langController.getText(
                              en: 'Medicine Categories',
                              mr: 'औषध श्रेण्या',
                              hi: 'दवाइयों की श्रेणियाँ'),
                          icon: Icons.category,
                          onTap: () => Get.toNamed('/pharmacist/medicine-categories'),
                        ),
                        _buildDashboardCard(
                          context,
                          title: langController.getText(
                              en: 'Medicines', mr: 'औषधे', hi: 'दवाइयाँ'),
                          icon: Icons.medical_services,
                          onTap: () => Get.toNamed('/pharmacist/medicines'),
                        ),
                        _buildDashboardCard(
                          context,
                          title: langController.getText(
                              en: 'Medicine Bills', mr: 'औषध बिल', hi: 'दवा बिल'),
                          icon: Icons.receipt,
                          onTap: () => Get.toNamed('/pharmacist/medicine-bills'),
                        ),
                        _buildDashboardCard(
                          context,
                          title: langController.getText(
                              en: 'Notices', mr: 'सूचना', hi: 'सूचनाएँ'),
                          icon: Icons.announcement,
                          onTap: () => Get.toNamed('/notices'),
                        ),
                        _buildDashboardCard(
                          context,
                          title: langController.getText(
                              en: 'Profile', mr: 'प्रोफाइल', hi: 'प्रोफ़ाइल'),
                          icon: Icons.person,
                          onTap: () => Get.toNamed('/pharmacist/profile'),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.blue[800]),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.blue[800],
        ),
      ),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
