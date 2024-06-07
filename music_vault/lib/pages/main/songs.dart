import 'package:flutter/material.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';

class Songs extends StatelessWidget {
  const Songs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Songs',
          style: TextStyles.heading2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.spacingXS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(text: 'Description'),
            const SizedBox(height: Dimens.spacingXS),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: CustomColors.neutralColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text('List item'),
                    /*trailing: Checkbox(
                      value: true,
                      onChanged: (bool? value) {

                      },
                    ),*/
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
