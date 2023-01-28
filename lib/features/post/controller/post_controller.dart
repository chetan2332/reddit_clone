import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    return PostController(
      postRepository: ref.watch(postRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider),
    );
  },
);

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPost(communities);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required String title,
      required Community selectedCommunity,
      required BuildContext context,
      required String description}) async {
    state = true;
    final user = _ref.read(userProvider);
    final postId = const Uuid().v1();
    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user!.name,
      type: 'text',
      uid: user.uid,
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold(
      (l) => showSnackBar(l.message, context),
      (r) {
        showSnackBar('Posted sucessfully', context);
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost(
      {required String title,
      required Community selectedCommunity,
      required BuildContext context,
      required String link}) async {
    state = true;
    final user = _ref.read(userProvider);
    final postId = const Uuid().v1();
    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user!.name,
      type: 'link',
      uid: user.uid,
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold(
      (l) => showSnackBar(l.message, context),
      (r) {
        showSnackBar('Posted sucessfully', context);
        Routemaster.of(context).pop();
      },
    );
  }

  void shareimagePost(
      {required String title,
      required Community selectedCommunity,
      required BuildContext context,
      required File? file}) async {
    state = true;
    final user = _ref.read(userProvider);
    final postId = const Uuid().v1();
    final imageRes = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);
    imageRes.fold(
      (l) => showSnackBar('image uploading... ${l.toString()}', context),
      (r) async {
        final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user!.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r,
        );

        final res = await _postRepository.addPost(post);
        state = false;
        res.fold(
          (l) => showSnackBar('after image upload ${l.message}', context),
          (r) {
            showSnackBar('Posted sucessfully', context);
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    } else {
      return Stream.value([]);
    }
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    res.fold((l) => showSnackBar(l.message, context),
        (r) => showSnackBar('Post Deleted Successfully', context));
  }
}
