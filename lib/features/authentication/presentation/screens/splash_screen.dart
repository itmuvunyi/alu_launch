import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('/login'),
        child: SafeArea(
          child: Column(
          children: [
            const Spacer(flex: 3),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/alu_logo.png',
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ALU Launch',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'EMPOWERING GLOBAL TALENT',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
            ),
            const Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: i == 0 ? 1 : 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 5),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  Text(
                    'Connecting students to the future of work',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white54,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(height: 2, width: 80, color: AppColors.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}