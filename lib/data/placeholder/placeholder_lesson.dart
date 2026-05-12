/// Placeholder demo lesson.
///
/// Exercises all 14 micro-screen templates and every interaction type with
/// stub content so the shell can be navigated end-to-end. NO REAL CURRICULUM
/// CONTENT lives here — that's Part Two. These questions are intentionally
/// generic and not derived from any lesson plan.
library;

import '../../features/lesson/interactions/interaction_types.dart';
import '../../features/lesson/micro_screen_spec.dart';

class PlaceholderLesson {
  const PlaceholderLesson._();

  static List<MicroScreenSpec> build() => [
        const MicroScreenSpec(
          id: 'demo_1',
          kind: MicroScreenKind.visualHook,
          prompt: "Watch the shapes appear.",
          lessonTitle: 'Demo lesson',
        ),
        const MicroScreenSpec(
          id: 'demo_2',
          kind: MicroScreenKind.observation,
          prompt: 'Try the slider. What do you notice?',
          config: SliderExploreConfig(
            prompt: 'Slide to explore',
            explanation: "Nicely explored — sliders let you see how a value changes things.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_3',
          kind: MicroScreenKind.workedExample,
          prompt: 'Watch each step.',
          config: WorkedExampleConfig(
            steps: [
              WorkedStep(
                title: 'Spot the pattern',
                body: 'Two circles sit next to each other.',
                why: "Noticing pairs is the first step of comparing.",
              ),
              WorkedStep(
                title: 'Look at the colour',
                body: 'The colour shows which group it belongs to.',
                why: "Colour is a quick way to group things together.",
              ),
              WorkedStep(
                title: 'Make the link',
                body: 'Match same-coloured pairs.',
                why: "Matching gives us our first answer.",
              ),
            ],
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_4',
          kind: MicroScreenKind.recognitionCheck,
          prompt: 'Match each shape to its name.',
          config: TapToMatchConfig(
            pairs: {
              '○': 'circle',
              '△': 'triangle',
              '□': 'square',
            },
            explanation: "Shapes get a name based on the number of sides.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_5',
          kind: MicroScreenKind.completion,
          prompt: 'Finish the sentence.',
          config: FillBlankConfig(
            beforeBlank: 'A triangle has ',
            afterBlank: ' sides.',
            correctAnswer: '3',
            options: ['2', '3', '4', '5'],
            explanation: "Triangles have exactly 3 sides.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_6',
          kind: MicroScreenKind.conceptImage,
          prompt: 'Which curve goes up to the right?',
          config: TapCorrectGraphConfig(
            prompt: 'Pick the curve that climbs as you go right.',
            correctIndex: 0,
            thumbnailPainters: [],
            explanation:
                "An increasing curve gets higher as x moves to the right.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_7',
          kind: MicroScreenKind.sliderIntuition,
          prompt: 'Slide to about the middle.',
          config: SliderExploreConfig(
            prompt: 'Aim for 0.5',
            target: 0.5,
            tolerance: 0.08,
            explanation: "0.5 is the centre between 0 and 1.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_8',
          kind: MicroScreenKind.buildExpression,
          prompt: 'Build: 2 + 3',
          config: BuildExpressionConfig(
            target: ['2', '+', '3'],
            tiles: ['2', '+', '3', '−', '4'],
            explanation: "We put the numbers and the operator in order.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_9',
          kind: MicroScreenKind.reorderSteps,
          prompt: 'Put the steps in order.',
          config: ReorderStepsConfig(
            correctOrder: [
              'Read the question',
              'Pick a strategy',
              'Do the maths',
              'Check the answer',
            ],
            fixedFirst: 'Read the question',
            fixedLast: 'Check the answer',
            explanation:
                "A good order: read, plan, solve, check.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_10',
          kind: MicroScreenKind.estimation,
          prompt: 'Estimate where 0.75 is.',
          config: SliderExploreConfig(
            prompt: 'Slide to 0.75',
            target: 0.75,
            tolerance: 0.08,
            explanation: "0.75 is three-quarters of the way along.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_11',
          kind: MicroScreenKind.mcq,
          prompt: 'Which is the largest?',
          config: McqConfig(
            prompt: 'Which is the largest?',
            options: ['12', '7', '21', '15'],
            correctIndex: 2,
            explanation: "21 has the highest value among these numbers.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_12',
          kind: MicroScreenKind.freeResponse,
          prompt: 'What is 6 × 7?',
          config: NumericResponseConfig(
            prompt: 'What is 6 × 7?',
            correctValue: 42,
            explanation: "6 sevens is 42 — try counting in sevens.",
          ),
        ),
        const MicroScreenSpec(
          id: 'demo_13',
          kind: MicroScreenKind.summary,
          prompt: '',
          summaryText:
              "You explored shapes, slid through values, and built an expression.",
        ),
        const MicroScreenSpec(
          id: 'demo_14',
          kind: MicroScreenKind.reward,
          prompt: '',
        ),
      ];
}
