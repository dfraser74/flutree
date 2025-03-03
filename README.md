# Flutree

![Works with Android](https://img.shields.io/badge/Works_with-Android-green?style=flat-square)
![Maintenance](https://img.shields.io/maintenance/no/2021?style=flat-square)
![Installs](https://img.shields.io/badge/installs-53k+-orange)
![Twitter Follow](https://img.shields.io/twitter/follow/iqfareez?label=Follow&style=social)

Your personalized social cards. Put your social medias link in one place. Easy peasy!

# Flutree has been sunsetted since 31 August 2021. No longer available to downloads.

## Download on Google Play Store

<a href='https://play.google.com/store/apps/details?id=com.iqmal.linktreeflutter&utm_source=Github&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/></a>

## Flutree Create (for non-Android users)

- [flutreecreate.web.app](https://flutreecreate.web.app) or
- [flutree.studio](https://flutree.studio)

## Devlog

- [Part 1](https://www.instagram.com/s/aGlnaGxpZ2h0OjE4MTUzMDA3Njg0MTgyODA3)
- [Part 2](https://www.instagram.com/s/aGlnaGxpZ2h0OjE3ODg1MzE2ODMzMjE5MDg5)

## To run

1. Create `PRIVATE.dart` in the lib folder. (I gitignored the file because it contains the admob id etc.) - You can use the test ad unit (https://developers.google.com/admob/android/test-ads#demo_ad_units)

   - Example:

   ```
   const kAdmobAppId = 'ca-app-pub-xxxxxxxxxxxxxxxxxxxxxxx';
   const kShareBannerUnitId = 'ca-app-pub-189637xxxxxxxx/3206521140';
   const kEditPageBannerUnitId = 'ca-app-pub-189637xxxxxxxx/7250471616';
   const kInterstitialShareUnitId = 'ca-app-pub-189637xxxxxxxx/1721617881';
   const kInterstitialPreviewUnitId = 'ca-app-pub-189637xxxxxxxx/2819569063';
   const kBitlyApiToken = '85e8df908612276xxxxxxxxxxxxx36ee3d40e31';

   ```

2. Create project on **Firebase console**, make sure the auth and Firestore is enabled.
3. Download your **`google_service.json`** from Firebase console, put the file in `android/app/`
4. Run `flutter run`

\
:star::star::star::star::star:
