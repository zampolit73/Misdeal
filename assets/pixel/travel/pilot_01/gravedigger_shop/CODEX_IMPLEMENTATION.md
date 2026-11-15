# Лавка могильщика — CODEX IMPLEMENTATION V3

ART CANDIDATE / NOT INTEGRATED. V3 заменяет только визуальную реализацию gravedigger_shop. Last_signal, lost_purse, семь остальных сцен, source masters и игровые правила не изменять. source/input_* и старые V1/V2 generation logs — исторические материалы, не действующее задание; плакаты и V2 working merchant не возвращать.

## Единственный персонаж

База только `source/original_master.png` (1672×941). Один исходный живой пожилой могильщик уже нарисован в master. НЕ добавлять отдельного merchant/caster, вторую голову, туловище или новый набор рук. В V3 отсутствует генерированный слой персонажа: используются только предметные патчи на подносах; исходные кисти остаются у тех же опорных точек. `layers/character_guard_mask.png` защищает голову, тело, кисти и контрольные области. Маски патчей уже вычитают эту защиту. Не заменять их широким непрозрачным rect. `layers/allowed_object_edit_mask.png` — объединение допустимых локальных областей, не картинка для отрисовки.

## Реальные ассеты

Все пути относительны папке этой сцены. Возможная будущая точка копирования после утверждения: res://assets/pixel/travel/pilot_01/gravedigger_shop/. Полные RGB финалы1280×720: `outcomes/knight.png`, `ranger.png`, `mage.png`, `leave.png`. Source master и leave побайтно сохранены из V2.

| visual_action | Source rect[x,y,w,h] | RGBA работа | RGBA итог |
|---|---|---|---|
| knight | `[365, 383, 220, 112]` | `animation/knight_work.png` | `layers/knight_patch.png` |
| ranger | `[490, 330, 225, 165]` | `animation/ranger_work.png` | `layers/ranger_patch.png` |
| mage | `[700, 340, 140, 145]` | `animation/mage_work.png` | `layers/mage_patch.png` |

Размеры локальных PNG совпадают с w,h rect. Source coordinates1672×941 проектировать ровно один раз: x*1280/1672, y*720/941. Straight RGBA, RGB нулевой приalpha0. `layers/<role>_mask.png` содержит реальную альфу соответствующего предметного патча.

`animation/<role>_work_full.png` и `<role>_full_<time>.png` — полноэкранные контрольные изображения, НЕ новый master или новый персонаж. APNG `_full_preview.apng.png` —40review-кадров1280×720/4000ms. Palette256 применяется только к review-файлам; финалы и production-входы отдельно RGB/RGBA. Ссылки .40/.75/1.25/2.50 — ../animation_contract.json; одинаковые held frames переиспользованы честно, не считаются новыми авторскими позами.

## Постановка — один4s clock

0–.40: исходные предметы. .40–1.20: выбранная рабочая предметная поза. С1.20 — выбранный конечный патч, удерживать до штатного выхода V2. Это ограниченные объектные позы и локальный свет, не анимация нового NPC rig. Не накладывать одновременно рабочий и конечный патч и не накапливать старые позы в каждом update_time: каждый кадр собирается детерминированно от master с ОДНИМ выбранным патчем.

- Knight: один существующий клинок раскрыт/повёрнут по диагонали внутри первого подноса, рукоять под исходной левой кистью. В рабочем состоянии обмотка ослаблена, в финале затянута. На металле короткий естественный блик. `layers/knight_shading_mask_1280.png`: brightness factor1+.12*sin(pi*(t-.40)/.80) только внутри .40–1.20, за пределами0. Никакого второго оружия или новых наград.
- Ranger: тот же колчан, три существующие стрелы разложены веером, в рабочей позе тетива натянута от исходных пальцев к снаряжению, в конце лежит небольшой физической петлёй на подносе. Оригинальная текстура корпуса колчана сохранена. Исходный висящий медальон/цепочка остаются; защитная маска узкая, не обрезать древки прямоугольником вокруг него. Древки могут естественно перекрываться самим медальоном, но не исчезать в пустом фоне.
- Mage: прежний НИЗКИЙ серый камень третьего подноса кратко приподнят, в природных трещинах вспыхивает фиолетовый свет и близкие wisps; затем камень опускается на прежний поднос. Не ставить его вертикально подобно портрету/голове. `layers/mage_shading_mask_1280.png`: factor1+.45*sin(pi*(t-.40)/.80) внутри .40–1.20; свет только на существующих трещинах/близких wisps. Большая часть камня остаётся серой. В конце остаётся узкий приглушённый свет в трещине. Нет рун, магических кругов, плакатов и второго заклинателя.
- Leave: исходный master/leave.png, никакой предметной работы, платы, новых листов или магии. Существующая общая атмосфера может идти тем же clock.

*_shading_mask_1280.png — full-view маски1280×720. Назначать их полному composited view с теми же UV либо корректно преобразовать в source UV. Не прикладывать full-view маску как маленькую crop-текстуру. Source+Road+предметы двигаются в одной родительской плоскости; не устраивать независимый parallax тела, подноса и патча. Чистую RGB подложку применять только через соответствующую маску, не широким непрозрачным блоком. Существующие sky/foreground/ground и quiet_atmosphere.gdshader сохранены изV2; shader compilation в Godot не проверялась.

## Реальные исходы и передача выбора

card_id=`gravedigger_shop`. Все три покупки сохраняют ОДИН outcome_id=`bought`. knight/ranger/mage — только transient visual_action/choice_role и имена графики. Leave не пишет outcome_id. Не вводить bought_knight/ranger/mage, обязательное save-поле или новую награду.

В существующем _resolve_shop(role) захватить визуальную роль только ПОСЛЕ успешного _grant_role_upgrade(role); передать в travel_context после catalog.context_for, чтобы _finish не перетёр её. Для leave явно передать visual_action=leave и очистить роль; не выводить уход из старого сохранённого bought и не угадывать роль по составу отряда. При отсутствии временной роли у старого сохранения безопасно пропустить специфическую покупочную анимацию, не изобретать роль. Цена30/35/45, выдача upgrade, память и экономические эффекты остаются существующими.

Travel только визуализирует уже применённое решение: никаких RunState.gold/HP/debt/upgrades/save/write_slot/RNG вызовов из panorama. Источник проверенного контракта V2 — ../SOURCE_AUDIT.json с Git blob SHA; перед будущей интеграцией повторно сверить main. В том snapshot новые LOCATIONS/TEXT ещё не были подключены; проверить обе части travel_catalog.gd, иначе context_for может вернуть{}. Четыре уже действующие Travel-сцены не менять.

## Godot/Resource контракт и отряд

Использовать существующие scripts/data/travel_transition_data.gd и scripts/travel/travel_transition.gd, scripts/core/scene_router.gd. TravelTransitionData: background_path, foreground_path, underpaint_path, sky_path, panorama_script, party_origin/spacing/depth/scale/solo_offset/tint/fog_rect; duration4s. Panorama: build(background,foreground,underpaint,sky), available, planes.Midground, planes.Foreground, speeds.Road, configure(context), update_time(time,duration). Эти .gd/.tres в поставке не создавались и не интегрировались.

Необязательная существующая функция stage_party(actors:Array[AnimatedSprite2D], roles:Array[String], contacts:Array[Vector2], ground:Node2D,time:float,duration:float,layout:Resource). Утверждённые атласы и измеренные подошвы — ../REFERENCE_HERO_ANIMATIONS/ и ../animation_contract.json. Не перерисовывать героев и не подменять их NPC. Сохранённый боковой маршрут viewport[855,605]→[900,598]→[945,590], horizon300, visible height300 в стартовой плоскости. Depth=max(.60,(foot_y-300)/(605-300)); formation offsets и6frames/6.5fps остаются в общем контракте V2. Отряд идёт справа, не закрывает предметы. В основных NPC-превью отряд выключен.

## Пауза, skip, выход и проверка

Единое локальное время V2, не shader TIME и не второй таймер. SceneRouter/SceneTransition владеет входом/выходом, fade360ms и возвратом Table. Не накладывать новый fade поверх штатного. Pause замораживает elapsed, эффекты и walk; resume не перескакивает. Skip вызывает существующее завершение РОВНО ОДИН раз, очищает transient context/узлы под завесой, не ждёт остаток tween, не повторяет плату/награду и не запускает вторую навигацию.

В изолированной ветке после художественного утверждения: проверить import/alpha/filtering, четыре случая при1280×720, все моменты .40/.75/1.25/2.50, отсутствие NPC дубля/рук/пальцев/предметов; сверить character_guard и неизбранные подносы сmaster. Проверитьpause на.6 и2s, skip до/во время/после работы, старыйsaveбезроли, быстрыйдвойнойввод. Снимок RunState до/послеTravel должен совпадать. Godot-запуск здесь NOT RUN; Node mocked controller и Blendercodecпроверка не заменяют двигатель. Все новые изображения остаются кандидатами; production/GitHub не менять.
