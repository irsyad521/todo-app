import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int page;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const PaginationControls({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canPrev = page > 1;
    final canNext = page < totalPages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: canPrev ? onPrev : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canPrev
                    ? Colors.deepPurple
                    : Colors.grey.withOpacity(0.2),
                foregroundColor: canPrev
                    ? Colors.white
                    : Colors.white38,
              ),
              child: const Text('Prev'),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$page / $totalPages',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: canNext ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canNext
                    ? Colors.deepPurple
                    : Colors.grey.withOpacity(0.2),
                foregroundColor: canNext
                    ? Colors.white
                    : Colors.white38,
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}