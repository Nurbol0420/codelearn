import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.height = 50,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isFullWidth ? double.infinity : 0,
      ),
      child: isOutlined
          ? OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(isFullWidth ? double.infinity : 0, height), // 👈 chiều cao “chuẩn”
          padding: const EdgeInsets.symmetric(horizontal: 16),          // 👈 tránh clip
          side: BorderSide(color: backgroundColor ?? theme.primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(theme),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(isFullWidth ? double.infinity : 0, height), // 👈 chiều cao “chuẩn”
          padding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: backgroundColor ?? theme.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(theme),
      ),
    );

  }

  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? theme.primaryColor : Colors.white,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: isOutlined
                ? (backgroundColor ?? theme.primaryColor)
                : (textColor ?? Colors.white),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: isOutlined
                ? (backgroundColor ?? theme.primaryColor)
                : (textColor ?? Colors.white),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
