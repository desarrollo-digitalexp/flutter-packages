// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_util';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_web/src/link.dart';
import 'package:web/helpers.dart' as html;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Link Widget', () {
    testWidgets('creates anchor with correct attributes',
        (WidgetTester tester) async {
      final Uri uri = Uri.parse('http://foobar/example?q=1');
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: WebLinkDelegate(TestLinkInfo(
          uri: uri,
          target: LinkTarget.blank,
          builder: (BuildContext context, FollowLink? followLink) {
            return const SizedBox(width: 100, height: 100);
          },
        )),
      ));
      // Platform view creation happens asynchronously.
      await tester.pumpAndSettle();

      final html.Element anchor = _findSingleAnchor();
      expect(anchor.getAttribute('href'), uri.toString());
      expect(anchor.getAttribute('target'), '_blank');

      final Uri uri2 = Uri.parse('http://foobar2/example?q=2');
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: WebLinkDelegate(TestLinkInfo(
          uri: uri2,
          target: LinkTarget.self,
          builder: (BuildContext context, FollowLink? followLink) {
            return const SizedBox(width: 100, height: 100);
          },
        )),
      ));
      await tester.pumpAndSettle();

      // Check that the same anchor has been updated.
      expect(anchor.getAttribute('href'), uri2.toString());
      expect(anchor.getAttribute('target'), '_self');

      final Uri uri3 = Uri.parse('/foobar');
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: WebLinkDelegate(TestLinkInfo(
          uri: uri3,
          target: LinkTarget.self,
          builder: (BuildContext context, FollowLink? followLink) {
            return const SizedBox(width: 100, height: 100);
          },
        )),
      ));
      await tester.pumpAndSettle();

      // Check that internal route properly prepares using the default
      // [UrlStrategy]
      expect(anchor.getAttribute('href'),
          ui_web.urlStrategy?.prepareExternalUrl(uri3.toString()));
      expect(anchor.getAttribute('target'), '_self');

      // Needed when testing on on Chrome98 headless in CI.
      // See https://github.com/flutter/flutter/issues/121161
      await tester.pumpAndSettle();
    });

    testWidgets('sizes itself correctly', (WidgetTester tester) async {
      final Key containerKey = GlobalKey();
      final Uri uri = Uri.parse('http://foobar');
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(const Size(100.0, 100.0)),
            child: WebLinkDelegate(TestLinkInfo(
              uri: uri,
              target: LinkTarget.blank,
              builder: (BuildContext context, FollowLink? followLink) {
                return Container(
                  key: containerKey,
                  child: const SizedBox(width: 50.0, height: 50.0),
                );
              },
            )),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final Size containerSize = tester.getSize(find.byKey(containerKey));
      // The Stack widget inserted by the `WebLinkDelegate` shouldn't loosen the
      // constraints before passing them to the inner container. So the inner
      // container should respect the tight constraints given by the ancestor
      // `ConstrainedBox` widget.
      expect(containerSize.width, 100.0);
      expect(containerSize.height, 100.0);

      // Needed when testing on on Chrome98 headless in CI.
      // See https://github.com/flutter/flutter/issues/121161
      await tester.pumpAndSettle();
    });

    // See: https://github.com/flutter/plugins/pull/3522#discussion_r574703724
    testWidgets('uri can be null', (WidgetTester tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: WebLinkDelegate(TestLinkInfo(
          uri: null,
          target: LinkTarget.defaultTarget,
          builder: (BuildContext context, FollowLink? followLink) {
            return const SizedBox(width: 100, height: 100);
          },
        )),
      ));
      // Platform view creation happens asynchronously.
      await tester.pumpAndSettle();

      final html.Element anchor = _findSingleAnchor();
      expect(anchor.hasAttribute('href'), false);

      // Needed when testing on on Chrome98 headless in CI.
      // See https://github.com/flutter/flutter/issues/121161
      await tester.pumpAndSettle();
    });

    testWidgets('can be created and disposed', (WidgetTester tester) async {
      final Uri uri = Uri.parse('http://foobar');
      const int itemCount = 500;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (_, int index) => WebLinkDelegate(TestLinkInfo(
                uri: uri,
                target: LinkTarget.defaultTarget,
                builder: (BuildContext context, FollowLink? followLink) =>
                    Text('#$index', textAlign: TextAlign.center),
              )),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('#${itemCount - 1}'),
        800,
        maxScrolls: 1000,
      );

      // Needed when testing on on Chrome98 headless in CI.
      // See https://github.com/flutter/flutter/issues/121161
      await tester.pumpAndSettle();
    });
  });
}

html.Element _findSingleAnchor() {
  final List<html.Element> foundAnchors = <html.Element>[];
  html.NodeList anchors = html.document.querySelectorAll('a');
  for (int i = 0; i < anchors.length; i++) {
    final html.Element anchor = anchors.item(i)! as html.Element;
    if (hasProperty(anchor, linkViewIdProperty)) {
      foundAnchors.add(anchor);
    }
  }

  // Search inside the shadow DOM as well.
  final html.ShadowRoot? shadowRoot =
      html.document.querySelector('flt-glass-pane')?.shadowRoot;
  if (shadowRoot != null) {
    anchors = shadowRoot.querySelectorAll('a');
    for (int i = 0; i < anchors.length; i++) {
      final html.Element anchor = anchors.item(i)! as html.Element;
      if (hasProperty(anchor, linkViewIdProperty)) {
        foundAnchors.add(anchor);
      }
    }
  }

  return foundAnchors.single;
}

class TestLinkInfo extends LinkInfo {
  TestLinkInfo({
    required this.uri,
    required this.target,
    required this.builder,
  });

  @override
  final LinkWidgetBuilder builder;

  @override
  final Uri? uri;

  @override
  final LinkTarget target;

  @override
  bool get isDisabled => uri == null;
}
