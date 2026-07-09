import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../../core/services/network/user_provider.dart';
import '../../widgets/profile_page_app_bar.dart';
import '../profile/my_profile_page.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  static const primary = Color(0xff015093);

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserProfile().then((_) {
      _loadUserDataFromProvider();
    });
  }

  void _loadUserDataFromProvider() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data = userProvider.userData;

    if (data != null) {
      setState(() {
        nameController.text = data['name'] ?? 'Guest';
        emailController.text = data['email'] ?? 'guest@gmail.com';
        numberController.text = data['phone'] ?? '';
        addressController.text = data['address'] ?? '';

        String rawDob = data['dob'] ?? '';
        if (rawDob.isNotEmpty) {
          dobController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(rawDob));
          selectedDate = DateTime.parse(rawDob);
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty")),
      );
      return;
    }

    bool success = await userProvider.updateUserProfile(
      name: nameController.text.trim(),
      phone: numberController.text.trim(),
      dob: dobController.text.trim(),
      address: addressController.text.trim(),
      imageFile: _image,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile updated successfully")),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyProfilePage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to update profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth > 400 ? 140.0 : screenWidth * 0.4;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DrivestAppBar(title: "Edit Profile"),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          String? profileImageUrlRaw = userProvider.userData?['image'];
          final profileImageUrl = (profileImageUrlRaw != null && profileImageUrlRaw.isNotEmpty)
              ? (profileImageUrlRaw.startsWith('http')
              ? profileImageUrlRaw
              : 'https://yourserver.com/$profileImageUrlRaw')
              : null;

          // default asset path (change if your asset filename/path different)
          const String defaultAssetPath = 'assets/images/profile_img.jpg';

          return SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Avatar as a decorated container with DecorationImage (ensures full cover)
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300], // background color behind image
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _image != null
                                ? FileImage(_image!) as ImageProvider
                                : (profileImageUrl != null
                                ? NetworkImage(profileImageUrl)
                                : const AssetImage(defaultAssetPath) as ImageProvider),
                          ),
                        ),
                      ),

                      // Photo badge
                      Builder(builder: (context) {
                        final double badgeSize = imageSize * 0.30;
                        final double innerPadding = 4.0;
                        final double iconSize = (badgeSize - innerPadding * 2) * 0.6;

                        return Positioned(
                          right: -(badgeSize * 0.08),
                          bottom: -(badgeSize * 0.08),
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: badgeSize,
                              height: badgeSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.all(innerPadding),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primary,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      size: iconSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                SizedBox(height: imageSize * 0.15),
                _buildTextField('Full Name', nameController),
                const SizedBox(height: 20),
                _buildDateField('Date of Birth', dobController),
                const SizedBox(height: 20),
                _buildTextField('Email', emailController, enabled: false),
                const SizedBox(height: 20),
                _buildTextField('Phone Number', numberController, keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                _buildTextField('Address', addressController, maxLines: 2),
                SizedBox(height: screenWidth > 400 ? 40 : 30),
                SizedBox(
                  width: double.infinity,
                  height: screenWidth > 400 ? 60 : 56,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 8,
                      shadowColor: primary.withOpacity(.35),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: screenWidth > 400 ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Select $label',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
        ),
      ],
    );
  }
}
