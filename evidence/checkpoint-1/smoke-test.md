# Результат smoke-test

Команда:

```bash
./scripts/checkpoint1-smoke.sh
```

Проверяется доступность базы и одна транзакция `set/get/commit`.

Фактический вывод 31 октября 2026 года (UTC):

```text
The database is available.
>>> writemode on
>>> begin
Transaction started
>>> set nis/checkpoint1/probe ok
>>> get nis/checkpoint1/probe
`nis/checkpoint1/probe' is `ok'
>>> commit
Committed (2345476)
`nis/checkpoint1/probe' is `ok'
image=foundationdb/foundationdb@sha256:3d47a2e9ee389199f1d320c985bc95a3d4eb701d9b2b5c2add8a2285588fd4fe
```

Итог: официальный Linux/ARM64-образ совместим со стендом; база доступна, запись читается до и после подтверждённого коммита. Скрипт проверяет эти признаки и удаляет только созданный им временный контейнер.
