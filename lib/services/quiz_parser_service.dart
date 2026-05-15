import 'package:codelearn/models/question.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class QuizParserService {
  static Future<List<ParsedQuestion>> pickAndParseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return [];

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) throw Exception('Could not read file bytes');

    final ext = (file.extension ?? '').toLowerCase();

    if (ext == 'docx') {
      return parseText(docxToText(bytes));
    } else if (ext == 'pdf') {
      final document = PdfDocument(inputBytes: bytes);
      final buffer = StringBuffer();
      final extractor = PdfTextExtractor(document);
      for (int i = 0; i < document.pages.count; i++) {
        buffer.writeln(
          extractor.extractText(startPageIndex: i, endPageIndex: i),
        );
      }
      document.dispose();
      return parseText(buffer.toString());
    } else {
      throw Exception('Unsupported format: .$ext');
    }
  }

  static List<ParsedQuestion> parseText(String text) {
    final normalized = text
        .split('\n')
        .map(_normalizeLine)
        .where((line) => line.isNotEmpty)
        .toList();

    final merged = <String>[];
    for (final line in normalized) {
      if (merged.isNotEmpty && _isBareOptionMarker(merged.last)) {
        merged[merged.length - 1] = '${merged.last} $line';
      } else {
        merged.add(line);
      }
    }

    final questions = <ParsedQuestion>[];
    ParsedQuestion? current;

    for (final line in merged) {
      final qMatch = _questionPrefix.firstMatch(line);
      if (qMatch != null) {
        if (current != null && current.options.isNotEmpty) {
          questions.add(current);
        }
        current = ParsedQuestion(
          number: int.parse(qMatch.group(1)!),
          text: qMatch.group(2)!.trim(),
          options: [],
        );
        continue;
      }

      if (current == null) continue;

      final oMatch = _optionPrefix.firstMatch(line);
      if (oMatch == null) continue;

      final optionText = oMatch.group(2)!.trim();
      if (optionText.isNotEmpty) {
        current.options.add(optionText);
      }
    }

    if (current != null && current.options.isNotEmpty) {
      questions.add(current);
    }

    return questions;
  }

  static final RegExp _questionPrefix = RegExp(r'^(\d+)\s*[.)]\s*(.+)$');

  static final RegExp _optionPrefix = RegExp(
    r'^([A-Ea-eА-Еа-еӘәБбВвГгДдСс])\s*[\).]\s*(.*)$',
  );

  static String _normalizeLine(String line) {
    return line
        .replaceAll('\u00A0', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static bool _isBareOptionMarker(String line) {
    return RegExp(r'^[A-Ea-eА-Еа-еӘәБбВвГгДдСс]\s*[\).]$').hasMatch(line);
  }

  static List<Question> toQuestions(List<ParsedQuestion> parsed) {
    return parsed.asMap().entries.map((entry) {
      final p = entry.value;
      final options = p.options.asMap().entries.map((e) {
        return Option(id: String.fromCharCode(97 + e.key), text: e.value);
      }).toList();
      return Question(
        id: 'q_${entry.key + 1}',
        text: p.text,
        options: options,
        correctOptionID: 'a',
        points: 1,
      );
    }).toList();
  }
}

class ParsedQuestion {
  final int number;
  final String text;
  final List<String> options;

  ParsedQuestion({
    required this.number,
    required this.text,
    required this.options,
  });
}
