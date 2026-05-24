import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class LoggerObServer extends ProviderObserver {
  void _log(String message) {
    if (kDebugMode) {
      log(message);
    }
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    _log('''
🟢 Provider Added
---------------------------------------
Name: ${context.provider.name ?? 'Unnamed'}
Type: ${context.provider.runtimeType}
Value: $value
---------------------------------------
''');
    super.didAddProvider(context, value);
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    _log('''
🔴 Provider Disposed
---------------------------------------
Name: ${context.provider.name ?? 'Unnamed'}
Type: ${context.provider.runtimeType}
---------------------------------------
''');

    super.didDisposeProvider(context);
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _log('''
🌀 Provider Updated
---------------------------------------
Name: ${context.provider.name ?? 'Unnamed'}
Type: ${context.provider.runtimeType}
Previous: $previousValue
New: $newValue
---------------------------------------
''');
    super.didUpdateProvider(context, previousValue, newValue);
  }

  @override
  void mutationError(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
    Object error,
    StackTrace stackTrace,
  ) {
    _log('''
❌ Mutation Error
---------------------------------------
Provider: ${context.provider.name ?? 'Unnamed'}
Mutation: ${mutation.runtimeType}
Error: $error
Stack Trace: $stackTrace
---------------------------------------
''');
    super.mutationError(context, mutation, error, stackTrace);
  }

  @override
  void mutationReset(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
  ) {
    _log('''
🔄 Mutation Reset
---------------------------------------
Provider: ${context.provider.name ?? 'Unnamed'}
Mutation: ${mutation.runtimeType}
---------------------------------------
''');
    super.mutationReset(context, mutation);
  }

  @override
  void mutationStart(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
  ) {
    _log('''
🚀 Mutation Started
---------------------------------------
Provider: ${context.provider.name ?? 'Unnamed'}
Mutation: ${mutation.runtimeType}
State Before: $mutation
---------------------------------------
''');
    super.mutationStart(context, mutation);
  }

  @override
  void mutationSuccess(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
    Object? result,
  ) {
    _log('''
✅ Mutation Success
---------------------------------------
Provider: ${context.provider.name ?? 'Unnamed'}
Mutation: ${mutation.runtimeType}
Result: $result
---------------------------------------
''');
    super.mutationSuccess(context, mutation, result);
  }

  @override
  noSuchMethod(Invocation invocation) {
    _log('''
❌ No method Find
---------------------------------------
⚠️ Attempted to call: ${invocation.memberName}
Arguments: ${invocation.positionalArguments}
'Named args: ${invocation.namedArguments}'
---------------------------------------
''');
    return super.noSuchMethod(invocation);
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _log('''
⚠️ Provider Error
---------------------------------------
Name: ${context.provider.name ?? 'Unnamed'}
Type: ${context.provider.runtimeType}
Error: $error
Stack Trace: $stackTrace
---------------------------------------
''');

    super.providerDidFail(context, error, stackTrace);
  }
}
