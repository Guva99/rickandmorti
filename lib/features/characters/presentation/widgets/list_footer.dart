import 'package:clatch_rcikmorti/core/error/failure.dart';
import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
import 'package:clatch_rcikmorti/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class ListFooter extends StatelessWidget {
  const ListFooter({
    required this.isLoading,
    required this.failure,
    required this.onRetry,
    super.key,
  });

  final bool isLoading;
  final Failure? failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.xl,
    ),
    child: switch ((isLoading, failure)) {
      (true, _) => const Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
      (_, final failure?) => _LoadMoreError(failure: failure, onRetry: onRetry),
      _ => const SizedBox.shrink(),
    },
  );
}

class _LoadMoreError extends StatelessWidget {
  const _LoadMoreError({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        failure.message,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.sm),
      TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Retry'),
      ),
    ],
  );
}
