import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:easy_localization/easy_localization.dart';

class PdfHelper {
  static Future<void> generateAndPrintOrderPdf({
    required String orderNumber,
    required String packageName,
    required String totalPrice,
    required String status,
    required String date,
    required bool isAr,
    String? logoUrl,
    String? companyName,
    String? phone,
    String? email,
    String? address,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final boldFont = await PdfGoogleFonts.cairoBold();

    pw.ImageProvider? netImage;
    if (logoUrl != null && logoUrl.isNotEmpty) {
      try {
        netImage = await networkImage(logoUrl);
      } catch (e) {
        // ignore image error
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font,
          bold: boldFont,
        ),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (companyName != null && companyName.isNotEmpty)
                      pw.Text(
                        companyName,
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#004b87'),
                        ),
                      )
                    else
                      pw.Text(
                        'رمز للاستقدام',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#004b87'),
                        ),
                      ),
                    if (netImage != null)
                      pw.Image(netImage, height: 60)
                    else
                      pw.SizedBox(width: 1), // spacer
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text(
                    'إيصال الطلب',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColor.fromHex('#eaeaea')),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPdfRow('رقم الطلب:', orderNumber),
                      pw.Divider(color: PdfColor.fromHex('#eaeaea')),
                      _buildPdfRow('تاريخ الطلب:', date),
                      pw.Divider(color: PdfColor.fromHex('#eaeaea')),
                      _buildPdfRow('حالة الطلب:', status),
                      pw.Divider(color: PdfColor.fromHex('#eaeaea')),
                      _buildPdfRow('اسم الخدمة:', packageName),
                      pw.Divider(color: PdfColor.fromHex('#eaeaea')),
                      _buildPdfRow('السعر الإجمالي:', totalPrice),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Divider(color: PdfColor.fromHex('#eaeaea')),
                pw.SizedBox(height: 10),
                if (companyName != null && companyName.isNotEmpty)
                  pw.Center(
                    child: pw.Text(
                      'شكرًا لثقتكم بخدمات ${companyName}',
                      style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                    ),
                  )
                else
                  pw.Center(
                    child: pw.Text(
                      'شكرًا لثقتكم بخدمات رمز للاستقدام',
                      style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                    ),
                  ),
                pw.SizedBox(height: 10),
                if (email != null && email.isNotEmpty)
                  pw.Center(
                    child: pw.Text('البريد الإلكتروني: $email', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
                  ),
                if (phone != null && phone.isNotEmpty)
                  pw.Center(
                    child: pw.Text('رقم التواصل: $phone', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
                  ),
                if (address != null && address.isNotEmpty)
                  pw.Center(
                    child: pw.Text('العنوان: $address', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
                  ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Order_$orderNumber.pdf',
    );
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> generateAndPrintCandidateCV({
    required dynamic candidate, // Using dynamic to avoid hard coupling if entity changes, but best to use it as CandidateEntity
    required bool isAr,
    String? logoUrl,
    String? companyName,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final boldFont = await PdfGoogleFonts.cairoBold();

    pw.ImageProvider? companyImage;
    if (logoUrl != null && logoUrl.isNotEmpty) {
      try { companyImage = await networkImage(logoUrl); } catch (e) {}
    }

    pw.ImageProvider? avatarImage;
    if (candidate.imageUrl != null && candidate.imageUrl!.isNotEmpty) {
      try { avatarImage = await networkImage(candidate.imageUrl!); } catch (e) {}
    }

    final details = candidate.workerDetails;
    final cv = details?.cv;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (pw.Context context) {
          return [
            pw.Directionality(
              textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Branding Header
                  if (companyImage != null || companyName != null) ...[
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        if (companyImage != null)
                          pw.Container(height: 50, child: pw.Image(companyImage))
                        else
                          pw.SizedBox(width: 1),
                          
                        if (companyName != null)
                          pw.Text(companyName, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800))
                        else
                          pw.SizedBox(width: 1),
                      ]
                    ),
                    pw.SizedBox(height: 10),
                    pw.Divider(color: PdfColors.grey300),
                    pw.SizedBox(height: 10),
                  ],

                  // Candidate Info Row
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            candidate.name,
                            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#004b87')),
                          ),
                          pw.SizedBox(height: 5),
                          if (candidate.getLocalizedProfession(isAr).isNotEmpty)
                            pw.Text(candidate.getLocalizedProfession(isAr), style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                          if (candidate.getLocalizedNationality(isAr).isNotEmpty)
                            pw.Text("\${'orders.nationality'.tr()}: \${candidate.getLocalizedNationality(isAr)}", style: pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
                        ],
                      ),
                      if (avatarImage != null)
                        pw.Container(
                          width: 80, height: 80,
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            image: pw.DecorationImage(image: avatarImage, fit: pw.BoxFit.cover),
                          ),
                        ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 20),

                  // Basic Info
                  pw.Text('orders.basic_info'.tr(), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#004b87'))),
                  pw.SizedBox(height: 10),
                  pw.Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      if (details?.age != null) _buildInfoBox('orders.cv_age'.tr(), details!.age!),
                      if (details?.religion != null) _buildInfoBox('orders.cv_religion'.tr(), details!.religion!),
                      if (details?.maritalStatus != null) _buildInfoBox('orders.cv_marital'.tr(), details!.maritalStatus!),
                      if (details?.childrenCount != null) _buildInfoBox('orders.cv_children'.tr(), details!.childrenCount.toString()),
                      if (details?.height != null) _buildInfoBox('orders.cv_height'.tr(), "\${details!.height} cm"),
                      if (details?.weight != null) _buildInfoBox('orders.cv_weight'.tr(), "\${details!.weight} kg"),
                    ],
                  ),
                  
                  pw.SizedBox(height: 20),

                  // Skills
                  if (cv != null && cv.skills.isNotEmpty) ...[
                    pw.Text('orders.cv_skills'.tr(), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#004b87'))),
                    pw.SizedBox(height: 10),
                    pw.Wrap(
                      spacing: 10, runSpacing: 10,
                      children: cv.skills.map<pw.Widget>((s) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(10)),
                        child: pw.Text(s.getLocalizedName(isAr), style: pw.TextStyle(fontSize: 12)),
                      )).toList(),
                    ),
                    pw.SizedBox(height: 20),
                  ],

                  // Languages
                  if (cv != null && cv.languages.isNotEmpty) ...[
                    pw.Text('orders.cv_languages'.tr(), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#004b87'))),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      children: cv.languages.map<pw.Widget>((l) => pw.Container(
                        margin: const pw.EdgeInsets.only(bottom: 5),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(l.getLocalizedName(isAr), style: pw.TextStyle(fontSize: 14)),
                            pw.Text(l.level, style: pw.TextStyle(fontSize: 14, color: PdfColors.blue700)),
                          ]
                        ),
                      )).toList(),
                    ),
                    pw.SizedBox(height: 20),
                  ],

                  // Experience
                  if (cv != null && cv.experiences.isNotEmpty) ...[
                    pw.Text('orders.cv_experience'.tr(), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#004b87'))),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: cv.experiences.map<pw.Widget>((e) => pw.Container(
                        margin: const pw.EdgeInsets.only(bottom: 10),
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(8)),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(e.getLocalizedTitle(isAr).isNotEmpty ? e.getLocalizedTitle(isAr) : 'orders.exp_worker'.tr(), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("\${'orders.country'.tr()}: \${e.getLocalizedCountry(isAr).isNotEmpty ? e.getLocalizedCountry(isAr) : 'orders.unknown_country'.tr()}", style: const pw.TextStyle(fontSize: 12)),
                                pw.Text("\${'orders.duration'.tr()}: \${e.duration}", style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                              ]
                            )
                          ]
                        )
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'CV_\${candidate.name.replaceAll(" ", "_")}.pdf',
    );
  }

  static pw.Widget _buildInfoBox(String label, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          pw.SizedBox(height: 4),
          pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ]
      )
    );
  }
}
