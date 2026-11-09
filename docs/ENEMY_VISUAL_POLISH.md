# D420 — качество фигурок и анимации всех врагов

Задача пользователя: повысить качество рисунка и анимации всех врагов, индивидуально скорректировать рост, сохранить общий мир Misdeal. База — актуальный GitHub main `c7d9d332`. Отдельная ветка: `codex/enemy-visual-polish`.

Доставка: [PR90](https://github.com/zampolit73/Misdeal/pull/90), [проверки окончательного head](https://github.com/zampolit73/Misdeal/pull/90/checks). PR автоматически запускает полный RELEASE, включая отдельные20 кадров всех врагов. Прежний atlas fallback сохраняет свой прежний масштаб.

## Объём и происхождение

24 визуальные роли врагов, включая обычную нежить, Пастыря/ягнёнка, погребальную процессию, лабораторию, кукольников, утопленников, пять ролей Чёрного Фонаря и трёх актёров Суда. Ресурсы `bone_raider` и `crypt_sentinel` используют существующие роли и сохраняют свои отличия масштаба/характеристик. Герои D412 и Джек не перерисовываются.

Новые рисунки создаются встроенным `image_gen`: это иллюстративные исходники для пиксельных миниатюр, не ручная пиксельная отрисовка. Для каждой роли — один полный набор 25 самостоятельных поз: idle4 / walk6 / attack6 / hit3 / death6. Точные прежние костюмы, оружие и предметы берутся из фактических игровых кадров. Исходные игровые атласы сохранены. Для скелета выполнена дополнительная коррекция отступов и целого щита.

- Исходные игровые кадры и инвентаризация: `assets/source_archive/enemy_visual_polish/baseline/`.
- Новые полные исходники: `assets/source_archive/enemy_visual_polish/generated/<role>_source.png`.
- Упаковка: `scripts/dev/pack_enemy_visuals.gd`, один коэффициент на все позы роли, RGBA96×96, 6×5, пять пустых ячеек, подошвы y92, lossless WebP/Base64. Не синтезирует позы из одного рисунка.
- Runtime и хеши: `assets/pixel/units/enemy_visual_polish/`, `manifest.json`.

## Анимация и рост

Ходьба врагов теперь выбирает кадр по реальному пройденному расстоянию; остановленный юнит не перебирает ногами во время гистерезиса. Атака и попадание остаются на исходных временных шкалах. Нарисованный HIT заменяет увеличение корня юнита вместе с HP; при смерти сбрасываются остатки масштаба/поворота/удара перед первым DEATH. Полоса HP поднимается над реальной верхней границей idle-силуэта. Коррекции роста затрагивают только ArtSprite/RimSprite, не физику, AI, скорость, радиусы, урон или баланс.

## Проверка и локальный просмотр

F6 `res://scenes/dev/enemy_visual_review.tscn`: четыре страницы по шесть врагов и три оригинальных героя для масштаба; пять кнопок состояний. Это реальные BattleUnit и игровые SpriteFrames. Автозахват GPU: `godot --path . res://scenes/dev/enemy_visual_review.tscn -- <absolute-output-directory>`.

Базовый GPU-захват 24 ролей × 5 состояний сохранён в `docs/qa/enemy_visual_polish/before/`; окончательные20 кадров — `after/`. Полный локальный GUT: **233/233**,53 скрипта,47 775 утверждений; дополнительная проверка всех HP/поз после этого: **3/3,364 утверждения**. Selector **15/15**. Нативные реальные бои: соло кладбище178.6px перемещения, трио Суд118.32px, дуэт Звонарь119.93px. D260 обычная раздача → настоящий бой Чёрного Фонаря → победа → награда → стол: PASS. Перерисованы все24 роли, а не только общий масштаб. GitHub RELEASE CI отражается в проверках PR90.

- [Нежить и Надзиратель](qa/enemy_visual_polish/after/page_0_idle.png)
- [Пастырь, процессия, лаборатория](qa/enemy_visual_polish/after/page_1_idle.png)
- [Кукольники, утопленники, Фонарь](qa/enemy_visual_polish/after/page_2_idle.png)
- [Фонарь и Суд](qa/enemy_visual_polish/after/page_3_idle.png)
- [Реальный бой на кладбище](qa/enemy_visual_polish/graveyard/06-live-1600ms.png)
- [Полная локальная матрица52 состояний, source2513b969](qa/enemy_visual_polish/full_matrix_manifest.json): PASS; отдельная проверка rollback/HP/всех поз **3/3,364 утверждения**. Финальный статус RELEASE — в проверках PR90.

Пределы проверки: это native GPU и автоматические игровые маршруты, не человеческое прохождение всей кампании. В Windows остаются сообщения о сертификатах/`user://logs`/недоступной записи настроек редактора; импорт и тесты заканчиваются успешно. D260 после успешного маршрута сообщает10 ObjectDB instances и1 resource при выходе; отсутствие shutdown-диагностик не заявляется. Действующие19 предупреждений GUT явно видны в полном прогоне.

Фонарный лучник: отдельный финальный рисунок `repairs/lantern_archer_attack3.png` восстанавливает деревянный лук в вытянутой руке кадра выпуска. Остальные24 позы его исходника не перерисовывались этим исправлением. При упаковке прежние LEFT-источники Жреца, Носильщика и Дорожного стража нормализуются до RIGHT; общий runtime разворачивает их к цели.

Пиксельная высота idle с реквизитом в игровом масштабе: скелет100, костяной лучник108, раб88, Звонарь115, страж122, Надзиратель142, Пастырь110, ягнёнок82, Жрец110, Носильщик109, алхимик103, гомункул98, кукольник110, марионетка96, паромщик110, утопленник100, дорожный страж110, фонарщик118, проводник126, служка96, фонарный лучник105, магистрат118, писец110, пристав118. Это настройки графики; физические размеры и параметры боя сохранены.

## Набор промптов

Для каждого `<role>` использованы исходный полный игровой атлас этой роли и `hero_c3_d412_polish/knight_packed.png` как ориентир качества. Общий финальный промпт:

> Misdeal game production animation sprite sheet. Upgrade exact enemy '<role>' from image1 to the same rich, readable small-scale painted pixel-miniature quality as accepted hero image2. Preserve EXACT enemy identity, species, outfit colors, weapons, held props and canonical RIGHT facing. Image1 is the authoritative full animation identity and poses. No substituting a generic skeleton/knight. Improve anatomy, readable hands gripping props, crisp bone/metal/cloth material highlights, coherent silhouette, stable body proportions and perspective. COMPLETE atlas: six columns, five rows, equal square cells, sheet aspect6:5. Row1 four subtly distinct idle drawings then2 empty cells; row2 six genuinely distinct planted-foot walk poses; row3 six appropriate attack anticipation/action/recovery poses with exact original weapons/props always present; row4 three distinct hit reaction drawings then3 empty; row5 six progressive death drawings ending in grounded corpse. Exactly25 distinct whole-character poses, five empty alpha-clear cells. Every pose COMPLETE with generous20% transparent margins around figure AND all weapons inside each cell, including sheet right/bottom edges. Figure only65% cell height. One consistent body scale across all poses, corpses not enlarged. Soles on same baseline, no adjacent-cell parts, no UI/text/grid/background. Proper alpha transparency, no opaque matte or blurry haze. Preserve characteristic prop identity from image1, no added weapons. This is a complete game-ready character animation pack, not a concept infographic.
