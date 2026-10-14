import 'mood_scale.dart';

class MoodAdvice {
  const MoodAdvice({required this.description, required this.suggestion});

  final String description;
  final String suggestion;
}

/// 3×3 mood matrix sections, each with several rotating tips.
class MoodAdviceService {
  MoodAdviceService._();

  static MoodAdvice forMood({
    required int energyPercent,
    required int pleasantnessPercent,
    DateTime? date,
  }) {
    final int e = MoodScale.toPercent(energyPercent);
    final int p = MoodScale.toPercent(pleasantnessPercent);
    final int row = (e / 34).floor().clamp(0, 2); // low → high energy
    final int col = (p / 34).floor().clamp(0, 2); // low → high pleasantness
    final int section = row * 3 + col;

    final ({String description, List<String> tips}) pack = _sections[section];
    final int daySeed =
        date == null
            ? e * 31 + p
            : date.year * 10000 + date.month * 100 + date.day;
    final int tipIndex = (daySeed + section * 17) % pack.tips.length;

    return MoodAdvice(
      description: pack.description,
      suggestion: pack.tips[tipIndex],
    );
  }

  static const List<({String description, List<String> tips})> _sections =
      <({String description, List<String> tips})>[
        // 0 low energy / low pleasantness
        (
          description:
              'Низкая энергия и мало приятности — день просит бережности и восстановления',
          tips: <String>[
            'тёплый душ, тихая музыка и ранний сон',
            'короткая прогулка без телефона',
            'простая еда и вода, без лишних задач',
            'написать три строки о том, что тяжело',
            'попросить помощи у близкого человека',
          ],
        ),
        // 1 low energy / mid pleasantness
        (
          description:
              'Спокойная зона: энергии немного, но день ощущается мягче',
          tips: <String>[
            'медленное утро или вечер без спешки',
            'чай, книга или спокойный подкаст',
            'лёгкая растяжка или йога 10 минут',
            'навести порядок в одной маленькой зоне',
            'поблагодарить себя за что-то простое',
          ],
        ),
        // 2 low energy / high pleasantness
        (
          description:
              'Низкая энергия и много тепла — хорошо для покоя и мягкой радости',
          tips: <String>[
            'уютный ритуал: плед, фильм, вкусная еда',
            'спокойное творчество без цели',
            'тёплый разговор с тем, кто радует',
            'дневник благодарности на 5 пунктов',
            'нежный уход за собой без списка дел',
          ],
        ),
        // 3 mid energy / low pleasantness
        (
          description:
              'Есть силы, но день напряжённый — важно направить энергию бережно',
          tips: <String>[
            'короткая физическая разрядка: быстрая ходьба',
            'список «что могу отложить» и вычеркнуть лишнее',
            'дыхание 4–7–8 пару циклов',
            'разобрать один раздражающий мелкий хвост',
            'ограничить новости и ленту на вечер',
          ],
        ),
        // 4 mid / mid
        (
          description:
              'Сбалансированное состояние — удобный момент для спокойных шагов',
          tips: <String>[
            'один важный фокус на час без отвлечений',
            'прогулка и лёгкая зарядка',
            'планирование завтра без перфекционизма',
            'хобби 20–30 минут',
            'проверить сон и воду — база баланса',
          ],
        ),
        // 5 mid energy / high pleasantness
        (
          description:
              'Устойчивая энергия и приятность — хорошо для лёгкого роста',
          tips: <String>[
            'сделать приятное дело для себя или другого',
            'небольшое творческое задание',
            'встреча или звонок, который поднимает настроение',
            'зафиксировать, что сегодня сработало',
            'научиться одной маленькой новой штуке',
          ],
        ),
        // 6 high energy / low pleasantness
        (
          description:
              'Высокая энергия и низкая приятность — тело готово действовать, эмоции насторожены',
          tips: <String>[
            'интенсивная тренировка или уборка «на злости»',
            'выписать раздражение на бумагу и порвать лист',
            'спорт, танцы или быстрая работа руками',
            'честный разговор о границе, которая нарушена',
            'канал для энергии: проект, ремонт, спорт',
          ],
        ),
        // 7 high energy / mid pleasantness
        (
          description:
              'Много сил при умеренной приятности — отличный момент для движения вперёд',
          tips: <String>[
            'закрыть 1–2 давно висящих задачи',
            'тренировка или активная прогулка',
            'структурировать неделю на бумаге',
            'попробовать новый маршрут или активность',
            'направить драйв в полезный мини-проект',
          ],
        ),
        // 8 high energy / high pleasantness
        (
          description:
              'Пик энергии и приятности — время творить, делиться и пробовать новое',
          tips: <String>[
            'творческий рывок или старт идеи',
            'активность с людьми, которые заряжают',
            'смелый, но радостный шаг в проекте',
            'записать удачный день, чтобы вернуться к нему позже',
            'поделиться теплом: комплимент, помощь, сюрприз',
          ],
        ),
      ];
}
