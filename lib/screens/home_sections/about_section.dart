import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
      child: Column(
        children: [
          Text(
            'WELCOME TO ECCLESIA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'WE ARE A CHURCH THAT BELIEVES IN JESUS',
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
            'Ecclesia is a place where people can meet Jesus, engage in life-giving community, and everyone is welcome. We believe in creating a space where people can have authentic encounters with Christ, discover their gifts and use them for God\'s glory.',
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
                        Icons.favorite,
                        'Love God',
                        'Loving God with all our heart, soul, and mind.',
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildFeature(
                        Icons.people,
                        'Love People',
                        'Loving our neighbors as ourselves.',
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildFeature(
                        Icons.public,
                        'Serve World',
                        'Making disciples of all nations.',
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildFeature(
                      Icons.favorite,
                      'Love God',
                      'Loving God with all our heart, soul, and mind.',
                    ),
                    SizedBox(height: 30),
                    _buildFeature(
                      Icons.people,
                      'Love People',
                      'Loving our neighbors as ourselves.',
                    ),
                    SizedBox(height: 30),
                    _buildFeature(
                      Icons.public,
                      'Serve World',
                      'Making disciples of all nations.',
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

  Widget _buildFeature(IconData icon, String title, String description) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Color(0xFFE53935)),
        SizedBox(height: 15),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
