# Погасший сигнал · V2 · CODEX_IMPLEMENTATION

ART CANDIDATE / NOT INTEGRATED. V2 заменяет локальную режиссуру V1, не меняет механику.

## Исправление V2: действия дозорного и бумага

| visual_action | save outcome_id | Конечный контрольный кадр |
|---|---|---|
| truth | truth | outcomes/truth.png |
| salvage | salvage | outcomes/salvage.png |
| passed | passed | outcomes/passed.png |

Три финала побайтно сохранены из V1; исправлена причинная анимация перед ними. Удалён старый независимый basket_detached/Tween: чаша больше не едет сама через небо.

salvage — source rect [930,160,460,630]. На .32s показать `animation/salvage_action_0.png`: дозорный опустил/наклонил шест, одна кисть держит древко, другая удерживает ещё закреплённую чашу. На .60s `salvage_action_1.png`: отделённая чаша всё время контактирует с рукой у обода; другая рука держит пустой шест. На .87s `salvage_action_2.png`: рука опускает чашу ЗА исходный каменный парапет. Его пиксели сохранены и перекрывают корзину. На1.20s вернуть исходную позу с `layers/salvage_patch.png` [1090,160,220,230] и чистой подложкой; пустая насадка остаётся до конца. Согласованные руки/чаша/древко — единые авторские позы. НЕ выделять чашу обратно в свободный sprite, не crossfade две корзины, не добавлять fire/magic. Это ограниченная покадровая анимация, не плавный скелетный rig. У skull/шлема, ног и архитектуры master остаётся авторитетным.

truth — четыре существующие разные `animation/paper_pose_0.png` … `_3.png`. До .08 бумага за нижним краем. .08–.40 она соскальзывает в кадр от source[600,1020] к[710,720]; smoothstep, размер[230,175], дополнительная дуга -20*sin(pi*u) по y. В .40 целая расписка уже лежит на камне, затем позы переключаются .54/.76/1.02; печать разломлена, половины расходятся и оседают. На1.22 удержать V1 outcomes/truth.png. Никаких новых надписей/гербов/магической вспышки. Passed — предметы не меняются, только общий атмосферный clock.

Правила остаются: truth -20 при ≥20 золота и активном долге, долг/будущая двойная награда прекращены; salvage +22; passed без эффекта. Только существующий resolver их применяет.

## Отряд — сохранённый постановочный контракт

Facing nw, viewport polyline `[[360, 615], [315, 590], [270, 570]]`. Horizon y300, height300px в стартовой плоскости route[0].y; depth=max(.60,(foot_y-300)/(route[0].y-300)). Formation offsets `{"solo": [[0, 0]], "duo": [[-60, -8], [60, 12]], "trio": [[-100, -15], [0, 6], [100, 25]]}`; движение clamp(t/4*.8-rank*.04,0,1). Измеренные подошвы/высоты и walk6frames/6.5fps — ../animation_contract.json. Это кандидатные маршруты V1, не новая боевая анимация. Не перекрывать предметный action.

## Контракт внедрения — после художественного утверждения

Этот пакет не является патчем production. Все новые арты — кандидаты. Перед внедрением повторно сверить main с `SOURCE_AUDIT.json`: точные просмотренные Git blob SHA сохранены там. Не менять существующие unsent_letters, banner_seamstress, borrowed_boots, false_weights, карточки и боевые атласы.

Использовать `scripts/data/travel_transition_data.gd` (TravelTransitionData): background_path, foreground_path, underpaint_path, sky_path, panorama_script и существующие party_origin/spacing/depth/scale/solo_offset/tint/fog_rect. Длительность 4 s. Новый panorama-класс должен соблюдать реальный интерфейс: `build(background, foreground, underpaint, sky)`, `available`, `planes.Midground`, `planes.Foreground`, `speeds.Road`, `update_time(time, duration)`; `configure(context)` для визуального выбора. Путь будущего ресурса предлагается `res://data/travel/pilot_01/<card_id>.tres`, panorama — `res://scripts/travel/pilot_01/<card_id>_panorama.gd`. Эти GDScript/Resource файлы здесь НЕ созданы.

`scripts/travel/travel_catalog.gd`: добавить согласованные LOCATIONS и TEXT для всех ветвей. Сейчас у этих трёх нет LOCATIONS, а у gravedigger_shop/lost_purse также нет TEXT; одного mapping недостаточно, иначе context_for вернёт {}. Не удалять четыре существующие локации. Источник исхода — результат event resolver после успешного применения решения, не повторный вызов resolver из Travel.

SceneRouter и `scripts/travel/travel_transition.gd` владеют входом/выходом, паузой и единственным завершением. Подчинить всё одному локальному времени update_time. Не использовать shader TIME, отдельный таймер, бесконечный tween или второй SceneTransition. Нативный SceneTransition fade 360 ms согласовать с окном 0–0.4 s и выходом приблизительно 3.35–4.0 s; не складывать дополнительное затемнение. На паузе остановить локальное время, SpriteFrames и привязанные tween; на resume продолжить без догоняющего скачка. На skip вызвать существующее завершение ровно один раз, убрать весь временный контекст и временные узлы под завесой, затем вернуть Table штатным роутером. Не дожидаться части tween после skip. Не делать повторную навигацию из panorama.

Никаких RunState.gold/HP/debt/upgrade/save/write_slot/random/party changes из panorama! Travel только показывает уже применённое решение. Временный словарь `{card_id, outcome_id, visual_action, choice_role}` живёт до завершения перехода, не сериализуется и не становится обязательным полем сохранения. Валидировать роль по allowlist. Не угадывать покупку по составу отряда. После загрузки старого save при отсутствии временной роли безопасно пропустить специальную рольную анимацию; не изобретать сохранённый bought_knight/ranger/mage.

## Сборка изображений и слоёв

Все пути ниже относительны этой папке сцены. Предлагаемая будущая точка копирования — `res://assets/pixel/travel/pilot_01/<card_id>/`, только после утверждения. Полный неизменённый master: `source/original_master.png`, 1672×941; исходная карточка `source/card_reference.webp`. `outcomes/*.png` — полные контрольные финальные кадры 1280×720, без героев/HUD. Не накладывать полный финал поверх master с независимой камерой.

Точные source_rect и список патчей: `layers/layer_contract.json`; ключевые кадры и их повторное использование: `../animation_contract.json`. Координаты source_rect, предметов и локальных траекторий — в master pixels; проекция ровно один раз `(x*1280/1672, y*720/941)`. RGBA straight, прозрачный RGB нулевой; маска является alpha авторского патча. Не растягивать sprite на весь экран. Native финалы уже 1280×720, повторная проекция им не нужна. До импорта проверить границы alpha и исключить фильтровочный белый fringe. Исходник painterly/pixel textured; не заявлять его строгим palette pixel art.

`layers/ground_plane.png`, `foreground_occluder.png`, `atmosphere_plane.png` — реальные отделённые плоскости. Сначала master и локальные состояния; затем ground, персонажи с сортировкой по подошве, foreground над ними. Уточнить существующий порядок Road в V2: если ground скрывает патч, переставить патч над Road, не менять картинку. Стены, грунт и NPC движутся как одна связная геометрия: 1.2 px/s, общий overscan [-32,-18,1344,757], относительный структурный параллакс 0. Атмосферная плоскость и RGB motion_mask дают локальную глубину без разрыва архитектуры. `quiet_atmosphere.gdshader` получает elapsed от V2: R облака/вода ≤1.1 px, G существующий свет ±2.5%, B край ткани ≤0.65 px; закреплённые руки/гербы исключены. Это подготовленный shader, его нативная компиляция ещё не проверена. Не накладывать motion на чистую подложку с отсутствующим предметом так, чтобы вернуть старый объект. Маску области удалённого объекта обнулить в atmosphere plane либо вырезать её из общего эффекта; базовый предмет там не должен просвечивать.

## Отряд

В `../REFERENCE_HERO_ANIMATIONS/` только byte-identical копии существующих утверждённых атласов; происхождение и SHA — `../HERO_REFERENCE_PROVENANCE.json`. Это preview reference, не новый боевой арт. NW walk: шесть 96×96 кадров, 6.5 fps; side packed walk — row 1. В игре подключать существующий unit_animation_library.gd, не заменять боевые ресурсы копиями из пакета. Для каждой роли использовать измеренные подошвы и max visible height из `../animation_contract.json`; scale = projected desired visible height / actual atlas visible height. Не центр прямоугольника кадра вместо стопы.

Реализовать существующую необязательную функцию `stage_party(actors:Array[AnimatedSprite2D], roles:Array[String], contacts:Array[Vector2], ground:Node2D, time:float, duration:float, layout:Resource)`. Сортировать по координате контакта y. Лёгкая контактная тень эллипсом на грунте, размер вместе с перспективой; цветовой tint существующим полем layout. Проверить все подмножества ролей, не заменять отсутствующую роль другой. Траектории — постановочный кандидат, проверены статическими изображениями solo/duo/trio; финальный scale/tint и окклюзию подтвердить в Godot.

## Проверка внедрения в Godot (ещё НЕ выполнена)

1. Импортировать candidate assets в изолированную ветку; проверить отсутствующие текстуры, shader compile и alpha на тёмном/светлом фоне. В production пока не переносить.
2. Запустить каждый исход при 1280×720 и сопоставить t=2.5 с outcomes PNG и безымянным OUTCOME_COMPARISON. Все 11 комбинаций перечислены в animation_contract.json.
3. Проверить solo, duo, trio, правильный кадр walk, контакт подошвы, y-sort и foreground. Главный предмет не закрывать отрядом. Никаких новых персонажей/NPC.
4. На t=.6 и 2.0 поставить pause/resume; skip проверить до действия, во время действия и после финала. Один finished, чистый Table, никаких оставшихся tween, повторной платы или награды. Снимок RunState до/после Travel должен быть идентичен.
5. Проверить сохранение/загрузку без временной роли, повторное открытие перехода, отрицательный/неизвестный visual_action и быстрый двойной ввод. Не повторять случайный результат и resolver.

В этом пакете есть реально отрисованные APNG и ключевые кадры. В V2 APNG — полный кадр1280×720,40frames/4s, palette-256 и loop только для проверки; они не являются production SpriteFrames. Изолированный REVIEW.html имеет управление временем и существующими walk sprites, но браузерное воспроизведение V2 заблокировано Windows IPC access denied при двух изолированных headless запусках; это не PASS. Запуск Godot не проводился.

SOURCE_AUDIT.json содержит сохранённый проверенный snapshot V1, не новый fetch main. Чистую RGB underpaint-подложку применять только через соответствующую маску удаления либо использовать уже готовый RGBA patch; не накрывать master полным непрозрачным прямоугольником.

## Полноэкранные доказательства V2

`../animation_contract.json` перечисляет реальные полные1280×720 кадры .4/.75/1.25/2.5 и `<action>_full_preview.apng.png` (40frames/4000ms, palette256 review, без героев). Сами рабочие RGBA-позы и финалы RGB сохранены отдельно. Повторно использованный held frame не считается новой авторской позой. Для каждого исхода сверить native финал и безымянный OUTCOME_COMPARISON, а не только crop. APNG/MP4 review могут loop; runtime только once, Clock/skip завершает штатный V2.

quiet_atmosphere.gdshader применять к уже собранной source+patch texture либо согласованной общей плоскости, до героев/foreground. Одна atmosphere_plane содержит R sky/water, её alpha не содержит G/B. Не заявлять cloth/light shader работающим, если материал назначен только на clipped sky. Эти эффекты требуют нативной проверки. Структурный относительный parallax0 предотвращает швы.

## Реальные файлы сцены

| Путь | Bytes |
|---|---:|
| `animation/paper_pose_0.png` | 358715 |
| `animation/paper_pose_1.png` | 360814 |
| `animation/paper_pose_2.png` | 353290 |
| `animation/paper_pose_3.png` | 343965 |
| `animation/passed_full_0400.png` | 501727 |
| `animation/passed_full_preview.apng.png` | 3051525 |
| `animation/salvage_action_0.png` | 197366 |
| `animation/salvage_action_1.png` | 194343 |
| `animation/salvage_action_2.png` | 190810 |
| `animation/salvage_full_0400.png` | 502355 |
| `animation/salvage_full_0750.png` | 502183 |
| `animation/salvage_full_1250.png` | 498653 |
| `animation/salvage_full_preview.apng.png` | 3183017 |
| `animation/salvage_lower_full.png` | 1472128 |
| `animation/truth_full_0400.png` | 497414 |
| `animation/truth_full_0750.png` | 497585 |
| `animation/truth_full_1250.png` | 496934 |
| `animation/truth_full_preview.apng.png` | 2995519 |
| `layers/atmosphere_plane.png` | 395451 |
| `layers/foreground_occluder.png` | 102467 |
| `layers/ground_plane.png` | 1097175 |
| `layers/layer_contract.json` | 2332 |
| `layers/motion_mask.png` | 32898 |
| `layers/quiet_atmosphere.gdshader` | 545 |
| `layers/salvage_action_mask.png` | 4314 |
| `layers/salvage_clean_underpaint.png` | 59620 |
| `layers/salvage_mask.png` | 1452 |
| `layers/salvage_patch.png` | 28854 |
| `outcomes/passed.png` | 1471513 |
| `outcomes/salvage.png` | 1467472 |
| `outcomes/truth.png` | 1473878 |
| `source/card_reference.webp` | 41686 |
| `source/input_CODEX_PROMPT.md` | 24261 |
| `source/input_concept.md` | 6828 |
| `source/input_GENERATION_PROMPT.txt` | 2044 |
| `source/input_outcomes.md` | 5981 |
| `source/original_master.png` | 2534564 |
