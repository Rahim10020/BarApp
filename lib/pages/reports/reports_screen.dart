import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    final filteredSales = provider.ventes
        .where((v) =>
            v.dateVente.isAfter(_startDate.subtract(const Duration(days: 1))) &&
            v.dateVente.isBefore(_endDate.add(const Duration(days: 1))))
        .toList();

    final totalRevenue =
        filteredSales.fold(0.0, (sum, v) => sum + v.montantTotal);
    final totalOrders = filteredSales.length;
    final averageOrderValue =
        totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

    final filteredOrders = provider.commandes
        .where((c) =>
            c.dateCommande
                .isAfter(_startDate.subtract(const Duration(days: 1))) &&
            c.dateCommande.isBefore(_endDate.add(const Duration(days: 1))))
        .toList();

    final totalOrderCost =
        filteredOrders.fold(0.0, (sum, c) => sum + c.montantTotal);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rapports', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.brown[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Période',
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                    child: Text('Du: ${Helpers.formatterDate(_startDate)}'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    child: Text('Au: ${Helpers.formatterDate(_endDate)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Ventes',
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildReportRow(
                        'Revenus totaux', Helpers.formatterEnCFA(totalRevenue)),
                    _buildReportRow('Nombre de ventes', '$totalOrders'),
                    _buildReportRow('Panier moyen',
                        Helpers.formatterEnCFA(averageOrderValue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Commandes',
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildReportRow('Coût total des commandes',
                        Helpers.formatterEnCFA(totalOrderCost)),
                    _buildReportRow(
                        'Nombre de commandes', '${filteredOrders.length}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bénéfice estimé',
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildReportRow(
                  'Bénéfice (Revenus - Coûts)',
                  Helpers.formatterEnCFA(totalRevenue - totalOrderCost),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.montserrat()),
          Text(value,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
