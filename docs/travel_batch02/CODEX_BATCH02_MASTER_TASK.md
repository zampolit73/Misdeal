> Исходное задание пакета для трассируемости. Новая пользовательская задача разрешила интеграцию; фактический статус и проверка — ../TRAVEL_BATCH02_V2.md.

> **V2:** сначала читать V2_INTEGRATION.md. Переносить actor_stage отдельно для каждого из 11 исправленных действий; не восстанавливать удалённые руки. Утверждённые базовые и финальные PNG не менялись.

# Misdeal — внедрение утверждённого Batch02 одним PR

Этот пакет — материалы для художественного утверждения, а не уже внесённая фича. Приступать к внедрению только после единого итогового выбора пользователя. Не принимать этот документ за разрешение менять GitHub сейчас.

1. Проверить актуальный main, AGENTS и документы; создать одну codex/ ветку. Сверить source hashes MANIFEST и 31outcome. Семь ранее внедрённых сцен не менять.
2. Перенести графику семи папок в новые `assets/pixel/travel/batch_02/<card_id>/`; исходные original_master сохранять. PREVIEW_PROJECT/reference — офлайн-инструмент, не новый игровой runtime и не замена D412.
3. Создать семь небольших data-driven TravelTransitionData ресурсов в `resources/travel/batch_02/` и семь явных CATALOG.LOCATIONS entries. Реализовать batch-local panorama на существующем интерфейсе build/configure/update_time/stage_party. Не переписывать travel_transition, SceneRouter, сохранения или боевую систему. Сохранять существующий missing-art fallback.
4. `scripts/event/act_choice.gd`: добавить только локальные transient признаки фактически успешного выбора. _finish уже захватывает travel_context ДО complete_active_card, затем сохраняет слот. Сохранить этот порядок и guard. Разрешённое расширение optional presentation dictionary в context_for не сериализуется.
5. Candle: роль после успешного _grant_role_upgrade и списания 25gold. Forge: artifact_id после успешного add_artifact. Leave: явный transient leave, а не новый event_outcome. Ledger/tithe/crown: существующие saved исходы плюс transient leave, где нужно.
6. Debtor gamble и bridge rush: результат одного существующего броска передать в presentation; ни одного нового randf. Нельзя угадывать ветку по окончательному золоту, HP, артефактам или тексту.
7. Bridge: capture recruitment-mode ДО recruit/lose; записать post-choice party_roles после настоящего эффекта. NPC и Ranger actor никогда не рисуются одновременно при recruit. У обычных rush/scavenge/careful отдельного NPC нет. Соответствующие варианты доступны только при настоящем can_recruit_companion.
8. Перенести timing и координаты из staging.json/poses.json, но оставить один V2 clock/CanvasGroup/veil. Не проигрывать MP4 вместо динамической партии. RGB finals — эталон сравнения/aftermath, а не повод впечь героев. Связанные арки/ткань/крепления всегда двигаются вместе. Пустые крепления должны скрывать старый предмет, включая foreground.
9. Один общий F6-preview на 31 случай, реальные solo/duo/trio, нормальный и recruitment bridge, pause/skip. Один реальный event-cycle на локацию, цены/награды применяются один раз. Existing GUT/requiredCI; не создавать QA-фреймворк ради этого пакета. Проверить перезапуск/сохранение без replay эффектов и все семь старых Travel.
10. Обновить только необходимые проектные документы/CHANGELOG/HANDOFF кратко. Один общий PR с нативными кадрами/видео. Не auto-merge: пользователь сначала оценивает весь художественный результат.

Входной аудит main: reference/SOURCE_AUDIT.json. Код act_choice.gd проверен через GitHub и локальный blob a6f04e48c1a8f36510c64120355f183c7691d8c4. Точные дальнейшие инструкции и таблицы 31 ветки — в семи CODEX_IMPLEMENTATION.md.

Масштаб actor считать от max_visible_height всех 6walk кадров данного роли/ракурса, а подошву — от текущего frame. Не делить желаемый рост на текущую высоту отдельного кадра: это вызывает пульсацию.
