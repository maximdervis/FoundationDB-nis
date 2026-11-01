# P09-A. FoundationDB: транзакции и отказы

[Назначенное задание](https://distsys.ru/osukhoroslov/nis2/src/branch/main/project-tasks/p09-a-foundationdb-transactions.md)

Участники: Дервис Максим, Сабгир София, Широковских Александр.

## Сокращённый запуск

Требуется Docker. Проверка первой контрольной точки запускает официальный образ FoundationDB, ждёт готовности базы и выполняет транзакцию `set/get/commit`:

```bash
./scripts/checkpoint1-smoke.sh
```

Ожидаемый результат: база доступна, значение `nis/checkpoint1/probe` равно `ok`, транзакция подтверждена. Это только проверка технической реализуемости; многопроцессный стенд и отказ входят в следующий этап.

## Навигация

- [Детализация проекта](nis/project.md)
- [План эксперимента](nis/experiment-plan.md)
- [Контрольная точка 1](nis/checkpoints/01.md)
- [Сценарий технической проверки](scripts/checkpoint1-smoke.sh)
- [Среда проверки](evidence/checkpoint-1/environment.md)
- [Результат проверки](evidence/checkpoint-1/smoke-test.md)
- [Пробный журнал метрик](evidence/checkpoint-1/sample-journal.ndjson)
- [Проверка расчёта метрик](evidence/checkpoint-1/metrics-preflight.md)

## Описание применения генеративной модели

- Цель: структурировать требования, подготовить черновики документов и smoke-test.
- Модель и источник: OpenAI Codex (GPT-5), OpenAI.
- Проверка: требования сверены с карточкой задания, команды выполнены локально; фактический вывод сохранён в `evidence/`.
