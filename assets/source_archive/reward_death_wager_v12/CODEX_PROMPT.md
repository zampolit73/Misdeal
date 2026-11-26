# Codex — Death Wager Reward Visual V1.2

Работай в zampolit73/Misdeal, актуальный main, Godot 4.7.x/GDScript. Прочитай AGENTS.md и текущие docs/PROJECT_STATE.md, docs/DESIGN_SYSTEM.md, docs/ROADMAP.md. Арт и композиция «Выигрыш ставки» V1.2 утверждены. Этот пакет заменяет V1/V1.1: приглушённая бронза, канонический Волшебник и единая геральдика. Используй только новый runtime, не перерисовывай.

1. Распакуй приложенный Misdeal_Reward_Death_Wager_V1_2_Art_Pack.zip, проверь manifest.json. Внедри runtime и layout по README.md. Архивируй референс, clean master и provenance по действующим правилам.
2. Изучи reward.gd и уже внедрённые elite_trophy.gd, hero_development.gd, normal loot. Добавь отдельное presentation только для death_wager с чистой plate и реальными текстами, картами, изображениями и кнопками. Не меняй option_ids, reward rules, pending relic, выпадение, долг, сохранение/выдачу наград.
3. Используй живой ArtifactArtCatalog, а не примерную нарисованную реликвию. Правильно отобрази оба gold fallback (+50/+45), учитывая реальные состояние и предел развития. Сохрани переключение на Hero Development при bonus_upgrade, корректно убери внешний вид ставки и не оставляй старых слоёв или двойной обработки.
4. Управление и отзывчивость — существующий flow. Не копируй картинки с текстом, не добавляй новых механик. Никаких изменений остальных наград, игровых экранов, баланса или сейвов.
5. Проведи минимальную целевую нативную QA по README; отчитайся только о проведённых проверках. Обнови PROJECT_STATE, VISUAL_ASSET_REGISTRY, ROADMAP (после фактической интеграции закрой соответствующий visual reward milestone), DECISIONS (закрепи визуальный канон по README), HANDOFF и CHANGELOG; сделай осмысленный commit и доставь изменения в main согласно workflow проекта.
