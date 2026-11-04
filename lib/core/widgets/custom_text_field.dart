import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../utils/debouncer.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final void Function(String)? onDebouncedChanged;
  final Duration debounceDuration;

  const CustomTextField({
    super.key,
    this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.fillColor,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.style,
    this.hintStyle,
    this.onSubmitted,
    this.textInputAction,
    this.onDebouncedChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  Debouncer? _debouncer;

  @override
  void initState() {
    super.initState();
    if (widget.onDebouncedChanged != null) {
      _debouncer = Debouncer(delay: widget.debounceDuration);
    }
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.debounceDuration != oldWidget.debounceDuration ||
        widget.onDebouncedChanged != oldWidget.onDebouncedChanged) {
      _debouncer?.dispose();
      _debouncer = widget.onDebouncedChanged != null
          ? Debouncer(delay: widget.debounceDuration)
          : null;
    }
  }

  @override
  void dispose() {
    _debouncer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasLabel = widget.label != null && widget.label!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLabel) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          validator: widget.validator,
          focusNode: widget.focusNode,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.onDebouncedChanged != null) {
              _debouncer?.run(() => widget.onDebouncedChanged!(value));
            }
          },
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          onFieldSubmitted: (value) {
            _debouncer?.cancel();
            widget.onSubmitted?.call(value);
          },
          textInputAction: widget.textInputAction,
          style: widget.style ?? AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: widget.hintStyle ?? AppTextStyles.subtext,
            filled: widget.fillColor != null ? true : null,
            fillColor: widget.fillColor,
            contentPadding: widget.contentPadding,
            border: widget.border,
            enabledBorder: widget.enabledBorder,
            focusedBorder: widget.focusedBorder,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.textSub, size: 20)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSub,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
