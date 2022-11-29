import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    communityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community name')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Community Name'),
          const SizedBox(height: 10),
          TextField(
            controller: communityNameController,
            decoration: const InputDecoration(
              hintText: 'r/Community_name',
              contentPadding: EdgeInsets.all(18),
              filled: true,
              border: InputBorder.none,
            ),
            maxLength: 21,
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Create Community',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
