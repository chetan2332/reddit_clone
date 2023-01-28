import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class PostCard extends ConsumerWidget {
  const PostCard(this.post, {super.key});

  final Post post;

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypetext = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.read(userProvider);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ).copyWith(right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(post.communityProfilePic),
                          radius: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'r/${post.communityName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'u/${post.username}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (post.uid == user!.uid)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () => deletePost(ref, context),
                              icon: Icon(
                                Icons.delete,
                                color: Pallete.redColor,
                              ),
                            ),
                          )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        post.title,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isTypeImage)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          post.link!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (isTypeLink)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: AnyLinkPreview(
                          link: post.link!,
                          displayDirection: UIDirection.uiDirectionHorizontal,
                        ),
                      ),
                    if (isTypetext)
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          post.description!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: Icon(
                              Icons.thumb_up,
                              size: 16,
                              color: post.upvotes.contains(user.uid)
                                  ? Pallete.redColor
                                  : null,
                            ),
                          ),
                          Text(post.upvotes.length.toString()),
                          const SizedBox(width: 16),
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: Icon(
                              Icons.thumb_down,
                              size: 20,
                              color: post.downvotes.contains(user.uid)
                                  ? Pallete.blueColor
                                  : null,
                            ),
                          ),
                          Text(post.downvotes.length.toString()),
                          const SizedBox(width: 16),
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: const Icon(Icons.comment),
                          ),
                          Text(post.commentCount.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        )
      ],
    );
  }
}
