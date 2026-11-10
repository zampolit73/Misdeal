# Echo of the Siege — event narrative revision proposal

**Status: Narrative V2 approved by the user and implemented in game.** Prepared 2026-11-10 in response to user request to invent new event content matching all five already-approved illustrations. This is an editorial proposal only. Godot card resources and scripts are unchanged. Narrative constraints: [ACT1_PROMISED_DAWN_STORY_BIBLE.md](ACT1_PROMISED_DAWN_STORY_BIBLE.md) and [ACT1_SIEGE_MYSTERY_DIRECTION.md](ACT1_SIEGE_MYSTERY_DIRECTION.md).

## Design principles

- Every undead resident carries out a familiar duty from the last days of the siege, unaware that the castle and its defenders are dead. Their actions loop, not necessarily time itself. Do not definitively explain the origin of undead.
- The player encounters no living defenders in these five scenes: seamstress nurses an already dead skeleton, postal clerk tends exactly one skeletal pigeon, the **latest user-approved squire painting** depicts a young partly skeletal squire donning enormous boots, dishonest quartermaster cheats straw military dummies, and sentinel has a cold unlit signal basket.
- Interactions remain independent and can appear in randomized Act I order. Hint at the false promise of dawn and contradictory southern march without naming the Chancellor as forger or the Commandant as XIII before the finale.
- **Retain already implemented three choices, availability conditions and numerical effects** in `scripts/event/final_five_events.gd` unless separately approved. A: tactical/economic trade-off, B: alternative tactical/evidence/economic choice, C: free neutral leave. Retain UI mechanics/DS3, saves and art unchanged.
- Existing descriptions contradict the new art: living wounded, multiple birds, cobbler, baker and living queue. Proposed replacement texts below fix those conflicts. They are narrative drafts, not a mandate to change the code.

## 1. ЗНАМЯ НА БИНТЫ / banner_seamstress (Tier 0)

**Card scene**

В разрушенном лазарете пожилая швея режет гарнизонное знамя на бинты. На койке сидит скелет-солдат. Его грудь уже несколько раз перевязана, но швея всё равно ищет раны.

**Resident line:** «Потерпите, капитан. Ещё немного. Подкрепление обещали к утру».

**Choices and existing mechanical contracts:**

- «Забрать бинты» — макс. HP героев +12, урон −0,5 до конца забега (script choice `bandages`). Знамя разрезано на пригодные повязки; укрепление защиты за счёт символа боевого духа.
- «Сохранить знамя» — урон +0,75, макс. HP −6 до конца забега (`standard`). Сохранение стяга в ущерб медицинским запасам.
- «Не тревожить швею» — без изменений (`passed`). Она продолжает перевязывать мёртвого солдата.

**Wizard:** «Она думает, что спасает ему жизнь. Не лишай её этой радости».

## 2. ЗАПЕРТАЯ ПОЧТА / unsent_letters (Tier 1)

**Card scene**

В замковой почте скелетизированный служащий запирает очередное письмо в сундук. Рядом сидит единственный почтовый голубь — от птицы остались одни кости. «Без разрешения комендатуры ничего не отправлять. Я должен дождаться печати». На самом старом конверте стоит дата, которой уже много лет.

**Choices:**

- «Отправить письмо» — −10 золота, одноразовое `defiance_order_ready` для следующего боя; только если хватает денег и приказ ещё не подготовлен (`release`). Один костяной голубь покидает почту.
- «Прочитать задержанные письма» — существующая улика `southern_march`, без золота и усиления (`read`). Путь армии вёл прочь от замка; не называть виновника подлога.
- «Запереть сундук» — без изменений (`passed`). Почтмейстер продолжает ждать разрешения.

**Wizard:** «Самое надёжное письмо — то, которое никогда не дошло до адресата».

## 3. ЧУЖИЕ САПОГИ / borrowed_boots (Tier 0)

**Card scene**

У заброшенного лагерного костра юный оруженосец пытается натянуть огромный рыцарский сапог. Одна его рука давно превратилась в кости. «Господин велел приготовить снаряжение к возвращению. Я уже почти закончил». Рядом лежат шлем и щит. На них толстый слой пыли.

**Choices:**

- «Выкупить лёгкую пару» — −18 золота, множитель скорости героев ×1,08 до конца забега (`repair`). Оруженосец на автомате помогает подогнать ремни оставшейся пары, не становясь новым спутником.
- «Взять тяжёлые сапоги» — макс. HP +8, скорость ×0,96 до конца забега (`hobnails`). Подкованная защитная обувь.
- «Оставить сапоги хозяину» — без изменений (`passed`). Оруженосец возвращается к незаконченной работе.

**Wizard:** «Знаешь, что самое печальное? Он так и не вырос в эти сапоги».

## 4. НЕВЕРНЫЕ ГИРИ / false_weights (Tier 1)

**Card scene**

У разрушенных ворот мёртвый интендант взвешивает остатки зерна. Перед ним стоят солдатские чучела из соломы и мешковины. «Следующий! По приказу комендатуры каждому положен полный паёк!» Он незаметно подкладывает на весы камень. Чучела молчат. «Вот и хорошо. Никто не жалуется».

**Choices:**

- «Потребовать честный паёк» — −12 золота, макс. HP героев +16 и существующая улика `rations_hidden` (`fair`). Находится поддельная складская ведомость, а игрок получает съедобную провизию.
- «Принять откуп» — +18 золота, макс. HP героев −6 до конца забега (`silence`). Вы принимаете монеты и скудную испорченную часть припасов, позволяя нечестному взвешиванию продолжаться.
- «Не вмешиваться» — без изменений (`passed`). Интендант продолжает обманывать пустые чучела.

**Wizard:** «Прекрасный торговец. Ни одного недовольного покупателя за последние сто лет».

## 5. ПОГАСШИЙ СИГНАЛ / last_signal (Tier 2)

**Card scene**

На разрушенной башне стоит мёртвый дозорный. Он поднимает к ночному небу сигнальную жаровню, в которой давно не осталось огня. «Ещё раз. Они обязательно увидят». Внизу лежат остатки крепости. За холмами нет ни одного ответного огня.

**Choices:**

- «Разорвать обещание» — −20 золота, отменяет активный `wizard_debt_active` **вместе с будущей двойной наградой**; недоступно без активного долга (`truth`). Это **долг самого игрока перед Волшебником**, не новое объяснение нежити или долга дозорного.
- «Забрать сигнальную чашу» — +22 золота (`salvage`). Дозорный остаётся держать пустой шест.
- «Оставить дозорного» — без изменений (`passed`). Он снова поднимает потухшую жаровню.

**Wizard:** «Иногда проще умереть, чем признать, что никто не придёт».

## Implementation considerations, not approvals

The real UI currently uses `RunCardData.card_text`, `wizard_line` (five `resources/cards/<id>.tres`) and `final_five_events.gd::CHOICES` entries [choice key, button label, resolution prose]. Keep each card_text concise enough for the actual Godot event Description label (various layouts use ~40–54px height) and offer card constraints; the longer drafts above may need careful editing without removing the twist. Do not set permanent flags or a new global time loop; the undead routine is **narrative**. If a text-only implementation is later approved, preserve numeric logic, keep current case-sensitive choice keys and gating, and run existing `tests/unit/test_final_five_events.gd` with native F6 QA.

**Implementation:** user task approves this direction. Runtime uses short `card_text` hooks and separate `FINAL_FIVE.SCENES` compact dialogue scenes; all 15 choices have revised labels and literary conclusions. Numbers, IDs, gates, facts and saves are unchanged. Longer paragraphs below are editorial background; the runtime version is shortened for the existing 611×50 footer. Art remains immutable. F6: `scenes/dev/final_five_playtest.tscn`; native capture: `scripts/dev/final_five_capture.gd`.
