import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';
import 'package:flutter/material.dart';

/// Shows a bloc's one-shot [notice] as a toast.
void showFeedNotice(BuildContext context, FeedNotice? notice) {
  if (notice == null) return;
  if (notice.isError) {
    CustomToast.showError(context, notice.text);
  } else {
    CustomToast.showInfo(context, notice.text);
  }
}
