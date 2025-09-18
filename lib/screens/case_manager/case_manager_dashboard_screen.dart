import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/case_manager/case_manager_dashboard_screen.dart';
import 'package:hsmproject/controllers/pharmacist/language_controller.dart';

class CaseManagerDashboardScreen extends StatelessWidget {
  const CaseManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.put(LanguageController());
    final controller = Get.put(CaseManagerDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              langController.getText(
                en: 'Case Manager Dashboard',
                mr: 'केस मॅनेजर डॅशबोर्ड',
                hi: 'केस मैनेजर डैशबोर्ड',
              ),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.blue[800],
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
            onPressed: controller.signOut,
          ),
        ],
      ),
      drawer: Obx(() => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue[800]),
                  child: Text(
                    langController.getText(en: 'Menu', mr: 'मेनू', hi: 'मेन्यू'),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.person_add,
                  title: langController.getText(en: 'Patient Admissions', mr: 'रुग्ण प्रवेश', hi: 'मरीज प्रवेश'),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/patient_admissions');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.medical_services,
                  title: langController.getText(en: 'Patient Cases', mr: 'रुग्ण प्रकरणे', hi: 'मरीज मामले'),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/patient_cases');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.local_hospital,
                  title: langController.getText(en: 'Ambulance Management', mr: 'अॅम्ब्युलन्स व्यवस्थापन', hi: 'एम्बुलेंस प्रबंधन'),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/ambulance_management');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.mail,
                  title: langController.getText(en: 'Mail Service', mr: 'मेल सेवा', hi: 'मेल सेवा'),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/mail_service');
                  },
                ),
              ],
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langController.getText(
                      en: 'Welcome, ${controller.currentUser?.email ?? 'Case Manager'}',
                      mr: 'स्वागत आहे, ${controller.currentUser?.email ?? 'केस मॅनेजर'}',
                      hi: 'स्वागत है, ${controller.currentUser?.email ?? 'केस मैनेजर'}',
                    ),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    langController.getText(en: 'Quick Actions', mr: 'त्वरित क्रिया', hi: 'त्वरित क्रियाएँ'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildActionCard(
                        icon: Icons.person_add,
                        title: langController.getText(en: 'Patient Admissions', mr: 'रुग्ण प्रवेश', hi: 'मरीज प्रवेश'),
                        color: Colors.blue[700]!,
                        onTap: () => Get.toNamed('/patient_admissions'),
                      ),
                      _buildActionCard(
                        icon: Icons.medical_services,
                        title: langController.getText(en: 'Patient Cases', mr: 'रुग्ण प्रकरणे', hi: 'मरीज मामले'),
                        color: Colors.green[700]!,
                        onTap: () => Get.toNamed('/patient_cases'),
                      ),
                      _buildActionCard(
                        icon: Icons.local_hospital,
                        title: langController.getText(en: 'Ambulance Management', mr: 'अॅम्ब्युलन्स व्यवस्थापन', hi: 'एम्बुलेंस प्रबंधन'),
                        color: Colors.red[700]!,
                        onTap: () => Get.toNamed('/ambulance_management'),
                      ),
                      _buildActionCard(
                        icon: Icons.mail,
                        title: langController.getText(en: 'Mail Service', mr: 'मेल सेवा', hi: 'मेल सेवा'),
                        color: Colors.purple[700]!,
                        onTap: () => Get.toNamed('/mail_service'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    langController.getText(en: 'Latest Notices', mr: 'अलीकडील सूचना', hi: 'नवीन नोटिस'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.getLatestNotices().length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.announcement, color: Colors.blue),
                          title: Text(controller.getLatestNotices()[index], style: const TextStyle(fontSize: 14)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildActionCard({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ),
      ),
    );
  }
}
