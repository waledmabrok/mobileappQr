/*
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../ FieldsMachine/setup/MainColors.dart';


class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String token;

  const UserProfileScreen(
      {super.key, required this.userId, required this.token});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? _selectedGender;
  final List<String> _genders = ['male', 'female'];

  bool _isLoading = true;
  bool _hasError = false;
  bool _isUploading = false;

  // double _uploadProgress = 0.0;
  String? _profileImageUrl;
  File? _selectedImage;
  bool _isUpdating = false; // New flag to indicate loading state during update

  @override
  void initState() {
    super.initState();
    _selectedGender = "Male";

    // _fetchUserData();
    _getCachedUserData();
  }

  Future<void> _retryConnection() async {
    final prefs = await SharedPreferences.getInstance();

    //Todo delet token

    _fetchUserData();
    setState(() {});
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            initialIndex: 3,
            token: widget.token,
            userId: widget.userId,
          ),
        ),
            (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _fetchUserData() async {
    const url = Api.USER_INFO;
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };

    // Call the performApiCall function
    await performApiCall(
      url: url,
      method: 'POST',
      bodyData: {'user_id': widget.userId},
      headers: headers,
      parseResponse: true,
      onLoading: () {
        setState(() {
          _isLoading = false; // Show loading indicator
          _hasError = false; // Reset error state
        });
      },
      onSuccess: (data) {
        print('Gender from API: ${data['gender']}');
        print('user from API: ${data}');

        // Handle success when the status code is 200
        setState(() {
          _profileImageUrl = data['profile_image'];
          nameController.text = data['username'];
          phoneController.text = data['phone'];
          emailController.text = data['email'];
          _selectedGender = data['gender'];
          _isLoading = false; // Hide loading indicator
        });
      },
      onError: () {
        // Handle error when the status code is not 200
        setState(() {
          _hasError = true; // Set error state
          _isLoading = false; // Hide loading indicator
        });
        print('Failed to fetch user data: 404 Not Found');
      },
    );
  }

  Future<void> _openGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _uploadProfileImage(); // Call your image upload function
    }
    // Navigator.of(context).pop();
  }

  void _showImageSourceSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            S.of(context).SelectImageSource,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  S.of(context).gallary,
                  style:  TextStyle(
                    fontFamily: 'BalooBhaijaan2',),
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                    _uploadProfileImage();
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(
                  S.of(context).Camera,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',),
                ),
                onTap: () async {
                  final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                    _uploadProfileImage();
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadProfileImage() async {
    if (_selectedImage == null) {
      print('No image selected.');
      return; // Stop the upload if no image is selected
    }

    final url = Uri.parse(Api.USER_ON_UPDATE_IMAGE);
    final headers = {
      'Authorization': 'Bearer ${widget.token ?? ''}',
      // Ensure token is not null
    };

    setState(() {
      _isUploading = true;
    });

    try {
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            _selectedImage!.path, // Use the image file if it exists
          ),
        );

      final response = await request.send();
      final totalBytes = response.contentLength ?? 0;
      int uploadedBytes = 0;

      response.stream.listen(
            (chunk) {
          uploadedBytes += chunk.length;
          final progress = totalBytes > 0 ? uploadedBytes / totalBytes : 0.0;
        },
        onDone: () async {
          setState(() {
            _isUploading = false;
          });

          if (response.statusCode == 200) {
            print('Profile image uploaded successfully');

            await _updateUserData();

            // و shared preferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('userData');
            FocusScope.of(context).unfocus();
            //  loading indicator
            Navigator.pop(context);
            //  ProfilePage
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    initialIndex: 3,
                    token: widget.token,
                    userId: widget.userId,
                  )),
                  (route) => route.isFirst,
            );
          } else if (response.statusCode == 401) {
            // Handle unauthorized response
            print('Unauthorized: Token may be expired or invalid');
            showCustomSnackBar(
              context,
              message:
              S.of(context).endToken, // Replace with your localized message
              backgroundColor: Colors.red,
            );

            // Clear user session and redirect to login
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('saveAth');
            await prefs.remove('userData');
            // Clear cache and all shared preferences

            // Preserve the "onboarding" value temporarily
            String? onboardingValue = prefs.getString("onbarding");

            // Clear all SharedPreferences
            await prefs.clear();

            // Restore the "onboarding" value after clearing preferences
            if (onboardingValue != null) {
              await prefs.setString("onbarding", onboardingValue);
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              // Ensure LoginPage is correctly named
                  (Route<dynamic> route) => false,
            );
          } else {
            print('Failed to upload profile image: $response');
            showCustomSnackBar(
              context,
              message: S.of(context).Failed_to_upload_profile_image,
              // Replace with your localized message
              backgroundColor: Colors.red,
            );
          }
        },
        onError: (error) {
          print('Error uploading profile image: $error');
          setState(() {
            _isUploading = false;
          });
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Error uploading profile image: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _updateUserData() async {
    setState(() {
      _isUpdating = true; // Start showing the loading indicator
    });

    const url = Api.USER_ON_UPDATE;
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };

    final bodyData = {
      'user_id': widget.userId,
      'username': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'gender': _selectedGender,
    };

    await performApiCall(
      url: url,
      method: 'POST',
      headers: headers,
      bodyData: bodyData,
      parseResponse: true,
      onSuccess: (updatedData) async {
        // Handle success (statusCode == 200)
        print('User data updated successfully');

        // Fetch updated user data
        await _fetchUserData();

        // Save the updated data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(updatedData));

        // Cache the updated user data
        await _cacheUserData(updatedData);

        // Update UI or notify the user of success
      },
      onError: () {
        // Handle error, including statusCode == 404
        print('Failed to update user data or encountered an error');
      },
      onLoading: () {
        // Optionally display a loading indicator
        setState(() {
          _isUpdating = true;
        });
      },
    );

    // Stop showing the loading indicator after the call is complete
    setState(() {
      _isUpdating = false;
    });
  }

  Future<void> _getCachedUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('userData');

    if (cachedData != null) {
      setState(() {
        final data = jsonDecode(cachedData);
        _profileImageUrl = data['profile_image'];
        nameController.text = data['username'];
        phoneController.text = data['phone'];
        emailController.text = data['email'];
        _selectedGender = data['gender'];
        _isLoading = false;
      });
    } else {
      await _fetchUserData();
    }
  }

  Future<void> _cacheUserData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //leadingWidth: 35,
          elevation: 0,
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          leading: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: IconButton(
                icon:
                const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: Text(
            S.of(context).yourProfile,
            style:  TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colorss.mainTextColor,
            ),
          ),
        ),
        body: const Center(
            child: CircularProgressIndicator(
              color: Colorss.mainColor,
            )),
      );
    }
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //leadingWidth: 35,
          elevation: 0,
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          leading: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: IconButton(
                icon:
                const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: Text(
            S.of(context).yourProfile,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colorss.mainTextColor,
            ),
          ),
        ),
        body: NoInternetWidget(
          onRetry: () {
            _fetchUserData();
          },
        ),
      );
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            //leadingWidth: 35,
            elevation: 0,
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            leading: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 15),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 22),
                  onPressed: () {
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
            title: Text(
              S.of(context).yourProfile,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colorss.mainTextColor,
              ),
            ),
          ),
          body: WillPopScope(
            onWillPop: () {
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
              return Future.value(true);
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                            border: Border.all(
                                                color: Colorss.mainColor,
                                                width: 2.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(18.0),
                                            child: _selectedImage != null
                                                ? Image.file(
                                              _selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                                : ( // Check if the image URL is valid and not "false" or empty
                                                _profileImageUrl != null &&
                                                    _profileImageUrl!
                                                        .isNotEmpty &&
                                                    _profileImageUrl !=
                                                        "false"
                                                    ? CachedNetworkImage(
                                                  imageUrl:
                                                  _profileImageUrl!,
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      (context,
                                                      url) =>
                                                      Container(),
                                                  errorWidget:
                                                      (context, url,
                                                      error) =>
                                                      Container(),
                                                )
                                                    : Image.asset(
                                                  'assets/images/emptyimage.jpg',
                                                  // Fallback image when URL is invalid
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: _openGallery,
                                            child: const CircleAvatar(
                                              radius: 15.0,
                                              backgroundColor:
                                              Colorss.mainColor,
                                              child: Icon(Icons.edit,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 10 / 932),
                                  Text(
                                    S.of(context).hintNAme,
                                    style: TextStyle(
                                        fontFamily: 'BalooBhaijaan2',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colorss.mainTextColor),
                                  ),
                                  SizedBox(height: size.height * 5 / 932),
                                  customTextFieldUsername(
                                    controller: nameController,
                                    hintText: S.of(context).hintNAme,
                                    maxLength: 15,
                                  ),
                                  SizedBox(height: size.height * 10 / 932),
                                  Text(
                                    S.of(context).hintPhone,
                                    style:  TextStyle(
                                        fontFamily: 'BalooBhaijaan2',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colorss.mainTextColor),
                                  ),
                                  const SizedBox(height: 5),
                                  customTextField_Basic(
                                      context: context,
                                      controller: phoneController,
                                      hintText: S.of(context).hintPhone,
                                      type: TextInputType.number),
                                  SizedBox(height: size.height * 10 / 932),
                                  Text(
                                    S.of(context).hintEm,
                                    style: TextStyle(
                                        fontFamily: 'BalooBhaijaan2',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colorss.mainTextColor),
                                  ),
                                  SizedBox(height: size.height * 5 / 932),
                                  customTextField_Basic(
                                      context: context,
                                      controller: emailController,
                                      hintText: S.of(context).hintEm,
                                      type: TextInputType.emailAddress),
                                  SizedBox(height: size.height * 10 / 932),
                                  Text(
                                    S.of(context).Gender,
                                    style:  TextStyle(
                                        fontFamily: 'BalooBhaijaan2',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colorss.mainTextColor),
                                  ),
                                  SizedBox(height: size.height * 5 / 932),
                                  Column(
                                    children: [
                                      GenderCard(
                                        gender: S.of(context).Male,
                                        isSelected: _selectedGender == 'male',
                                        onSelected: (value) {
                                          setState(() {
                                            _selectedGender = 'male';
                                            print(
                                                'Selected Gender: $_selectedGender');
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 8.0),
                                      GenderCard(
                                        gender: S.of(context).Female,
                                        isSelected: _selectedGender == 'female',
                                        onSelected: (value) {
                                          setState(() {
                                            _selectedGender = 'female';
                                            print(
                                                'Selected Gender: $_selectedGender');
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(14),
                        topLeft: Radius.circular(14)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), // Shadow color
                        spreadRadius: 0, // Spread of shadow
                        blurRadius: 4, // Blur effect
                        offset: const Offset(0, -2), // Position of shadow
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 10, right: 10, bottom: 15),
                      child: SizedBox(
                        height: 49,
                        width: double.infinity,
                        child: customElevatedButton(
                            context: context,
                            labelStyle:  TextStyle(
                                fontFamily: 'BalooBhaijaan2',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            label: S.of(context).UpdateProfile,
                            backgroundColor: Colorss.mainColor,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              // Delay the navigation to ensure the keyboard is hidden
                              await Future.delayed(const Duration(
                                  milliseconds: 400)); // Adjust delay if needed

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colorss.mainColor),
                                    ),
                                  );
                                },
                              );
                              FocusScope.of(context).unfocus();

                              await _updateUserData();

                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              await prefs.remove('userData');
                              FocusScope.of(context).unfocus();

                              Navigator.pop(context);
                              await Future.delayed(
                                  const Duration(milliseconds: 400));
                              FocusScope.of(context).unfocus();

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage(
                                      initialIndex: 3,
                                      token: widget.token,
                                      userId: widget.userId,
                                    )),
                                    (route) => route.isFirst,
                              );
                            }),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        if (_isUploading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colorss.mainColor,
              ), // Show progress indicator if uploading
            ),
          ),
      ],
    );
  }
}*/
