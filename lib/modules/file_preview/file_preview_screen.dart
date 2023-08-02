import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FilePrevewScreen extends StatefulWidget with WidgetsBindingObserver {
  const FilePrevewScreen({
    Key? key,
    required this.linkFile,
  }) : super(key: key);

  final String linkFile;

  static const linkFileArg = 'linkFileArg';

  @override
  State<FilePrevewScreen> createState() => _FilePrevewScreenState();
}

class _FilePrevewScreenState extends State<FilePrevewScreen> {
  final GlobalKey webViewKey = GlobalKey();

  // InAppWebViewController? webViewController;
  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //   crossPlatform: InAppWebViewOptions(
  //       useShouldOverrideUrlLoading: true,
  //       mediaPlaybackRequiresUserGesture: false),
  //   android: AndroidInAppWebViewOptions(
  //     useHybridComposition: true,
  //   ),
  //   ios: IOSInAppWebViewOptions(
  //     allowsInlineMediaPlayback: true,
  //   ),
  // );

  // late PullToRefreshController pullToRefreshController;
  late final String url;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    // Enable virtual display.
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();

    url = GeneratorService.generatePreviewLink(widget.linkFile);
  }

  @override
  Widget build(BuildContext context) {
    // // if (Platform.isIOS &&
    // //     (widget.linkFile.endsWith('doc') || widget.linkFile.endsWith('docx'))) {
    // launchUrl(
    //   Uri.parse(GeneratorService.generatePreviewLink(widget.linkFile)),
    //   mode: LaunchMode.inAppWebView,
    //   webViewConfiguration: WebViewConfiguration(),
    // );
    // AppRouter.back(context);
    // // }

    // return Container();

    return Scaffold(
      appBar: AppBar(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _loadWebViewProgress.value = 0;
      //     setState(() {});
      //   },
      //   child: Icon(Icons.replay),
      // ),
      // body: InAppBrowser(),
      // body: InAppWebView(
      //   initialUrlRequest: URLRequest(url: Uri.parse(url)),
      //   initialOptions: InAppWebViewGroupOptions(
      //     crossPlatform: InAppWebViewOptions(
      //       clearCache: true,
      //       disableContextMenu: true,
      //     ),
      //   ),
      //   onLoadHttpError: (controller, _, code, message) {
      //     logger.logError(
      //       message,
      //       code,
      //       'WebViewLoadHttpError',
      //     );
      //     AppDialogs.toast(message);
      //   },
      //   onLoadError: (controller, _, code, message) {
      //     logger.logError(
      //       message,
      //       code,
      //       'WebViewLoadError',
      //     );
      //     AppDialogs.toast(message);
      //     // controller.reload();
      //   },
      //   onProgressChanged: (controller, progress) {
      //     logger.log(progress, name: 'WebView_Progress');
      //   },
      // ),
    );
  }
}
