import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../constants.dart';

class DynamicLinkApi {
  static Future<String> generateShortUrl(
      {String profileUrl,
      DocumentSnapshot<Map<String, dynamic>> userInfo}) async {
    ShortDynamicLink fdLink = await DynamicLinkParameters(
            uriPrefix: 'https://$kPageUrl',
            link: Uri.parse(profileUrl),
            googleAnalyticsParameters: GoogleAnalyticsParameters(
              campaign: 'advanced-link',
              medium: 'social',
              source: 'app',
            ),
            socialMetaTagParameters: SocialMetaTagParameters(
                title: '${userInfo.data()["nickname"]}',
                description:
                    'Flutree. Connect audiences to all of your content with just one link.',
                imageUrl: Uri.parse(userInfo.data()["dpUrl"])),
            dynamicLinkParametersOptions: DynamicLinkParametersOptions(
                shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short))
        .buildShortLink();
    return fdLink.shortUrl.toString();
  }
}
