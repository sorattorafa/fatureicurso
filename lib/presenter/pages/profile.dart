import 'dart:convert';
import 'dart:typed_data';

import 'package:fatureicurso/data/features/auth/controllers/user.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadLocalImage();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setImage(XFile? image) async {
    if (image == null) return;

    final bytes = await image.readAsBytes();
    setState(() {
      _imageBytes = bytes;
    });

    await saveLocalImage(base64Encode(_imageBytes!));
  }

  Future<void> saveLocalImage(String value) async {
    GetStorage box = GetStorage();
    box.write('userImageProfile', value);
    await box.save();
  }

  Future<void> loadLocalImage() async {
    GetStorage box = GetStorage();
    final String? value = box.read('userImageProfile');
    if (value != null) {
      setState(() {
        _imageBytes = base64Decode(value);
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    final ImagePicker picker = ImagePicker();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecionar fonte da imagem'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? photo =
                      await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    await setImage(photo);
                  }
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 50),
                    Text('Câmera'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? photo =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    await setImage(photo);
                  }
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo, size: 50),
                    Text('Galeria'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Meu Perfil"))),
      body: Center(
          child: ProfileScreen(
        avatar: IconButton(
                iconSize: 150,
                icon: _imageBytes != null
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: 
                        BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(_imageBytes!),
                          ),
                        ),
                      )
                    : const Icon(Icons.account_circle),
                onPressed: () async {
                  // Chamar uma função para atualizar a foto de perfil
                  await _showImageSourceDialog();
                },
              ),
        actions: [
          SignedOutAction((context) async {
            Get.find<UserController>().setUserToken = '';
            await Get.offNamed('/auth');
          })
        ],
      )),
    );
  }
}
