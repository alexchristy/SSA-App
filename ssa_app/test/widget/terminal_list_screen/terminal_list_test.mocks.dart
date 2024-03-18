// Mocks generated by Mockito 5.4.4 from annotations
// in ssa_app/test/widget/terminal_list_screen/terminal_list_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ssa_app/models/terminal.dart' as _i2;
import 'package:ssa_app/utils/terminal_utils.dart' as _i3;

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

class _FakeTerminal_0 extends _i1.SmartFake implements _i2.Terminal {
  _FakeTerminal_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TerminalService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTerminalService extends _i1.Mock implements _i3.TerminalService {
  MockTerminalService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.Terminal>> getTerminals({dynamic fromCache = true}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTerminals,
          [],
          {#fromCache: fromCache},
        ),
        returnValue: _i4.Future<List<_i2.Terminal>>.value(<_i2.Terminal>[]),
      ) as _i4.Future<List<_i2.Terminal>>);

  @override
  _i2.Terminal getTerminalFromDoc(_i5.QueryDocumentSnapshot<Object?>? doc) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTerminalFromDoc,
          [doc],
        ),
        returnValue: _FakeTerminal_0(
          this,
          Invocation.method(
            #getTerminalFromDoc,
            [doc],
          ),
        ),
      ) as _i2.Terminal);

  @override
  _i4.Future<List<_i5.QueryDocumentSnapshot<Object?>>> getTerminalDocs(
          {dynamic fromCache = true}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTerminalDocs,
          [],
          {#fromCache: fromCache},
        ),
        returnValue: _i4.Future<List<_i5.QueryDocumentSnapshot<Object?>>>.value(
            <_i5.QueryDocumentSnapshot<Object?>>[]),
      ) as _i4.Future<List<_i5.QueryDocumentSnapshot<Object?>>>);

  @override
  _i4.Future<List<_i2.Terminal>> getTerminalsByGroups({
    required List<String>? groups,
    dynamic fromCache = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTerminalsByGroups,
          [],
          {
            #groups: groups,
            #fromCache: fromCache,
          },
        ),
        returnValue: _i4.Future<List<_i2.Terminal>>.value(<_i2.Terminal>[]),
      ) as _i4.Future<List<_i2.Terminal>>);
}
