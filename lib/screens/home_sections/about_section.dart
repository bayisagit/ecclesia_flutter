import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo.png', height: 120),
          SizedBox(height: 30),
          Text(
            'WELCOME TO AASTU FOCUS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'A CHRIST-CENTERED COMMUNITY',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 60,
            height: 3,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(height: 30),
          Text(
            'AASTU Focus is a Christ-centered community dedicated to fostering spiritual growth, building meaningful relationships, and serving our campus and beyond. We envision a campus where students are transformed by the love of Christ.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildFeature(
                        context,
                        Icons.favorite,
                        'Faith',
                        'Grounding everything we do in Christ and His teachings.',
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildFeature(
                        context,
                        Icons.people,
                        'Community',
                        'Creating a welcoming environment where authentic relationships flourish.',
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildFeature(
                        context,
                        Icons.public,
                        'Service',
                        'Following Christ\'s example by serving others with humility.',
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildFeature(
                      context,
                      Icons.favorite,
                      'Faith',
                      'Grounding everything we do in Christ and His teachings.',
                    ),
                    SizedBox(height: 20),
                    _buildFeature(
                      context,
                      Icons.people,
                      'Community',
                      'Creating a welcoming environment where authentic relationships flourish.',
                    ),
                    SizedBox(height: 20),
                    _buildFeature(
                      context,
                      Icons.public,
                      'Service',
                      'Following Christ\'s example by serving others with humility.',
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.blueAccent : Colors.black12,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
