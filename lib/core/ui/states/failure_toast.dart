import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/ui/states/custom_toast.dart';
import 'package:find_a_nikah/core/ui/text/failure_text.dart';
import 'package:flutter/material.dart';

/// The standard way a page reports a [Failure] it can't show inline.
/// Call from a `BlocListener`, never from `build`.
void showFailureToast(BuildContext context, Failure failure) {
  if (failure case ApiResponseFailure(:final message)) {
    CustomToast.showError(context, message);
    return;
  }
  if (failure case ValidationFailure(:final fields) when fields.isNotEmpty) {
    CustomToast.showError(context, failure.message);
    return;
  }
  CustomToast.showError(
    context,
    failure.title,
    description: failure.message,
  );
}
