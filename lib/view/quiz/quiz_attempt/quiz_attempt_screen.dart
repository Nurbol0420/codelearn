import 'dart:async';
import 'dart:math';

import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/models/question.dart';
import 'package:codelearn/models/quiz.dart';
import 'package:codelearn/models/quiz_attempt.dart';
import 'package:codelearn/repositories/quiz_repository.dart';
import 'package:codelearn/view/quiz/quiz_attempt/widgets/quiz_attempt_app_bar.dart';
import 'package:codelearn/view/quiz/quiz_attempt/widgets/quiz_navigation_bar.dart';
import 'package:codelearn/view/quiz/quiz_attempt/widgets/quiz_question_page.dart';
import 'package:codelearn/view/quiz/quiz_attempt/widgets/quiz_submit_dialog.dart';
import 'package:codelearn/view/quiz/quiz_result/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizAttemptScreen extends StatefulWidget {
  final String quizId;
  const QuizAttemptScreen({super.key, required this.quizId});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  Quiz? _quiz;
  bool _isLoadingQuiz = true;
  final _quizRepo = QuizRepository();

  List<_ShuffledQuestion> _shuffled = [];

  late final PageController _pageController;
  int _currentPage = 0;
  Map<String, String> selectedAnswers = {};
  int remainingSeconds = 0;
  Timer? _timer;
  QuizAttempt? currentAttempt;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    try {
      final quizzes = await _quizRepo.getQuizzes();
      final quiz = quizzes.firstWhere(
        (q) => q.id == widget.quizId,
        orElse: () => throw Exception('Quiz not found'),
      );
      if (!mounted) return;
      setState(() {
        _quiz = quiz;
        _isLoadingQuiz = false;
        _shuffled = quiz.questions.map((q) {
          final opts = List<Option>.from(q.options)..shuffle(Random());
          return _ShuffledQuestion(
            question: q,
            shuffledOptions: opts,
            correctOptionId: q.correctOptionID,
          );
        }).toList();
        remainingSeconds = _quiz!.timeLimit * 60;
      });
      _startTimer();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingQuiz = false);
      Get.back();
    }
  }

  void _onPageChanged() {
    if (_pageController.page != null) {
      setState(() => _currentPage = _pageController.page!.round());
    }
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        _submitQuiz();
      }
    });
  }

  int _calculateScore() {
    int score = 0;
    for (final sq in _shuffled) {
      final selectedId = selectedAnswers[sq.question.id];
      if (selectedId != null) {
        final selectedOption = sq.shuffledOptions.firstWhere(
          (o) => o.id == selectedId,
          orElse: () => Option(id: '', text: ''),
        );
        final correctOption = sq.question.options.firstWhere(
          (o) => o.id == sq.correctOptionId,
          orElse: () => Option(id: '', text: ''),
        );
        if (selectedOption.text == correctOption.text) {
          score += sq.question.points;
        }
      }
    }
    return score;
  }

  Future<void> _submitQuiz() async {
    _timer?.cancel();
    final score = _calculateScore();
    currentAttempt = QuizAttempt(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      quizId: _quiz!.id,
      userId: 'current_user',
      answers: selectedAnswers,
      score: score,
      startedAt: DateTime.now()
          .subtract(Duration(seconds: _quiz!.timeLimit * 60 - remainingSeconds)),
      completedAt: DateTime.now(),
      timeSpent: _quiz!.timeLimit * 60 - remainingSeconds,
    );
    await _quizRepo.saveAttempt(currentAttempt!);
    Get.off(() => QuizResultScreen(attempt: currentAttempt!, quiz: _quiz!));
  }

  void _selectAnswer(String questionId, String optionId) {
    setState(() => selectedAnswers[questionId] = optionId);
  }

  String get formattedTime {
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: QuizAttemptAppBar(
        formattedTime: formattedTime,
        onSubmit: () => _showSubmitDialog(context),
      ),
      body: _isLoadingQuiz
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: _shuffled.length,
              itemBuilder: (context, index) {
                final sq = _shuffled[index];
                final displayQuestion = Question(
                  id: sq.question.id,
                  text: sq.question.text,
                  options: sq.shuffledOptions,
                  correctOptionID: sq.correctOptionId,
                  points: sq.question.points,
                );
                return QuizQuestionPage(
                  questionNumber: index + 1,
                  totalQuestion: _shuffled.length,
                  question: displayQuestion,
                  selectedOptionId: selectedAnswers[sq.question.id],
                  onOptionSelected: (optionId) =>
                      _selectAnswer(sq.question.id, optionId),
                );
              },
            ),
      bottomNavigationBar: QuizNavigationBar(
        theme: theme,
        onPreviousPressed:
            _currentPage > 0 ? () => _navigateToPage(_currentPage - 1) : null,
        onNextPressed: _currentPage < _shuffled.length - 1
            ? () => _navigateToPage(_currentPage + 1)
            : null,
        isLastPage: _currentPage == _shuffled.length - 1,
      ),
    );
  }

  Future<void> _showSubmitDialog(BuildContext context) async {
    final score = _calculateScore();
    currentAttempt = QuizAttempt(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      quizId: _quiz!.id,
      userId: 'current_user',
      answers: selectedAnswers,
      score: score,
      startedAt: DateTime.now()
          .subtract(Duration(seconds: _quiz!.timeLimit * 60 - remainingSeconds)),
      timeSpent: _quiz!.timeLimit * 60 - remainingSeconds,
      completedAt: DateTime.now(),
    );
    return showDialog(
      context: context,
      builder: (context) =>
          QuizSubmitDialog(attempt: currentAttempt!, quiz: _quiz!),
    );
  }
}

/// Holds a question with its options shuffled for this attempt.
class _ShuffledQuestion {
  final Question question;
  final List<Option> shuffledOptions;
  final String correctOptionId;

  _ShuffledQuestion({
    required this.question,
    required this.shuffledOptions,
    required this.correctOptionId,
  });
}