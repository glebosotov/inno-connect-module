import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../pigeon.dart';

class HubLayout extends StatelessWidget {
  const HubLayout({super.key, required this.openQuiz, required this.config});
  final VoidCallback openQuiz;
  final HubScreenConfiguration config;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.MMMd();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(
                  height: 4,
                ),
                padding: const EdgeInsets.all(16),
                itemCount: config.news.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    api.newsItemPressed(
                      config.news[index]?.id ?? 'invalid',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        if (config.news[index]?.imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: LimitedBox(
                              maxWidth: 60,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    config.news[index]?.imageUrl ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      config.news[index]?.title ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                                  if (config
                                          .news[index]?.dateSecondsFromEpoch !=
                                      null)
                                    Text(
                                      formatter.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          (config.news[index]
                                                      ?.dateSecondsFromEpoch ??
                                                  0) *
                                              1000,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                config.news[index]?.description ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 20,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: config.buttons.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ElevatedButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.5),
                                ),
                              );
                            }

                            return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            );
                          },
                        ),
                      ),
                      onPressed: () {
                        api.hubButtonPressed(
                          config.buttons[index]?.id ?? 'invalid',
                        );
                        if (config.buttons[index]?.startsQuiz ?? false) {
                          openQuiz();
                        }
                      },
                      child: Text(
                        config.buttons[index]?.title ?? '',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
