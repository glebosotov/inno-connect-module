import 'package:flutter/material.dart';

// ignore: long-method
ButtonStyle answerButtonStyle(BuildContext context) => ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.5);
          }

          return Theme.of(context).colorScheme.primary;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Theme.of(context).colorScheme.onPrimary.withOpacity(0.5);
          }

          return Theme.of(context).colorScheme.onPrimary;
        },
      ),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
              ),
            );
          }

          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          );
        },
      ),
      minimumSize: MaterialStateProperty.resolveWith<Size>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return const Size.fromHeight(50);
          }

          return const Size.fromHeight(50);
        },
      ),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                    ) ??
                const TextStyle();
          }

          return Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ) ??
              const TextStyle();
        },
      ),
    );
