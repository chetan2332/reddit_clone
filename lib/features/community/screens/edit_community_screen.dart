import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({required this.name, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      bannerFile = File(res.files.first.path!);
    }
  }

  void selectProfileimage() async {
    final res = await pickImage();
    if (res != null) {
      profileFile = File(res.files.first.path!);
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          context: context,
          community: community,
          bannerFile: bannerFile,
          profileFile: profileFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityBynameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text('Save'),
                )
              ],
            ),
            body: isLoading
                ? const Loader()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: Pallete.darkModeAppTheme.textTheme
                                      .bodyText2!.color!,
                                  dashPattern: const [10, 4],
                                  radius: const Radius.circular(10),
                                  strokeCap: StrokeCap.round,
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault
                                            ? const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              )
                                            : Image.network(community.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 20,
                                child: GestureDetector(
                                  onTap: selectProfileimage,
                                  child: CircleAvatar(
                                    backgroundImage: profileFile != null
                                        ? FileImage(profileFile!)
                                            as ImageProvider
                                        : NetworkImage(community.avatar),
                                    radius: 32,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          ),
          error: (error, stackTrace) => ErrorText(e: error.toString()),
          loading: () => const Loader(),
        );
  }
}
