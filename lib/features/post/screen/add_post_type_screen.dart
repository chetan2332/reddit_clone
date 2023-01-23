import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  File? bannerFile;
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      bannerFile = File(res.files.first.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypetext = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Share'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Name',
                border: InputBorder.none,
              ),
              maxLength: 30,
            ),
            const SizedBox(height: 20),
            if (isTypeImage)
              GestureDetector(
                onTap: selectBannerImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: currentTheme.textTheme.bodyText2!.color!,
                  dashPattern: const [10, 4],
                  radius: const Radius.circular(10),
                  strokeCap: StrokeCap.round,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: bannerFile != null
                        ? Image.file(bannerFile!)
                        : const Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                          ),
                  ),
                ),
              ),
            if (isTypetext)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter description here',
                  border: InputBorder.none,
                ),
                maxLines: 6,
              ),
            if (isTypeLink)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter link here',
                  border: InputBorder.none,
                ),
              ),
            const SizedBox(height: 20),
            ref.watch(userCommunitiesProvider).when(
                  data: (data) {
                    communities = data;
                    if (data.isEmpty) {
                      return const SizedBox();
                    }
                    return DropdownButton(
                      value: selectedCommunity ?? data[0],
                      items: data
                          .map((community) => DropdownMenuItem(
                                value: community,
                                child: Text(community.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedCommunity = value;
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(e: error.toString()),
                  loading: () => const Loader(),
                )
          ],
        ),
      ),
    );
  }
}
