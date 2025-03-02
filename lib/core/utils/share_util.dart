import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> shareUrl(String url) async {
  final logger = Logger();

  try {
    await Share.share(
      url,
      subject: 'Taskify',
    );
  } on PlatformException catch (e) {
    logger.e('platform error: $e');
    return;
  } on FormatException catch (e) {
    logger.e('Wrong format: $e');
    return;
  } catch (e) {
    logger.e('Something went wrong: $e');
    return;
  }
  logger.e('Shared successfully');
}

Future<void> launchExternalLink(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } else {
    if (kDebugMode) {
      print('Could not launch $url');
    }
  }
}
