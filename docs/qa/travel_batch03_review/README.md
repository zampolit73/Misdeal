# Misdeal · Cinematic Travel Batch 03

23 кадра из Godot для художественной проверки десяти локаций. Нажмите на кадр, чтобы открыть его в исходном размере **1280 × 720**. Под каждым кадром указаны исход и время с начала Travel.

[PR №119 с интеграцией](https://github.com/zampolit73/Misdeal/pull/119) · [Исходный арт-пакет №118](https://github.com/zampolit73/Misdeal/pull/118) · [RELEASE CI](https://github.com/zampolit73/Misdeal/actions/runs/44490296417) · [216 кадров и журнал всех исходов](https://github.com/zampolit73/Misdeal/actions/runs/44490296417/artifacts/14513467545)

Кадры ниже сняты в Windows / Godot 4.7.2 Compatibility. В этом прогоне пять фонов взяты из более ранних экспортов тех же композиций. Прогон RELEASE CI на коммите `574e117` использовал все 97 финальных файлов из арт-пакета. Полная серия лежит в `visual/travel_batch03` внутри архива CI.

В Godot откройте `scenes/dev/qa_hub.tscn` клавишей F6 и выберите **Travel → Batch 03 — 72 исхода**. Стрелки меняют исход, 1/2/3 выбирают доступный состав отряда, P ставит сцену на паузу, R запускает её заново, Esc пропускает переход. [Инструкция и контракт проверки](https://github.com/zampolit73/Misdeal/blob/574e11767feddc0a767375cf347d1bcfc0b42084/docs/TRAVEL_BATCH03_REVIEW.md)

## Чёрный алтарь

Масштаб и положение мага при подъёме. На отметке 2,50 с сравните состав уходящего отряда.

| Маг поднимается у алтаря · 1,15 с | Выход отряда с магом после спасения · 2,50 с | Отряд оставляет алтарь и забирает добычу · 2,50 с |
| :---: | :---: | :---: |
| [![Маг поднимается у алтаря](frames/01_black_altar_rescue_blood_115.jpg)](frames/01_black_altar_rescue_blood_115.jpg) | [![Выход отряда с магом после спасения](frames/01_black_altar_rescue_blood_250.jpg)](frames/01_black_altar_rescue_blood_250.jpg) | [![Отряд оставляет алтарь и забирает добычу](frames/03_black_altar_abandon_loot_250.jpg)](frames/03_black_altar_abandon_loot_250.jpg) |

## Закованный пленник

В одном исходе рыцарь уходит вместе с отрядом, в другом остаётся в камере.

| Рыцарь выходит с отрядом · 2,50 с | Пленник остаётся в камере · 2,50 с |
| :---: | :---: |
| [![Рыцарь выходит с отрядом](frames/08_chained_prisoner_recruit_250.jpg)](frames/08_chained_prisoner_recruit_250.jpg) | [![Пленник остаётся в камере](frames/10_chained_prisoner_abandon_250.jpg)](frames/10_chained_prisoner_abandon_250.jpg) |

## Джек

Три исхода события. В варианте со спасением Джек следует за следопытом.

| Джек уходит с отрядом · 2,50 с | Отряд проходит мимо · 2,50 с | Исход с охотничьим жетоном · 2,50 с |
| :---: | :---: | :---: |
| [![Джек уходит с отрядом](frames/16_jack_recruited_250.jpg)](frames/16_jack_recruited_250.jpg) | [![Отряд проходит мимо](frames/17_jack_passed_250.jpg)](frames/17_jack_passed_250.jpg) | [![Исход с охотничьим жетоном](frames/18_jack_token_250.jpg)](frames/18_jack_token_250.jpg) |

## Шепчущий колодец

Проверьте контакт ног с кладкой и перекрытие ближней кромкой на отметке 1,15 с. Сравните состав отряда при выходе.

| Маг у ближней кромки · 1,15 с | Выход после спасения · 2,50 с | Уход после потери · 2,50 с |
| :---: | :---: | :---: |
| [![Маг у ближней кромки](frames/19_whispering_well_rescue_blood_115.jpg)](frames/19_whispering_well_rescue_blood_115.jpg) | [![Выход после спасения](frames/19_whispering_well_rescue_blood_250.jpg)](frames/19_whispering_well_rescue_blood_250.jpg) | [![Уход после потери](frames/25_whispering_well_leave_lost_250.jpg)](frames/25_whispering_well_leave_lost_250.jpg) |

## Последний привал

Сравните появление спасённого героя и уход от костра после выбора добычи.

| Отряд после спасения · 2,50 с | Уход с добычей · 2,50 с |
| :---: | :---: |
| [![Отряд после спасения](frames/27_last_camp_rescue_blood_250.jpg)](frames/27_last_camp_rescue_blood_250.jpg) | [![Уход с добычей](frames/29_last_camp_abandon_loot_250.jpg)](frames/29_last_camp_abandon_loot_250.jpg) |

## Пепельный привал

Сравните состав уходящего отряда и состояние точки встречи.

| Выход отряда после рекрутирования · 2,50 с | Уход без рекрутирования · 2,50 с |
| :---: | :---: |
| [![Выход отряда после рекрутирования](frames/34_ash_rest_recruit_250.jpg)](frames/34_ash_rest_recruit_250.jpg) | [![Уход без рекрутирования](frames/36_ash_rest_abandon_250.jpg)](frames/36_ash_rest_abandon_250.jpg) |

## Костяная пошлина

Сравните поведение сборщиков пошлины и состояние прохода.

| Проход после уплаты золотом · 2,50 с | Проход силой · 2,50 с |
| :---: | :---: |
| [![Проход после уплаты золотом](frames/41_bone_tax_gold_250.jpg)](frames/41_bone_tax_gold_250.jpg) | [![Проход силой](frames/44_bone_tax_force_250.jpg)](frames/44_bone_tax_force_250.jpg) |

## Карта без лица

Сравните раскрытие с золотом и исход раскрытия при исчерпанном пуле реликвий.

| Раскрытие с золотом · 2,50 с | Раскрытие без новой реликвии · 2,50 с |
| :---: | :---: |
| [![Раскрытие с золотом](frames/45_faceless_card_reveal_gold_250.jpg)](frames/45_faceless_card_reveal_gold_250.jpg) | [![Раскрытие без новой реликвии](frames/47_faceless_card_reveal_relic_empty_250.jpg)](frames/47_faceless_card_reveal_relic_empty_250.jpg) |

## Лунная печать

Сравните положение печати и состояние очага после решения.

| Печать сохранена · 2,50 с | Печать сожжена · 2,50 с |
| :---: | :---: |
| [![Печать сохранена](frames/60_moon_seal_keep_250.jpg)](frames/60_moon_seal_keep_250.jpg) | [![Печать сожжена](frames/62_moon_seal_burn_250.jpg)](frames/62_moon_seal_burn_250.jpg) |

## Склеп отзвуков

Сравните положение реликвии и проход группы у двери.

| Реликвия сохранена · 2,50 с | Отряд выбирает силовой проход · 2,50 с |
| :---: | :---: |
| [![Реликвия сохранена](frames/64_echo_crypt_relic_kept_250.jpg)](frames/64_echo_crypt_relic_kept_250.jpg) | [![Отряд выбирает силовой проход](frames/65_echo_crypt_relic_forced_250.jpg)](frames/65_echo_crypt_relic_forced_250.jpg) |

