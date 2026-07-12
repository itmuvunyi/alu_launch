import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';

class _OnboardSlide {
  const _OnboardSlide(
      {required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
}

const _slides = [
  _OnboardSlide(
    icon: Icons.explore_outlined,
    title: 'Discover global\nopportunities.',
    body: 'Browse internships from student-led startups across the continent.',
  ),
  _OnboardSlide(
    icon: Icons.verified_outlined,
    title: 'Join verified startups.',
    body: 'Connect with student-led ventures and gain real-world experience.',
  ),
  _OnboardSlide(
    icon: Icons.trending_up_outlined,
    title: 'Track your\napplications live.',
    body: 'Follow every step from submission to offer, all in one place.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  void _finish() => context.go('/login');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          'assets/images/alu_logo.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('ALU Launch',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  TextButton(onPressed: _finish, child: const Text('Skip')),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final slide = _slides[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(slide.icon,
                              size: 96, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          child: Text(
                            slide.body,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLast
                      ? _finish
                      : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          ),
                  icon: Icon(isLast ? Icons.check : Icons.arrow_forward),
                  label: Text(isLast ? 'Get Started' : 'Next'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Empowering the next generation of African leaders.',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
