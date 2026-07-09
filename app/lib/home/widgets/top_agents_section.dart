import 'package:flutter/material.dart';
import '../../widgets/agent_list.dart';

class AgentRowSection extends StatelessWidget {
  const AgentRowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Top Agents',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
              },
              child: Text(
                "view all",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(1, 80, 147, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              TopAgentItem(
                imagePath: 'assets/images/agent1.jpg',
                name: 'Robert Smith',
              ),
              TopAgentItem(
                imagePath: 'assets/images/agent2.jpg',
                name: 'Kristin Watson',
              ),
              TopAgentItem(
                imagePath: 'assets/images/agent3.jpg',
                name: 'Eleanor Pena',
              ),
              TopAgentItem(
                imagePath: 'assets/images/agent4.jpg',
                name: 'Theresa Webb',
              ),
              TopAgentItem(
                imagePath: 'assets/images/agent5.jpg',
                name: 'Robert Smith',
              ),
            ],
          ),
        ),

      ],

    );
  }
}
