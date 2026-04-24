import 'package:flutter/material.dart';

import '../../theme/search_colors.dart';

class SearchInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const SearchInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hasText ? const Color(0xFF7B8DA8) : const Color(0xFFAED2E8),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: SearchColors.muted, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search titles, authors...',
                hintStyle: TextStyle(
                  color: Color(0xFFA0A6AD),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(
                color: SearchColors.title,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (hasText)
            GestureDetector(
              onTap: onClear,
              child: const Icon(
                Icons.close_rounded,
                color: SearchColors.muted,
                size: 30,
              ),
            ),
        ],
      ),
    );
  }
}
