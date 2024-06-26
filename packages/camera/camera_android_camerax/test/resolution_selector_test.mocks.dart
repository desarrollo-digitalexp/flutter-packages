// Mocks generated by Mockito 5.4.3 from annotations
// in camera_android_camerax/test/resolution_selector_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:camera_android_camerax/src/aspect_ratio_strategy.dart' as _i2;
import 'package:camera_android_camerax/src/resolution_strategy.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

import 'test_camerax_library.g.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AspectRatioStrategy].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockAspectRatioStrategy extends _i1.Mock
    implements _i2.AspectRatioStrategy {
  MockAspectRatioStrategy() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get preferredAspectRatio => (super.noSuchMethod(
        Invocation.getter(#preferredAspectRatio),
        returnValue: 0,
      ) as int);

  @override
  int get fallbackRule => (super.noSuchMethod(
        Invocation.getter(#fallbackRule),
        returnValue: 0,
      ) as int);
}

/// A class which mocks [ResolutionStrategy].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockResolutionStrategy extends _i1.Mock
    implements _i3.ResolutionStrategy {
  MockResolutionStrategy() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [TestResolutionSelectorHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestResolutionSelectorHostApi extends _i1.Mock
    implements _i4.TestResolutionSelectorHostApi {
  MockTestResolutionSelectorHostApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void create(
    int? identifier,
    int? resolutionStrategyIdentifier,
    int? aspectRatioStrategyIdentifier,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #create,
          [
            identifier,
            resolutionStrategyIdentifier,
            aspectRatioStrategyIdentifier,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TestInstanceManagerHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestInstanceManagerHostApi extends _i1.Mock
    implements _i4.TestInstanceManagerHostApi {
  MockTestInstanceManagerHostApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void clear() => super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
