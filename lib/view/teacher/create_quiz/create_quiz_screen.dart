import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/question.dart';
import 'package:codelearn/models/quiz.dart';
import 'package:codelearn/repositories/quiz_repository.dart';
import 'package:codelearn/services/quiz_parser_service.dart';
import 'package:codelearn/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:codelearn/view/teacher/create_quiz/widgets/parsed_questions_preview.dart';
import 'package:codelearn/view/teacher/create_quiz/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateQuizScreen extends StatefulWidget {
  final Quiz? quiz;
  const CreateQuizScreen({super.key, this.quiz});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeLimitController = TextEditingController(text: '30');
  final _quizRepository = QuizRepository();

  List<Question> _questions = [];
  bool _isLoading = false;
  bool _isParsingFile = false;

  @override
  void initState() {
    super.initState();
    if (widget.quiz != null) {
      _titleController.text = widget.quiz!.title;
      _descriptionController.text = widget.quiz!.description;
      _timeLimitController.text = widget.quiz!.timeLimit.toString();
      _questions = List.from(widget.quiz!.questions);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  // ─── Pick & parse file (Web + Mobile) ──────────────────────────────────────
  Future<void> _pickDocxFile() async {
    final errorLabel = AppLocalizations.of(context)!.error;
    final parseError = AppLocalizations.of(context)!.failedToParseFile;
    final noQuestionsMsg = AppLocalizations.of(context)!.noQuestionsFound;

    try {
      setState(() => _isParsingFile = true);

      final parsed = await QuizParserService.pickAndParseFile();

      setState(() => _isParsingFile = false);

      if (parsed.isEmpty && !mounted) return;

      if (parsed.isEmpty) {
        Get.snackbar(errorLabel, noQuestionsMsg,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      // Show preview bottom sheet
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ParsedQuestionsPreview(
          parsed: parsed,
          onConfirm: () {
            Navigator.pop(context);
            final questions = QuizParserService.toQuestions(parsed);
            setState(() => _questions.addAll(questions));
            final l10n = AppLocalizations.of(context)!;
            Get.snackbar(l10n.success, '${parsed.length} ${l10n.questionsAdded}',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
          },
          onCancel: () => Navigator.pop(context),
        ),
      );
    } catch (e) {
      setState(() => _isParsingFile = false);
      Get.snackbar(errorLabel, '$parseError: $e',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ─── Submit ────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      Get.snackbar(l10n.error, l10n.addAtLeastOneQuestion,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final quiz = Quiz(
        id: widget.quiz?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        timeLimit: int.tryParse(_timeLimitController.text) ?? 30,
        questions: _questions,
        createdAt: widget.quiz?.createdAt ?? DateTime.now(),
        isActive: true,
      );

      if (widget.quiz != null) {
        await _quizRepository.updateQuiz(quiz);
        Get.back();
        Get.snackbar(l10n.success, l10n.quizUpdatedSuccess,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await _quizRepository.createQuiz(quiz);
        Get.back();
        Get.snackbar(l10n.success, l10n.quizCreatedSuccess,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      final l10n2 = AppLocalizations.of(context)!;
      Get.snackbar(l10n2.error, '${l10n2.failedToSaveQuiz}: $e',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ─── UI ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // AppBar
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                actions: [
                  TextButton.icon(
                    onPressed: _isLoading ? null : _submit,
                    icon: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save, color: Colors.white),
                    label: Text(l10n.save, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(16),
                  title: Text(
                    widget.quiz != null ? l10n.editQuizTitle : l10n.createQuizTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  background: Container(decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  )),
                ),
              ),

              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Quiz Info Card ─────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              CustomTextfield(
                                controller: _titleController,
                                label: l10n.quizTitleLabel,
                                hint: l10n.quizTitleHint,
                                prefixIcon: Icons.quiz_outlined,
                                validator: (v) => (v?.isEmpty ?? true) ? l10n.quizTitleRequired : null,
                              ),
                              const SizedBox(height: 16),
                              CustomTextfield(
                                controller: _descriptionController,
                                label: l10n.quizDescriptionLabel,
                                hint: l10n.quizDescriptionHint,
                                prefixIcon: Icons.description_outlined,
                                maxLines: 2,
                                validator: (v) => (v?.isEmpty ?? true) ? l10n.quizDescriptionRequired : null,
                              ),
                              const SizedBox(height: 16),
                              CustomTextfield(
                                controller: _timeLimitController,
                                label: l10n.timeLimitLabel,
                                hint: l10n.timeLimitHint,
                                prefixIcon: Icons.timer_outlined,
                                keyboardType: TextInputType.number,
                                validator: (v) => (v?.isEmpty ?? true) ? l10n.timeLimitRequired : null,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Upload Word file ───────────────────────────────
                        Text(l10n.uploadDocxTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        _buildUploadBox(l10n),

                        const SizedBox(height: 8),
                        // Format hint
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                                const SizedBox(width: 6),
                                Text(l10n.formatHintTitle, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                              ]),
                              const SizedBox(height: 6),
                              Text(l10n.formatHintBody, style: TextStyle(color: Colors.blue.shade700, fontSize: 12)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Questions list ─────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.questionsLabel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                              child: Text('${_questions.length}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (_questions.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            alignment: Alignment.center,
                            child: Column(children: [
                              Icon(Icons.quiz_outlined, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(l10n.noQuestionsYet, style: TextStyle(color: Colors.grey.shade500)),
                            ]),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _questions.length,
                            itemBuilder: (context, i) => QuestionCard(
                              question: _questions[i],
                              index: i,
                              onDelete: () => setState(() => _questions.removeAt(i)),
                              onCorrectChanged: (correctIdx) {
                                setState(() {
                                  final q = _questions[i];
                                  _questions[i] = Question(
                                    id: q.id, text: q.text,
                                    options: q.options,
                                    correctOptionID: q.options[correctIdx].id,
                                    points: q.points,
                                  );
                                });
                              },
                            ),
                          ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _isParsingFile ? null : _pickDocxFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5, style: BorderStyle.solid),
        ),
        child: _isParsingFile
            ? Column(children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(l10n.parsingFile, style: const TextStyle(color: AppColors.primary)),
              ])
            : Column(children: [
                const Icon(Icons.upload_file, size: 48, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(l10n.uploadDocxButton, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(l10n.uploadDocxSub, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ]),
      ),
    );
  }
}
