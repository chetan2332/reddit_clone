import 'package:reddit_clone/features/feed/feed_screen.dart';
import 'package:reddit_clone/features/post/screen/add_post_screen.dart';

class Constants {
  static const logoPath = "assets/images/logo.png";
  static const googlePath = "assets/images/google.png";
  static const logoEmotePath = "assets/images/loginEmote.png";
  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://www.redditstatic.com/avatars/avatar_default_19_545452.png';
  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];
}
