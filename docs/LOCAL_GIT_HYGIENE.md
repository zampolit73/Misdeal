# Misdeal — Windows / Godot 4.7.x: безопасная диагностика локального Git

**Область:** только локальная рабочая папка на компьютере игрока. GitHub не может изменить локальные незакоммиченные файлы через подключение к репозиторию. Запускать из `C:\Users\irlix\GodotProjects\Misdeal` после `git pull`.

## Что обнаружено 2026-11-03

Из пользовательского PowerShell-лога:

- `main...origin/main`, `Fast-forward` и `git log -1` указывали на `ccc9d202` после успешной загрузки A1M2. Ошибки `Unlink ... .git/objects/pack/*.idx` относились к фоновой оптимизации Git/файловой блокировке Windows, а не к содержимому Godot.
- Изменены примерно 26 **уже отслеживаемых** `addons/gut/**/*.import` плюс `project.godot` и `addons/gut/gui/EditorRadioButton.tres`.
- Большое количество **неотслеживаемых** `assets/**/*.import`, `scripts/**/*.gd.uid`, `shaders/**/*.gdshader.uid`; один локальный `scenes/dev/grave_toll_smoke.tscn` и в некоторых выводах экспериментальный `scripts/alternative/`.
- **Нельзя утверждать, что содержимое изменённых файлов не нужно**: точный локальный `git diff` для `project.godot` и GUT Theme пока неизвестен.

### Правила безопасности

**Не игнорировать и не удалять пачкой `*.import` и `*.uid`.** Официальная документация Godot рекомендует коммитить import-файлы (параметры импорта и идентификаторы ассетов) и UID файлы (устойчивые ссылки скриптов/шейдеров). В `.gitignore` проекта уже скрыт временный каталог `.godot/`. Часть `.import` отслеживается Git; `.gitignore` в любом случае **не скрывает модификации уже отслеживаемых файлов**.

Источники: [Godot: Import process](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html), [Godot: UID changes](https://godotengine.org/article/uid-changes-coming-to-godot-4-4/).

Не запускать наугад `git clean -fd`, `git reset --hard`, `git add -A`, массовые `git rm` и `Remove-Item *.uid`: можно потерять локальные проектные файлы или создать плохую смену UID.

## Новый безопасный инструмент

`scripts/dev/local_git_hygiene.ps1` — **по умолчанию только отчёт**. Собирает количества GUT import модификаций, других изменённых отслеживаемых файлов, новых `.import`, новых `.uid` и прочих новых файлов; отдельно выводит реальные локальные diff `project.godot` и GUT Theme. Без удаления, `git add`, `git reset` или изменения настройки Git.

Из PowerShell в папке проекта:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\dev\local_git_hygiene.ps1
```

**Опционально**, после закрытия Godot, можно восстановить ТОЛЬКО уже отслеживаемые изменённые `addons/gut/**/*.import` в той версии, которая пришла из Git:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\dev\local_git_hygiene.ps1 -RestoreGutImports
```

Перед восстановлением все такие файлы копируются во внешнюю папку `%TEMP%\Misdeal-GitBackup-<дата>`. Если скрипт не смог создать бэкап, восстановление не должно запускаться. Другие файлы, включая `project.godot`, `.tres`, сцену, все `assets/**/*.import` и `*.uid`, **не меняются**. После открытия Godot часть metadata может снова измениться — тогда надо сравнивать настройки/версию плагина GUT, а не скрывать проблему.

## Дополнительные проверки только по необходимости

```powershell
git diff -- project.godot addons/gut/gui/EditorRadioButton.tres
git status -sb
git log -1 --oneline
```

Если Windows снова запрещает удалять `.git/objects/pack/*.idx`, не отвечать бесконечно `y`; можно нажать `n` и затем, после закрытия Godot/IDE, отдельно повторить:

```powershell
git -c gc.auto=0 pull --ff-only origin main
```

Это не постоянное отключение автообслуживания Git, а параметр **одной** команды. Не удалять вручную `.git/objects/pack/*.pack` или `.idx`.

## Что решить после отчёта

1. Если `project.godot` и GUT Theme изменены только автоматически, сохранить diff/бэкап, а потом точечно вернуть их в репозиторную версию. Если есть нужная локальная настройка — согласовать и внести её в GitHub отдельно.
2. Новые `.import` и `.uid` надо со временем **версионировать** при обоснованной синхронизации настроек импорта и UID, особенно если материалы/скрипты реально используются в игре. **Текущий GitHub не содержит точных байтов локальных UID/sidecar**, поэтому нельзя генерировать и заливать выдуманные UID с сервера.
3. Пока Git синхронизирован, статус `M` и `??` сам по себе не означает ошибку игры. Не устраивать агрессивную уборку перед F5; проверить A1M1/A1M2 в локальном Godot, как предписано в `docs/A1M2_CASTLE_MEMORY_EXPANSION.md`.
