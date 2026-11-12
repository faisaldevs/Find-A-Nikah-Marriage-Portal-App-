import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Longest message the API accepts.
const kMaxMessageLength = 5000;

/// "+" · pill text field · mic (empty) or pink send (text), with the quote
/// being replied to above it.
class MessageComposer extends StatefulWidget {
  const MessageComposer({
    required this.onSend,
    required this.onAttach,
    required this.onVoice,
    required this.onCancelReply,
    this.onTypingChanged,
    this.replyAuthor,
    this.replyText,
    super.key,
  });

  final ValueChanged<String> onSend;
  final VoidCallback onAttach;
  final VoidCallback onVoice;
  final VoidCallback onCancelReply;

  /// True while the field has text, false once it empties or is sent.
  final ValueChanged<bool>? onTypingChanged;

  /// Both set while replying.
  final String? replyAuthor;
  final String? replyText;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onText);
  }

  var _typing = false;

  void _onText() {
    final typing = _controller.text.trim().isNotEmpty;
    // Keystrokes while typing re-announce (the repository throttles); the
    // edge to empty announces the stop.
    if (typing || _typing) widget.onTypingChanged?.call(typing);
    _typing = typing;
  }

  @override
  void didUpdateWidget(MessageComposer old) {
    super.didUpdateWidget(old);
    // Picking a message to reply to means "type the answer now".
    if (widget.replyText != null && widget.replyText != old.replyText) {
      _focus.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onText)
      ..dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final replying = widget.replyText != null;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kMsgGrey200)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 10.w, 12.w, 10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (replying)
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 0, 0, 10.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: ReplyQuote(
                          author: 'Replying to ${widget.replyAuthor}',
                          text: widget.replyText!,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cancel reply',
                        onPressed: widget.onCancelReply,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20.r,
                          color: kMsgGrey500,
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Attach',
                    onPressed: widget.onAttach,
                    icon: Icon(
                      Icons.add_rounded,
                      size: 28.r,
                      color: kMsgIconDark,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      // The server rejects anything over 5000 characters.
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(kMaxMessageLength),
                      ],
                      style: figmaText(15, 22),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: figmaText(15, 22, color: kMsgGrey400),
                        filled: true,
                        fillColor: kMsgGrey100,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 11.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.w),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (_, value, _) => value.text.trim().isEmpty
                        ? IconButton(
                            tooltip: 'Voice message',
                            onPressed: widget.onVoice,
                            icon: Icon(
                              Icons.mic_none_rounded,
                              size: 26.r,
                              color: kMsgIconDark,
                            ),
                          )
                        : _SendButton(onTap: _send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Send',
      child: InkResponse(
        onTap: onTap,
        child: Container(
          width: 44.r,
          height: 44.r,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.send_rounded, size: 20.r, color: Colors.white),
        ),
      ),
    );
  }
}
