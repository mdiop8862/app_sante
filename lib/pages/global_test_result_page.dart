import 'package:appli_ap_sante/widgets/polygon_chart_section.dart';
import 'package:flutter/material.dart';

class GlobalTestResultPage extends StatefulWidget {
  const GlobalTestResultPage({super.key});
  @override
  State<GlobalTestResultPage> createState() => _GlobalTestResultPageState();
}

class _GlobalTestResultPageState extends State<GlobalTestResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Score global : 1,5 / 5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 100),
            const PolygonChartSection(),
            const Spacer(),
            const Text('Recommendation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            const Text(
              'Votre condition physique ne traduit pas bon état de santé. Nous vous invitons à contacter le SSE qui vous proposera un suivi médical',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
            ),
            const SizedBox(height: 30),
            Align(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45)),
                child: const Text('Télécharger'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
