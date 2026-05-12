import 'package:docx_to_text/docx_to_text.dart';
import 'package:codelearn/models/question.dart';
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
      final text = docxToText(bytes);
      return parseText(text);
    } else if (ext == 'pdf') {
      final document = PdfDocument(inputBytes: bytes);
      final buffer = StringBuffer();
      final extractor = PdfTextExtractor(document);
      for (int i = 0; i < document.pages.count; i++) {
        buffer.writeln(extractor.extractText(startPageIndex: i, endPageIndex: i));
      }
      document.dispose();
      return parseText(buffer.toString());
    } else {
      throw Exception('Unsupported format: .$ext');
    }
  }
 
  static List<ParsedQuestion> parseText(String text) {
    // ── Step 1: normalize the text ─────────────────────────────────────────
    // Join lines so "A)\n text" becomes "A) text"
    // Replace  А) В) С) Д) Е) (Cyrillic) → a) b) c) d) e) (internal marker)
    // Replace  A) B) C) D) E) (Latin, with possible space) → same
 
    final lines = text.split('\n');
    final normalized = <String>[];
 
    for (var line in lines) {
      // Trim
      line = line.trim();
      if (line.isEmpty) continue;
 
      // Fix "С ) text" → "С) text" (space between letter and bracket)
      line = line.replaceAllMapped(
        RegExp(r'^([A-EА-ЕАВСДЕabcdeабвгд])\s+\)'),
        (m) => '${m.group(1)})',
      );
 
      normalized.add(line);
    }
 
    // Join lines: if a line starts with option prefix, merge with previous 
    // empty-ish continuation (handles "A)\nАристотель" case)
    final merged = <String>[];
    for (int i = 0; i < normalized.length; i++) {
      final line = normalized[i];
      // If previous line was JUST "A)" with no text after, merge next line
      if (merged.isNotEmpty) {
        final prev = merged.last;
        // prev is bare option like "A)" or "В)"
        if (RegExp(r'^[A-EА-ЕАВСДЕabcdeабвгд]\)$').hasMatch(prev)) {
          merged[merged.length - 1] = '$prev $line';
          continue;
        }
      }
      merged.add(line);
    }
 
    // ── Step 2: parse questions ────────────────────────────────────────────
    final questions = <ParsedQuestion>[];
    ParsedQuestion? current;
 
    // Option prefix: A) B) C) D) E) and Cyrillic equivalents А) В) С) Д) Е)
    // Also handles lowercase
    final optionPrefix = RegExp(
      r'^([A-EА-ЕАВСДЕabcdeабвгд])\)\s*(.*)',
      caseSensitive: false,
    );
 
    // Question: starts with digit(s) followed by . or )
    final questionPrefix = RegExp(r'^(\d+)[.)]\s+(.+)');
 
    for (final line in merged) {
      final qMatch = questionPrefix.firstMatch(line);
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
 
      if (current != null) {
        final oMatch = optionPrefix.firstMatch(line);
        if (oMatch != null) {
          final optText = oMatch.group(2)!.trim();
          if (optText.isNotEmpty) {
            current.options.add(optText);
          }
        }
      }
    }
 
    if (current != null && current.options.isNotEmpty) {
      questions.add(current);
    }
 
    return questions;
  }
 
  static List<Question> toQuestions(List<ParsedQuestion> parsed) {
    return parsed.map((p) {
      final options = p.options.asMap().entries.map((e) => Option(
            id: String.fromCharCode(97 + e.key),
            text: e.value,
          )).toList();
      return Question(
        id: 'q_${p.number}',
        text: p.text,
        options: options,
        correctOptionID: 'a', // First option is always correct
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
 