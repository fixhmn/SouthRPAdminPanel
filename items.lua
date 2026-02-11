return {
	['money'] = {
		label = 'Наличка',
	},
	['vehiclekeys'] = {
		label = 'Ключи от автомобиля',
		weight = 50,
		stack = false,
		close = true,
		client = { image = 'vehiclekeys.png' },
	},

	['screwdriver'] = {
		label = 'Отвертка',
		weight = 50,
		stack = false,
		close = true,
		client = { image = 'screwdriver.png' },
	},

	['plate'] = {
		label = 'Автомобильный номер',
		weight = 50,
		stack = false,
		close = true,
		client = { image = 'plate.png' },
	},

	['carlockpick'] = {
		label = 'Carlockpick',
		weight = 50,
		stack = false,
		close = true,
		description = 'A Lockpick.',
		client = { image = 'carlockpick.png' },
	},

	['caradvancedlockpick'] = {
		label = 'Car Advanced Lockpick',
		weight = 500,
		stack = true,
		close = true,
		description = 'If you lose your keys a lot this is very useful... Also useful to open your beers',
		client = { image = 'advancedlockpick.png' },
	},

	['vehiclegps'] = {
		label = 'Vehicle GPS',
		weight = 50,
		stack = false,
		close = true,
		description = 'GPS device for what...?',
		client = { image = 'vehiclegps.png' },
	},

	['vehicletracker'] = {
		label = 'Vehicle Tracker',
		weight = 50,
		stack = false,
		close = true,
		description = 'It seems to stream probes',
		client = { image = 'vehicletracker.png' },
	},

	['rimsstreet'] = {
		label = 'Комплект дисков (Спортивные)',
		weight = 3500,
		stack = true,
		close = true,
		client = { image = 'rimsstreet.png' },
	},

	['rimstrack'] = {
		label = 'Комплект дисков (Компактные)',
		weight = 3500,
		stack = true,
		close = true,
		client = { image = 'rimstrack.png' },
	},

	['rimsopen'] = {
		label = 'Комплект дисков (Роскошные)',
		weight = 3500,
		stack = true,
		close = true,
		client = { image = 'rimsopen.png' },
	},

    ['skateboard'] = {
    label = 'Скейтборд',
    weight = 3000,
    stack = false,
    close = true,
    description = 'Маневренный скейтборд с прочной 7-слойной кленовой декой, алюминиевыми подвесками, полиуретановыми колесами',
    client = {
        image = 'nui://ox_inventory/web/images/skateboard.png',
        event = 'bodhix-skating:client:start'
    },
},


	['bmx'] = {
		label = 'Велосипед BMX',
		weight = 3000,
		stack = false,
		close = true,
		description = 'Трюковой велик!',
		client = { image = 'bmx.png' },
	},

	['blackjack_table'] = {
		label = 'Blackjack Table',
		weight = 1,
		stack = true,
		close = true,
		client = { image = 'blackjack_table.png' },
	},

	['baccarat_table'] = {
		label = 'Baccarat Table',
		weight = 1,
		stack = true,
		close = true,
		client = { image = 'baccarat_table.png' },
	},

	['roulette_table'] = {
		label = 'Roulette Table',
		weight = 1,
		stack = true,
		close = true,
		client = { image = 'roulette_table.png' },
	},

	['poker_table'] = {
		label = 'Poker Table',
		weight = 1,
		stack = true,
		close = true,
		client = { image = 'poker_table.png' },
	},

	['wheel_machine'] = {
		label = 'Wheel Machine',
		weight = 1,
		stack = true,
		close = true,
		client = { image = 'wheel_machine.png' },
	},

	['slot_machine'] = {
		label = 'Slot Machine',
		weight = 1,
		stack = true,
		close = true,
		client = { image = 'slot_machine.png' },
	},

	['horseracing_machine'] = {
		label = 'Horseracing Machine',
		weight = 1,
		stack = true,
		close = true,
		client = { image = 'horseracing_machine.png' },
	},

	['crutch'] = {
		label = 'Костыль',
		weight = 650,
		stack = true,
		close = true,
		description = 'Приспособление для помощи при ходьбе',
		client = { image = 'crutch.png' },
	},

	['wheelchair'] = {
		label = 'Инвалидная коляска',
		weight = 850,
		stack = true,
		close = true,
		description = 'Приспособление для помощи в передвижении',
		client = { image = 'wheelchair.png' },
	},

	['medbag'] = {
		label = 'Медицинская сумка',
		weight = 500,
		stack = true,
		close = true,
		description = 'Сумка с медицинскими инструментами',
		client = { image = 'medbag.png' },
	},

	['tweezers'] = {
		label = 'Пинцет',
		weight = 50,
		stack = true,
		close = true,
		description = 'Для извлечения пуль',
		client = { image = 'tweezers.png' },
	},

	['suturekit'] = {
		label = 'Набор для швов',
		weight = 60,
		stack = true,
		close = true,
		description = 'Для наложения швов пациенту',
		client = { image = 'suturekit.png' },
	},

	['icepack'] = {
		label = 'Пакет со льдом',
		weight = 110,
		stack = true,
		close = true,
		description = 'Помогает уменьшить отёк',
		client = { image = 'icepack.png' },
	},

	['burncream'] = {
		label = 'Крем от ожогов',
		weight = 125,
		stack = true,
		close = true,
		description = 'Помогает при ожогах',
		client = { image = 'burncream.png' },
	},

	['defib'] = {
		label = 'Дефибриллятор',
		weight = 1120,
		stack = true,
		close = true,
		description = 'Используется для реанимации пациентов',
		client = { image = 'defib.png' },
	},

	['sedative'] = {
		label = 'Седативное',
		weight = 20,
		stack = true,
		close = true,
		description = 'При необходимости усыпляет пациента',
		client = { image = 'sedative.png' },
	},

	['morphine30'] = {
		label = 'Морфин 30мг',
		weight = 2,
		stack = true,
		close = true,
		description = 'Контролируемое вещество для обезболивания',
		client = { image = 'morphine30.png' },
	},

	['morphine15'] = {
		label = 'Морфин 15мг',
		weight = 2,
		stack = true,
		close = true,
		description = 'Контролируемое вещество для обезболивания',
		client = { image = 'morphine15.png' },
	},

	['perc30'] = {
		label = 'Перкоцет 30мг',
		weight = 2,
		stack = true,
		close = true,
		description = 'Контролируемое вещество для обезболивания',
		client = { image = 'perc30.png' },
	},

	['perc10'] = {
		label = 'Перкоцет 10мг',
		weight = 2,
		stack = true,
		close = true,
		description = 'Контролируемое вещество для обезболивания',
		client = { image = 'perc10.png' },
	},

	['perc5'] = {
		label = 'Перкоцет 5мг',
		weight = 2,
		stack = true,
		close = true,
		description = 'Контролируемое вещество для обезболивания',
		client = { image = 'perc5.png' },
	},

	['vic10'] = {
		label = 'Викодин 10мг',
		weight = 2,
		stack = true,
		close = true,
		description = 'Контролируемое вещество для обезболивания',
		client = { image = 'vic10.png' },
	},

	['vic5'] = {
		label = 'Викодин 5мг',
		weight = 2,
		stack = true,
		close = true,
		description = 'Контролируемое вещество для обезболивания',
		client = { image = 'vic5.png' },
	},

	['medikit'] = {
		label = 'Аптечка',
		weight = 110,
		stack = true,
		close = true,
		description = 'Аптечка для оказания первой помощи',
		client = { image = 'medikit.png' },
	},

	['kodein'] = {
		label = 'Кодеин',
		weight = 250,
		stack = true,
		close = true,
		description = 'Кодеин',
		client = { image = 'kodein.png' },
	},

	['oxycodone'] = {
		label = 'Оксикодон',
		weight = 250,
		stack = true,
		close = true,
		description = 'Оксикодон',
		client = { image = 'oxycodone.png' },
	},

	['tramadol'] = {
		label = 'Трамадол',
		weight = 250,
		stack = true,
		close = true,
		description = 'Трамадол',
		client = { image = 'tramadol.png' },
	},

	['sprunkbottle'] = {
		label = 'Бутылка Sprunka',
		weight = 250,
		stack = true,
		close = true,
		description = 'Бутылка Sprunk',
		client = { image = 'sprunkbottle.png' },
	},

	['doublecup'] = {
		label = 'ДаблКап',
		weight = 30,
		stack = true,
		close = true,
		description = 'Красный двойной стакан, удобный для повседневного использования',
		client = { image = 'cup_red.png' },
	},

	['lean'] = {
		label = 'ДаблКап с лином',
		weight = 30,
		stack = true,
		close = true,
		description = 'ДаблКап с лином',
		client = { image = 'cup_red.png' },
	},

	['cuffs'] = {
		label = 'Наручники',
		weight = 100,
		stack = true,
		close = true,
		description = 'Наручники',
		client = { image = 'handcuffs.png' },
	},

	['handcuff_keys'] = {
		label = 'Handcuff keys',
		weight = 50,
		stack = true,
		close = true,
		description = 'Ключ от наручников',
		client = { image = 'handcuff_keys.png' },
	},

	['grinder'] = {
		label = 'Болгарка',
		weight = 100,
		stack = true,
		close = true,
		description = 'Болгарка',
		client = { image = 'grinder.png' },
	},

	['rope'] = {
		label = 'Верёвка',
		weight = 100,
		stack = true,
		close = true,
		description = 'Верёвка',
		client = { image = 'rope.png' },
	},

	['knife'] = {
		label = 'Кухонный нож',
		weight = 100,
		stack = true,
		close = true,
		description = 'Кухонный нож',
		client = { image = 'knife.png' },
	},

	['rag'] = {
		label = 'Тряпка',
		weight = 100,
		stack = true,
		close = true,
		description = 'Может пригодиться',
		client = { image = 'rag.png' },
	},

	['evidencecleaningkit'] = {
		label = 'Набор для очистки улик',
		weight = 250,
		stack = true,
		close = true,
		description = 'Очищает улики вокруг',
		client = { image = 'cleaningkit.png' },
	},

	['kq_expensive_laptop'] = {
		label = 'Игровой ноутбук',
		weight = 2000,
		stack = true,
		close = true,
		description = 'Игровой ноутбук Kakagawa, пару царипин на корпусе',
		client = { image = 'kq_expensive_laptop.png' },
	},

	['kq_expensive_laptop2'] = {
		label = 'Брендовый ноутбук',
		weight = 2000,
		stack = true,
		close = true,
		description = 'Брендовый ноутбук iFruit, нет кнопки F на клавиатуре',
		client = { image = 'kq_expensive_laptop2.png' },
	},

	['kq_expensive_watch'] = {
		label = 'Наручные часы',
		weight = 200,
		stack = true,
		close = true,
		description = 'Наручные часы Crowex, поцарапано стекло',
		client = { image = 'kq_expensive_watch.png' },
	},

	['kq_expensive_watch2'] = {
		label = 'Наручные часы с бриллинтами',
		weight = 300,
		stack = true,
		close = true,
		description = 'Наручные часы Crowex, инкрустированные бриллиантами',
		client = { image = 'kq_expensive_watch2.png' },
	},

	['kq_expensive_bag'] = {
		label = 'Брендовая женская сумка',
		weight = 750,
		stack = true,
		close = true,
		description = 'Брендовая сумка G&B, глубокие царапины на коже',
		client = { image = 'kq_expensive_bag.png' },
	},

	['kq_expensive_bag2'] = {
		label = 'Дизайнерская женская сумка',
		weight = 750,
		stack = true,
		close = true,
		description = 'Брендовая сумка Anna Rex, старая коллекция',
		client = { image = 'kq_expensive_bag2.png' },
	},

	['kq_expensive_sneakers'] = {
		label = 'Спортивные кроссовки',
		weight = 400,
		stack = true,
		close = true,
		description = 'Спортивные кроссовки Nike, замяты носки',
		client = { image = 'kq_expensive_sneakers.png' },
	},

	['kq_expensive_sneakers2'] = {
		label = 'Дизайнерские кроссовки',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Дизайнерские кроссовки Gucci, пятна крови на подошве',
		client = { image = 'kq_expensive_sneakers2.png' },
	},

	['kq_cam'] = {
		label = 'Видеокамера',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Компактная видеокамера, удобна в использовании, отличное качество видео',
		client = { image = 'kq_cam.png' },
	},

	['kq_leather_jacket'] = {
		label = 'Кожаная куртка',
		weight = 500,
		stack = true,
		close = true,
		description = 'Кожаная куртка, замята и изношенна',
		client = { image = 'kq_leather_jacket.png' },
	},

	['kq_crashed_lokia'] = {
		label = 'Разбитый телефон',
		weight = 240,
		stack = true,
		close = true,
		description = 'Мобильный телефон бренда Lokia, разбит экран, поцарапан корпус',
		client = { image = 'kq_crashed_lokia.png' },
	},

	['kq_expensive_laptop3'] = {
		label = 'Старый ноутбук',
		weight = 1200,
		stack = true,
		close = true,
		description = 'Ноутбук Kakagawa, старая модель, отсуствует кнопка ESC',
		client = { image = 'kq_expensive_laptop3.png' },
	},

	['kq_gamboy'] = {
		label = 'Игровая приставка',
		weight = 210,
		stack = true,
		close = true,
		description = 'Портативная игровая приставка, соверешенно новая',
		client = { image = 'kq_gamboy.png' },
	},

	['kq_glasses'] = {
		label = 'Солнечные очки',
		weight = 45,
		stack = true,
		close = true,
		description = 'Обыкновенные солнечные очки Anna Rex, пару царапин на линзах',
		client = { image = 'kq_glasses.png' },
	},

	['kq_headphones'] = {
		label = 'Наушники от телефона',
		weight = 270,
		stack = true,
		close = true,
		description = 'Наушники от Sumo Nickson, новые, без коробки',
		client = { image = 'kq_headphones.png' },
	},

	['kq_player'] = {
		label = 'CD-плеер',
		weight = 350,
		stack = true,
		close = true,
		description = 'Старый CD-плеер, царапины на корпусе',
		client = { image = 'kq_player.png' },
	},

	['kq_diamond_necklace'] = {
		label = 'Бриллиантовое колье',
		weight = 1500,
		stack = true,
		close = true,
		description = 'Бриллиантовое колье, совершенно новое',
		client = { image = 'kq_diamond_necklace.png' },
	},

	['kq_goldbraslet'] = {
		label = 'Золотой браслет',
		weight = 90,
		stack = true,
		close = true,
		description = 'Золотой браслет, идеально подходит для любого наряда',
		client = { image = 'kq_goldbraslet.png' },
	},

	['kq_goldears'] = {
		label = 'Золотые серьги с бриллиантами',
		weight = 30,
		stack = true,
		close = true,
		description = 'Золотые серьги с бриллиантами, идеально для особых случаев',
		client = { image = 'kq_goldears.png' },
	},

	['kq_goldring'] = {
		label = 'Золотое кольцо',
		weight = 15,
		stack = true,
		close = true,
		description = 'Элегантное золотое кольцо 585 пробы',
		client = { image = 'kq_goldring.png' },
	},

	['kq_saphirering'] = {
		label = 'Кольцо с сапфиром',
		weight = 20,
		stack = true,
		close = true,
		description = 'Кольцо с сапфиром, блестит ярче звёзд',
		client = { image = 'kq_saphirering.png' },
	},

	['kq_silverchain'] = {
		label = 'Серебряная цепочка',
		weight = 90,
		stack = true,
		close = true,
		description = 'Обыкновенная серебрянная цепочка',
		client = { image = 'kq_silverchain.png' },
	},

	['kq_silverears'] = {
		label = 'Серебряные серьги с камнями',
		weight = 20,
		stack = true,
		close = true,
		description = 'Изящные сербрянные серьги с камнями, подойдут к любому образу',
		client = { image = 'kq_silverears.png' },
	},

	['megaphone'] = {
		label = 'Мегафон',
		weight = 500,
		stack = false,
		close = true,
		client = { image = 'megaphone.png' },
	},

	['gold_tooth'] = {
		label = 'Золотой зуб',
		weight = 2,
		stack = true,
		close = false,
		description = 'Gold Tooth',
		client = { image = 'goldtooth.png' },
	},

	['dirty_photo'] = {
		label = 'Грязное фото',
		weight = 2,
		stack = true,
		close = false,
		description = 'Dirty Photo',
		client = { image = 'dirty_photo.png' },
	},

	['chain'] = {
		label = 'Цепь',
		weight = 2,
		stack = true,
		close = false,
		description = 'Chain',
		client = { image = 'chain.png' },
	},

	['medal'] = {
		label = 'Медаль',
		weight = 2,
		stack = true,
		close = false,
		description = 'Medal',
		client = { image = 'medal.png' },
	},

	['rusted_tin'] = {
		label = 'Металлолом',
		weight = 2,
		stack = true,
		close = false,
		description = 'Rusted Tin',
		client = { image = 'rusted_tin.png' },
	},

	['nail'] = {
		label = 'Гвоздь',
		weight = 2,
		stack = true,
		close = false,
		description = 'Nail',
		client = { image = 'nail.png' },
	},

	['ring'] = {
		label = 'Кольцо',
		weight = 2,
		stack = true,
		close = false,
		description = 'Ring',
		client = { image = 'Ring.png' },
	},

	['vehicle_tyre'] = {
		label = 'Колесо',
		weight = 2,
		stack = true,
		close = false,
		description = 'Tyre',
		client = { image = 'vehicle_tyre.png' },
	},

	['vehicle_door'] = {
		label = 'Дверь',
		weight = 2,
		stack = true,
		close = false,
		description = 'Door',
		client = { image = 'vehicle_door.png' },
	},

	['housekey'] = {
		label = 'Ключи от дома',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Default House Key',
		client = { image = 'key.png' },
	},

	['spraycan2'] = {
		label = 'Баллончик',
		weight = 2,
		stack = true,
		close = false,
		client = { image = 'spraycan2.png' },
	},

	['acetone2'] = {
		label = 'Ацетон',
		weight = 2,
		stack = true,
		close = false,
		client = { image = 'acetone2.png' },
	},

	-- ['weapon_flaregun'] = {
	-- 	label = 'Сигнальный пистолет',
	-- 	weight = 410,
	-- 	stack = false,
	-- 	description = 'Однозарядный сигнальный пистолет, 12-ого калибра',
	-- 	client = { image = 'weapon_flaregun.png' },
	-- },

	-- ['weapon_stungun'] = {
	-- 	label = 'Тайзер',
	-- 	weight = 400,
	-- 	stack = false,
	-- 	description = 'Электрошокер, массово используемый в различных правоохранительных службах',
	-- 	client = { image = 'weapon_stungun.png' },
	-- },

	-- ['weapon_megaphone'] = {
	-- 	label = 'Мегафон',
	-- 	weight = 400,
	-- 	stack = false,
	-- 	description = 'Мегафон',
	-- 	client = { image = 'WEAPON_MEGAPHONE.png' },
	-- },

	-- ['weapon_colbaton'] = {
	-- 	label = 'Телескопическая дубинка',
	-- 	weight = 400,
	-- 	stack = false,
	-- 	description = 'Телескопическая дубинка',
	-- 	client = { image = 'weapon_colbaton.png' },
	-- },

	-- ['weapon_mg'] = {
	-- 	label = 'Pecheneg',
	-- 	weight = 11000,
	-- 	stack = false,
	-- 	description = 'Пулемёт российского производства калибра 7,62x54mm',
	-- 	client = { image = 'weapon_mg.png' },
	-- },

	-- ['weapon_combatmg'] = {
	-- 	label = 'M249',
	-- 	weight = 10000,
	-- 	stack = false,
	-- 	description = 'Американский распространённый пулемёт в калибре 5,56x45mm NATO',
	-- 	client = { image = 'weapon_combatmg.png' },
	-- },

	-- ['weapon_sniperrifle'] = {
	-- 	label = 'Remington M 700',
	-- 	weight = 4100,
	-- 	stack = false,
	-- 	description = 'Классическая болтовая винтовка, калибра 7,62x51mm NATO',
	-- 	client = { image = 'weapon_sniperrifle.png' },
	-- },

	-- ['weapon_heavysniper'] = {
	-- 	label = 'Barrett M82A1',
	-- 	weight = 14000,
	-- 	stack = false,
	-- 	description = 'Американская самозарядная крупнокалиберная снайперская винтовка, выпускаемая компанией Barrett Firearms Manufacturing, тяжелого калибра .50 BMG',
	-- 	client = { image = 'weapon_heavysniper.png' },
	-- },

	-- ['weapon_marksmanrifle'] = {
	-- 	label = 'M1 Garand',
	-- 	weight = 5100,
	-- 	stack = false,
	-- 	description = 'Американская самозарядная винтовка времён Второй мировой войны, калибра 7,62x63mm',
	-- 	client = { image = 'weapon_marksmanrifle.png' },
	-- },

	-- ['weapon_marksmanrifle_mk2'] = {
	-- 	label = 'MK 14',
	-- 	weight = 5100,
	-- 	stack = false,
	-- 	description = 'Американская марксманская винтовка, разработанное для ВМФ США, калибра 7,62x51mm NATO',
	-- 	client = { image = 'weapon_marksmanrifle_mk2.png' },
	-- },

	-- ['weapon_rpg'] = {
	-- 	label = 'RPG-7',
	-- 	weight = 15000,
	-- 	stack = false,
	-- 	description = 'Классический советский ручной противотанковый гранатомёт многоразового применения',
	-- 	client = { image = 'weapon_rpg.png' },
	-- },

	-- ['weapon_grenadelauncher'] = {
	-- 	label = 'MGL (Фугас)',
	-- 	weight = 5500,
	-- 	stack = false,
	-- 	description = 'Современный гранатомёт с вместительным барабаном, калибра 40mm, для стрельбы осколочными гранатами',
	-- 	client = { image = 'weapon_grenadelauncher.png' },
	-- },

	-- ['weapon_grenadelauncher_smoke'] = {
	-- 	label = 'MGL (Дым)',
	-- 	weight = 5500,
	-- 	stack = false,
	-- 	description = 'Современный гранатомёт с вместительным барабаном, калибра 40mm, для стрельбы дымовыми гранатами',
	-- 	client = { image = 'weapon_grenadelauncher_smoke.png' },
	-- },

	-- ['weapon_compactlauncher'] = {
	-- 	label = 'M79',
	-- 	weight = 3000,
	-- 	stack = false,
	-- 	description = 'Однозарядный, обрезанный гранатомёт калибра 40mm, для стрельбы осколочными гранатами',
	-- 	client = { image = 'weapon_compactlauncher.png' },
	-- },

	-- ['weapon_hominglauncher'] = {
	-- 	label = 'FIM-92 Stinger',
	-- 	weight = 16000,
	-- 	stack = false,
	-- 	description = 'Переносной зенитно-ракетный комплекс, предназначенный для поражения воздушных целей, кроме того обеспечивает возможность обстрела небронированных наземных или надводных целей',
	-- 	client = { image = 'weapon_hominglauncher.png' },
	-- },

	-- ['weapon_grenade'] = {
	-- 	label = 'M67',
	-- 	weight = 400,
	-- 	stack = false,
	-- 	description = 'Стандартная американская ручная осколочная граната, для взрывоопасных сюрпризов',
	-- 	client = { image = 'weapon_grenade.png' },
	-- },

	-- ['weapon_smokegrenade'] = {
	-- 	label = 'M18',
	-- 	weight = 500,
	-- 	stack = false,
	-- 	description = 'Дымовая граната, испускающая большую завесу',
	-- 	client = { image = 'weapon_c4.png' },
	-- },

	-- ['weapon_proxmine'] = {
	-- 	label = 'M18A1 Claymore',
	-- 	weight = 400,
	-- 	stack = false,
	-- 	description = 'Американская противопехотная мина, снаряжённая зарядом C4',
	-- 	client = { image = 'weapon_proximitymine.png' },
	-- },

	-- ['weapon_stickybomb'] = {
	-- 	label = 'C4',
	-- 	weight = 400,
	-- 	stack = false,
	-- 	description = 'Заряд взрывчатки с подключенным детонатором для возможности дистанционного подрыва',
	-- 	client = { image = 'weapon_stickybomb.png' },
	-- },

	-- ['weapon_bzgas'] = {
	-- 	label = 'BZ',
	-- 	weight = 500,
	-- 	stack = false,
	-- 	description = 'Граната с подозрительным газом',
	-- 	client = { image = 'weapon_bzgas.png' },
	-- },

	-- ['weapon_molotov'] = {
	-- 	label = 'Молотов',
	-- 	weight = 250,
	-- 	stack = false,
	-- 	description = 'Нестареющая классика: зажигательная смесь и тряпка - Коктейль Молотова',
	-- 	client = { image = 'weapon_molotov.png' },
	-- },

	-- ['weapon_ball'] = {
	-- 	label = 'Мяч',
	-- 	weight = 100,
	-- 	stack = false,
	-- 	description = 'Игровой бейсбольный шар, выполненный по всем стандартам MLB',
	-- 	client = { image = 'weapon_ball.png' },
	-- },

	-- ['weapon_pipebomb'] = {
	-- 	label = 'Самодельная граната',
	-- 	weight = 350,
	-- 	stack = false,
	-- 	description = 'Самодельная осколочная граната, имеет нестабильный запал и меньшую энергию',
	-- 	client = { image = 'weapon_pipebomb.png' },
	-- },

	-- ['weapon_flare'] = {
	-- 	label = 'Флейр',
	-- 	weight = 100,
	-- 	stack = false,
	-- 	description = 'Химический источник света',
	-- 	client = { image = 'weapon_flare.png' },
	-- },

	-- ['weapon_snowball'] = {
	-- 	label = 'Снежок',
	-- 	weight = 50,
	-- 	stack = false,
	-- 	description = 'Легендарное, самодельное метательное оружие состоящее из снега и уличной грязи',
	-- 	client = { image = 'weapon_snowball.png' },
	-- },

	-- ['weapon_marksmanpistol'] = {
	-- 	label = 'Однозарядный пистолет',
	-- 	weight = 830,
	-- 	stack = false,
	-- 	description = 'Классический однозарядный пистолет, традиционно используемый на дуелях',
	-- 	client = { image = 'weapon_marksmanpistol.png' },
	-- },

	-- ['weapon_raypistol'] = {
	-- 	label = 'Импульсный пистолет',
	-- 	weight = 8000,
	-- 	stack = false,
	-- 	description = 'Пистолет из будущего, запускающий энергетический импульсный заряд',
	-- 	client = { image = 'weapon_raypistol.png' },
	-- },

	-- ['weapon_raycarbine'] = {
	-- 	label = 'Лазерный карабин',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Электро-Магнитная пушка из будущего',
	-- 	client = { image = 'weapon_raycarbine.png' },
	-- },

	-- ['weapon_firework'] = {
	-- 	label = 'Феерверк',
	-- 	weight = 1900,
	-- 	stack = false,
	-- 	description = 'Кустарное устройство для запуска феерверков',
	-- 	client = { image = 'weapon_firework.png' },
	-- },

	-- ['weapon_rayminigun'] = {
	-- 	label = 'Лазерный пулемёт',
	-- 	weight = 10000,
	-- 	stack = false,
	-- 	description = 'Электро-Магнитная тяжелая пушка из будущего',
	-- 	client = { image = 'weapon_rayminigun.png' },
	-- },

	-- ['weapon_railgun'] = {
	-- 	label = 'Рельсотрон',
	-- 	weight = 10000,
	-- 	stack = false,
	-- 	description = 'Устройство для разгона снарядов электро-магнитным импульсом',
	-- 	client = { image = 'weapon_railgun.png' },
	-- },

	-- ['sniperrifle_defaultclip'] = {
	-- 	label = 'Sniper Suppressor',
	-- 	weight = 1000,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Sniper Rifle Default Clip',
	-- 	client = { image = 'pistol_suppressor.png' },
	-- },

	-- ['sniper_scope'] = {
	-- 	label = 'Sniper Scope',
	-- 	weight = 1000,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Sniper Rifle Scope Attachment',
	-- 	client = { image = 'smg_scope.png' },
	-- },

	-- ['snipermax_scope'] = {
	-- 	label = 'Оптический прицел',
	-- 	weight = 1000,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Оптический прицел для болтовой винтовки',
	-- 	client = { image = 'smg_scope.png' },
	-- },

	-- ['sniper_grip'] = {
	-- 	label = 'Sniper Grip',
	-- 	weight = 1000,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Sniper Rifle Grip Attachment',
	-- 	client = { image = 'pistol_suppressor.png' },
	-- },

	-- ['weapon_pike'] = {
	-- 	label = 'Багор',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_pike.png' },
	-- },

	-- ['weapon_buster'] = {
	-- 	label = 'Молоток-гвоздодер',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_buster.png' },
	-- },

	-- ['weapon_flathead'] = {
	-- 	label = 'Топор пожарный',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_flathead.png' },
	-- },

	-- ['weapon_pickhead'] = {
	-- 	label = 'Топор штурмовой',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_pickhead.png' },
	-- },

	-- ['weapon_pulaski'] = {
	-- 	label = 'Топор-мотыга',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_pulaski.png' },
	-- },

	-- ['weapon_sledge'] = {
	-- 	label = 'Кувалда',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_sledge.png' },
	-- },

	-- ['weapon_newyork'] = {
	-- 	label = 'Крюк пожарный',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_newyork.png' },
	-- },

	-- ['weapon_forester'] = {
	-- 	label = 'Грабли McLeod',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_forester.png' },
	-- },

	-- ['weapon_halligan'] = {
	-- 	label = 'Хулиган',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_halligan.png' },
	-- },

	-- ['weapon_hydrant'] = {
	-- 	label = 'Ключ гидрантный',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Пожарный инструмент',
	-- 	client = { image = 'weapon_hydrant.png' },
	-- },

	-- ['weapon_unarmed'] = {
	-- 	label = 'Кулак',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Кулачок',
	-- 	client = { image = 'placeholder.png' },
	-- },

	-- ['weapon_dagger'] = {
	-- 	label = 'Штык-Нож',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Большой и страшный штык-нож армии США',
	-- 	client = { image = 'weapon_dagger.png' },
	-- },

	-- ['weapon_bat'] = {
	-- 	label = 'Бита',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Игровая бейсбольная бита, выполненная по всем стандартам MLB',
	-- 	client = { image = 'weapon_bat.png' },
	-- },

	-- ['weapon_bottle'] = {
	-- 	label = 'Разбитая бутылка',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Разбитая бутылка, классическая "розочка"',
	-- 	client = { image = 'weapon_bottle.png' },
	-- },

	-- ['weapon_crowbar'] = {
	-- 	label = 'Лом',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Простейший цельный железный инструмент',
	-- 	client = { image = 'weapon_crowbar.png' },
	-- },

	-- ['weapon_flashlight'] = {
	-- 	label = 'Фонарик',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Большой портативый фонарик',
	-- 	client = { image = 'weapon_flashlight.png' },
	-- },

	-- ['weapon_golfclub'] = {
	-- 	label = 'Клюшка',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Стандартная клюшка гольфа',
	-- 	client = { image = 'weapon_golfclub.png' },
	-- },

	-- ['weapon_hammer'] = {
	-- 	label = 'Молоток',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Популярный инструмент в забивании гвоздей',
	-- 	client = { image = 'weapon_hammer.png' },
	-- },

	-- ['weapon_hatchet'] = {
	-- 	label = 'Топор',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Короткий походный топорик',
	-- 	client = { image = 'weapon_hatchet.png' },
	-- },

	-- ['weapon_knuckle'] = {
	-- 	label = 'Кастет',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Удобное и подлое оружие ближнего боя, стандартный и простейший металический кастет',
	-- 	client = { image = 'weapon_knuckle.png' },
	-- },

	-- ['weapon_knife'] = {
	-- 	label = 'Боевой нож',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Закалённый боевой нож, серьёзное орудие',
	-- 	client = { image = 'weapon_knife.png' },
	-- },

	-- ['weapon_machete'] = {
	-- 	label = 'Мачете',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Мачете для уборки зарослей',
	-- 	client = { image = 'weapon_machete.png' },
	-- },

	-- ['weapon_switchblade'] = {
	-- 	label = 'Выкидной нож',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Очень удобный и компактный складной нож',
	-- 	client = { image = 'weapon_switchblade.png' },
	-- },

	-- ['weapon_nightstick'] = {
	-- 	label = 'Дубинка',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Атрибут правосудия и преувеличения полномочий',
	-- 	client = { image = 'weapon_nightstick.png' },
	-- },

	-- ['weapon_wrench'] = {
	-- 	label = 'Гаечный ключ',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Стандартный тяжеленный разводной ключ',
	-- 	client = { image = 'weapon_wrench.png' },
	-- },

	-- ['weapon_battleaxe'] = {
	-- 	label = 'Боевой топр',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Стильный топорик, выполненный в воинственном стиле',
	-- 	client = { image = 'weapon_battleaxe.png' },
	-- },

	-- ['weapon_poolcue'] = {
	-- 	label = 'Кий',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Бильярдный кий, для ударов, по шарам',
	-- 	client = { image = 'weapon_poolcue.png' },
	-- },

	-- ['weapon_briefcase'] = {
	-- 	label = 'Кейс',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Противоударный кейс, для чего-то важного',
	-- 	client = { image = 'weapon_briefcase.png' },
	-- },

	-- ['weapon_briefcase_02'] = {
	-- 	label = 'Портмоне',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Стандартный кожаный портфель',
	-- 	client = { image = 'weapon_briefcase2.png' },
	-- },

	-- ['weapon_garbagebag'] = {
	-- 	label = 'Мусорный мешок',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Мешок для мусора и всякой всячины',
	-- 	client = { image = 'weapon_garbagebag.png' },
	-- },

	-- ['weapon_stone_hatchet'] = {
	-- 	label = 'Каменный топор',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Каменный топор',
	-- 	client = { image = 'weapon_stone_hatchet.png' },
	-- },

	-- ['weapon_c1911'] = {
	-- 	label = 'Colt 1911',
	-- 	weight = 1100,
	-- 	stack = false,
	-- 	description = 'Проверенный временем пистолет M1911, калибра .45 ACP',
	-- 	client = { image = 'weapon_c1911.png' },
	-- },

	-- ['weapon_c45'] = {
	-- 	label = 'Colt M45',
	-- 	weight = 1100,
	-- 	stack = false,
	-- 	description = 'Проверенный временем пистолет M1911 в модификации M45, калибра .45 ACP',
	-- 	client = { image = 'weapon_c45.png' },
	-- },

	-- ['weapon_automag'] = {
	-- 	label = 'Auto Mag AMP 180',
	-- 	weight = 1300,
	-- 	stack = false,
	-- 	description = 'Крупнокалиберный пистолет под редкий патрон .44 Auto Mag',
	-- 	client = { image = 'weapon_automag.png' },
	-- },

	-- ['weapon_deagle'] = {
	-- 	label = 'Desert Eagle',
	-- 	weight = 1690,
	-- 	stack = false,
	-- 	description = 'Легендарный пистолет, настоящая кинозвезда - Desert Eagle, калибра .44 Mag',
	-- 	client = { image = 'weapon_deagle.png' },
	-- },

	-- ['weapon_ppk'] = {
	-- 	label = 'Walther PPK',
	-- 	weight = 800,
	-- 	stack = false,
	-- 	description = 'Классический немецкий пистолет, под калибр .380 ACP',
	-- 	client = { image = 'weapon_ppk.png' },
	-- },

	-- ['weapon_jun'] = {
	-- 	label = 'Colt Junior',
	-- 	weight = 800,
	-- 	stack = false,
	-- 	description = 'Очень компактный и легкий пистолет Colt Junior в калибре .25 ACP',
	-- 	client = { image = 'weapon_jun.png' },
	-- },

	-- ['weapon_pm'] = {
	-- 	label = 'PM',
	-- 	weight = 900,
	-- 	stack = false,
	-- 	description = 'Советский пистолет в редком калибре 9x18mm PM',
	-- 	client = { image = 'weapon_pm.png' },
	-- },

	-- ['weapon_tec9'] = {
	-- 	label = 'Tec-9',
	-- 	weight = 1600,
	-- 	stack = false,
	-- 	description = 'Легендарный в гангстерских кругах, шведский пистолет Intratec, калибра 9x19mm',
	-- 	client = { image = 'weapon_tec9.png' },
	-- },

	-- ['weapon_tec9a'] = {
	-- 	label = 'Tec-9 A',
	-- 	weight = 1600,
	-- 	stack = false,
	-- 	description = 'Легендарный в гангстерских кругах, шведский пистолет Intratec, калибра 9x19mm',
	-- 	client = { image = 'weapon_tec9.png' },
	-- },

	-- ['weapon_swmp9'] = {
	-- 	label = 'S&W M&P',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Очень современный и эргономичный пистолет Smith & Wesson, калибра 9x19mm',
	-- 	client = { image = 'weapon_swmp9.png' },
	-- },

	-- ['weapon_sw659'] = {
	-- 	label = 'S&W Model 659',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Классический и простой пистолет Smith & Wesson, калибра 9x19mm',
	-- 	client = { image = 'weapon_sw659.png' },
	-- },

	-- ['weapon_g2'] = {
	-- 	label = 'Pindad G2 Combat',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Необычный, для американского рынка, индонезийский пистолет, калибра 9x19mm',
	-- 	client = { image = 'weapon_g2.png' },
	-- },

	-- ['weapon_g17'] = {
	-- 	label = 'Glock 17',
	-- 	weight = 900,
	-- 	stack = false,
	-- 	description = 'Массовый и надежный, классический пистолет Glock 17, калибра 9x19mm',
	-- 	client = { image = 'weapon_g17.png' },
	-- },

	-- ['weapon_g18c'] = {
	-- 	label = 'Glock 18c',
	-- 	weight = 900,
	-- 	stack = false,
	-- 	description = 'Старый добрый, полностью автоматический пистолет Glock 18, калибра 9x19mm',
	-- 	client = { image = 'weapon_g18c.png' },
	-- },

	-- ['weapon_m9'] = {
	-- 	label = 'Beretta M9',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Стандартный и удобный американский пистолет Beretta M9, калибра 9x19mm',
	-- 	client = { image = 'weapon_m9.png' },
	-- },

	-- ['weapon_m9a1'] = {
	-- 	label = 'Beretta M9A1',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Стандартный и удобный американский пистолет Beretta M9 в модификации M1, калибра 9x19mm',
	-- 	client = { image = 'weapon_m9a1.png' },
	-- },

	-- ['weapon_p220'] = {
	-- 	label = 'Sig Sauer P220',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Популярный швейцарско-германский пистолет SIG Sauer P220, калибра .45 ACP',
	-- 	client = { image = 'weapon_p220.png' },
	-- },

	-- ['weapon_p7'] = {
	-- 	label = 'HK P7',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	client = { image = 'weapon_p7.png' },
	-- },

	-- ['weapon_b76'] = {
	-- 	label = 'Benelli B76',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	client = { image = 'weapon_b76.png' },
	-- },

	-- ['small_flashlight'] = {
	-- 	label = 'Фонарик для оружия',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный фонарик для пистолета',
	-- 	client = { image = 'smg_flashlight.png' },
	-- },

	-- ['45_suppressor'] = {
	-- 	label = 'Глушитель',
	-- 	weight = 250,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный глушитель для оружия калибра .45 ACP',
	-- 	client = { image = 'pistol_suppressor.png' },
	-- },

	-- ['919_suppressor'] = {
	-- 	label = 'Глушитель',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный глушитель для оружия калибра 9x19mm',
	-- 	client = { image = 'pistol_suppressor.png' },
	-- },

	-- ['c1911_7_clip'] = {
	-- 	label = 'Магазин на 7 патрон',
	-- 	weight = 70,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Colt M1911',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['c45_7_clip'] = {
	-- 	label = 'Магазин на 7 патрон',
	-- 	weight = 70,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Colt M45',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['c45_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин для пистолета Colt M45',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['c45_16_clip'] = {
	-- 	label = 'Магазин на 16 патрон',
	-- 	weight = 160,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин для пистолета Colt M45',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['automag_7_clip'] = {
	-- 	label = 'Магазин на 7 патрон',
	-- 	weight = 70,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Auto Mag AMP 180',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['ppk_6_clip'] = {
	-- 	label = 'Магазин на 6 патрон',
	-- 	weight = 60,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Walther PPK',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['jun_7_clip'] = {
	-- 	label = 'Магазин на 7 патрон',
	-- 	weight = 70,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Colt Junior',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['jun_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на пистолет Colt Junior',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['pm_8_clip'] = {
	-- 	label = 'Магазин на 8 патрон',
	-- 	weight = 80,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Макарова',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['tec_20_clip'] = {
	-- 	label = 'Магазин на 20 патрон',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин для пистолета Tec-9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['tec_32_clip'] = {
	-- 	label = 'Магазин на 32 патрон',
	-- 	weight = 320,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на пистолет Tec-9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['tec_50_clip'] = {
	-- 	label = 'Магазин на 50 патрон',
	-- 	weight = 500,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Барабанный магазин для пистолета Tec-9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['swmp9_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Ограниченный магазин на пистолет S&W M&P9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['swmp9_15_clip'] = {
	-- 	label = 'Магазин на 15 патрон',
	-- 	weight = 150,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин для пистолета S&W M&P9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['swmp9_17_clip'] = {
	-- 	label = 'Магазин на 17 патрон',
	-- 	weight = 170,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин для пистолета S&W M&P9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sw69_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 130,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Ограниченный магазин на пистолет S&W 659',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sw69_14_clip'] = {
	-- 	label = 'Магазин на 14 патрон',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин для пистолета S&W 659',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sw69_20_clip'] = {
	-- 	label = 'Магазин на 20 патрон',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин для пистолета S&W 659',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['g2_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Ограниченный магазин на пистолет G2 Combat',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['g2_15_clip'] = {
	-- 	label = 'Магазин на 15 патрон',
	-- 	weight = 150,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин для пистолета G2 Combat',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['g17_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 160,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Ограниченный магазин на пистолет Glock',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['g17_17_clip'] = {
	-- 	label = 'Магазин на 17 патрон',
	-- 	weight = 170,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Glock',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['g17_21_clip'] = {
	-- 	label = 'Магазин на 21 патрон',
	-- 	weight = 210,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на пистолет Glock',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['g17_33_clip'] = {
	-- 	label = 'Магазин на 33 патрон',
	-- 	weight = 330,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на пистолет Glock',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m9_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 160,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Ограниченный магазин на пистолет Beretta M9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m9_15_clip'] = {
	-- 	label = 'Магазин на 15 патрон',
	-- 	weight = 160,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет Beretta M9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m9_20_clip'] = {
	-- 	label = 'Магазин на 20 патрон',
	-- 	weight = 160,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на пистолет Beretta M9',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['p220_8_clip'] = {
	-- 	label = 'Магазин на 8 патрон',
	-- 	weight = 80,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на пистолет P220',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['p220_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на пистолет P220',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['weapon_sw15b'] = {
	-- 	label = 'S&W Model 15',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Дешёвый и массовый револьвер Smith & Wesson Model 15, калибра .45 ACP',
	-- 	client = { image = 'weapon_sw15b.png' },
	-- },

	-- ['weapon_sw15sb'] = {
	-- 	label = 'S&W Model 15',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Дешёвый и массовый револьвер Smith & Wesson Model 15, укороченный, калибра .45 ACP',
	-- 	client = { image = 'weapon_sw15sb.png' },
	-- },

	-- ['weapon_sw15w'] = {
	-- 	label = 'S&W Model 15',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Дешёвый и массовый револьвер Smith & Wesson Model 15, калибра .45 ACP',
	-- 	client = { image = 'weapon_sw15w.png' },
	-- },

	-- ['weapon_sw15sw'] = {
	-- 	label = 'S&W Model 15',
	-- 	weight = 1000,
	-- 	stack = false,
	-- 	description = 'Дешёвый и массовый револьвер Smith & Wesson Model 15, укороченный, калибра .45 ACP',
	-- 	client = { image = 'weapon_sw15sw.png' },
	-- },

	-- ['weapon_microuzi'] = {
	-- 	label = 'Micro-UZI',
	-- 	weight = 1900,
	-- 	stack = false,
	-- 	description = 'Легендарный и лёгкий пистолет-пулемёт, израильского производства, в калибре 9x19mm',
	-- 	client = { image = 'weapon_microuzi.png' },
	-- },

	-- ['weapon_microuzil'] = {
	-- 	label = 'Micro-UZI Semi',
	-- 	weight = 1900,
	-- 	stack = false,
	-- 	description = 'Легендарный и лёгкий пистолет-пулемёт, израильского производства, в калибре 9x19mm, в гражданской вариации',
	-- 	client = { image = 'weapon_microuzi.png' },
	-- },

	-- ['weapon_mac10'] = {
	-- 	label = 'Mac-10',
	-- 	weight = 2300,
	-- 	stack = false,
	-- 	description = 'Неэргономичный и тяжелый пистолет-пулемёт американской компании Ingram, калибра .45 ACP',
	-- 	client = { image = 'weapon_mac10.png' },
	-- },

	-- ['weapon_ump'] = {
	-- 	label = 'HK UMP-45',
	-- 	weight = 2600,
	-- 	stack = false,
	-- 	description = 'Известный пистолет-пулемёт Heckler & Koch, калибра .45 ACP',
	-- 	client = { image = 'weapon_ump.png' },
	-- },

	-- ['weapon_umpl'] = {
	-- 	label = 'HK UMP-45 Semi',
	-- 	weight = 2600,
	-- 	stack = false,
	-- 	description = 'Известный пистолет-пулемёт Heckler & Koch, калибра .45 ACP, в гражданской вариации',
	-- 	client = { image = 'weapon_ump.png' },
	-- },

	-- ['weapon_pm12'] = {
	-- 	label = 'Beretta PM-12S',
	-- 	weight = 2800,
	-- 	stack = false,
	-- 	description = 'Дешевый и устаревший пистолет-пулемет итальянской компании Beretta, калибра 9x19mm',
	-- 	client = { image = 'weapon_pm12.png' },
	-- },

	-- ['weapon_mp5'] = {
	-- 	label = 'HK MP5',
	-- 	weight = 2500,
	-- 	stack = false,
	-- 	description = 'Известный пистолет-пулемёт Heckler & Koch, калибра 9x19mm',
	-- 	client = { image = 'weapon_mp5.png' },
	-- },

	-- ['weapon_mp5k'] = {
	-- 	label = 'HK MP5-K',
	-- 	weight = 2300,
	-- 	stack = false,
	-- 	description = 'Известный пистолет-пулемёт Heckler & Koch, укороченного исполнения, калибра 9x19mm',
	-- 	client = { image = 'weapon_mp5k.png' },
	-- },

	-- ['weapon_m4'] = {
	-- 	label = 'Винтовка Colt M4',
	-- 	weight = 3000,
	-- 	stack = false,
	-- 	description = 'Известная винтовка, калибр 5.56',
	-- 	client = {  },
	-- },

	-- ['mac10_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на Mac-10',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['mac10_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 300,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин для Mac-10',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['mac10_suppressor'] = {
	-- 	label = 'Глушитель',
	-- 	weight = 350,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный глушитель на Mac-10',
	-- 	client = { image = 'pistol_suppressor.png' },
	-- },

	-- ['microuzi_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на Uzi',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['microuzi_16_clip'] = {
	-- 	label = 'Магазин на 16 патрон',
	-- 	weight = 160,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин для Uzi',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['microuzi_32_clip'] = {
	-- 	label = 'Магазин на 32 патрон',
	-- 	weight = 320,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин для Uzi',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['ump_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на UMP-45',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['ump_25_clip'] = {
	-- 	label = 'Магазин на 25 патрон',
	-- 	weight = 250,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на UMP-45',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['mp5_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на MP5',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['mp5_15_clip'] = {
	-- 	label = 'Магазин на 15 патрон',
	-- 	weight = 150,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин MP5',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['mp5_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 300,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на MP5',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['mp12_32_clip'] = {
	-- 	label = 'Магазин на 32 патрон',
	-- 	weight = 320,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на Beretta MP-12',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['mp12_40_clip'] = {
	-- 	label = 'Магазин на 40 патрон',
	-- 	weight = 400,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на Beretta MP-12',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['weapon_akm'] = {
	-- 	label = 'AKM',
	-- 	weight = 3700,
	-- 	stack = false,
	-- 	description = 'Легендарный, надежный и мощный 7,62x39mm автомат Калашникова (модернизированный), не стареющая классика',
	-- 	client = { image = 'weapon_akm.png' },
	-- },

	-- ['weapon_akml'] = {
	-- 	label = 'AKM Semi',
	-- 	weight = 3700,
	-- 	stack = false,
	-- 	description = 'Легендарный, надежный и мощный 7,62x39mm автомат Калашникова (модернизированный), не стареющая классика',
	-- 	client = { image = 'weapon_akm.png' },
	-- },

	-- ['weapon_ak74'] = {
	-- 	label = 'AK-74',
	-- 	weight = 3600,
	-- 	stack = false,
	-- 	description = 'Автомат Калашникова, разработанный под малоимпульсный патрон 5,45x39mm',
	-- 	client = { image = 'weapon_ak74.png' },
	-- },

	-- ['weapon_ak74l'] = {
	-- 	label = 'AK-74 Semi',
	-- 	weight = 3600,
	-- 	stack = false,
	-- 	description = 'Автомат Калашникова, разработанный под малоимпульсный патрон 5,45x39mm',
	-- 	client = { image = 'weapon_ak74.png' },
	-- },

	-- ['weapon_sks'] = {
	-- 	label = 'SKS Carbine',
	-- 	weight = 3800,
	-- 	stack = false,
	-- 	client = { image = 'weapon_sks.png' },
	-- },

	-- ['weapon_m1c'] = {
	-- 	label = 'M1 Carbine',
	-- 	weight = 2800,
	-- 	stack = false,
	-- 	client = { image = 'weapon_m1c.png' },
	-- },

	-- ['weapon_m4a1'] = {
	-- 	label = 'Colt M4A1',
	-- 	weight = 3200,
	-- 	stack = false,
	-- 	client = { image = 'weapon_m4a1.png' },
	-- },

	-- ['weapon_m16a1'] = {
	-- 	label = 'Colt M16A1',
	-- 	weight = 3300,
	-- 	stack = false,
	-- 	client = { image = 'weapon_m16a1.png' },
	-- },

	-- ['weapon_m16a2'] = {
	-- 	label = 'Colt M16A2',
	-- 	weight = 3400,
	-- 	stack = false,
	-- 	client = { image = 'weapon_m16a2.png' },
	-- },

	-- ['weapon_m16a2c'] = {
	-- 	label = 'Colt M16A2 Commando',
	-- 	weight = 3000,
	-- 	stack = false,
	-- 	client = { image = 'weapon_m16a2c.png' },
	-- },

	-- ['weapon_sg552'] = {
	-- 	label = 'SIG SG552 Commando',
	-- 	weight = 3400,
	-- 	stack = false,
	-- 	client = { image = 'weapon_sg552.png' },
	-- },

	-- ['weapon_sg552l'] = {
	-- 	label = 'SIG SG552 Commando Semi',
	-- 	weight = 3400,
	-- 	stack = false,
	-- 	client = { image = 'weapon_sg552.png' },
	-- },

	-- ['small_scope'] = {
	-- 	label = 'Малый прицел',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный глушитель для оружия калибра 9x19mm',
	-- 	client = { image = 'rifle_scope.png' },
	-- },

	-- ['mid_scope'] = {
	-- 	label = 'Средний прицел',
	-- 	weight = 250,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный глушитель для оружия калибра 9x19mm',
	-- 	client = { image = 'rifle_scope.png' },
	-- },

	-- ['large_scope'] = {
	-- 	label = 'Большой прицел',
	-- 	weight = 300,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный глушитель для оружия калибра 9x19mm',
	-- 	client = { image = 'rifle_scope.png' },
	-- },

	-- ['akm_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на AKM',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['akm_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 300,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на AKM',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['akm_40_clip'] = {
	-- 	label = 'Магазин на 40 патрон',
	-- 	weight = 400,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на AKM',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['ak74_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на AKM',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['ak74_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 300,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на AKM',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['ak74_45_clip'] = {
	-- 	label = 'Магазин на 40 патрон',
	-- 	weight = 400,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на AKM',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sks_20_clip'] = {
	-- 	label = 'Магазин на 20 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на SKS',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sks_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на SKS',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m1c_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на M1 Carabine',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m1c_15_clip'] = {
	-- 	label = 'Магазин на 15 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на M1 Carabine',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m1c_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на M1 Carabine',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m16_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на M16',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m16_20_clip'] = {
	-- 	label = 'Магазин на 20 патрон',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на M16',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m16_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 300,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на M16',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sg552_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Укороченный магазин на SG552',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sg552_20_clip'] = {
	-- 	label = 'Магазин на 20 патрон',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на SG552',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['sg552_30_clip'] = {
	-- 	label = 'Магазин на 30 патрон',
	-- 	weight = 300,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на SG552',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['m4_clip_30_01'] = {
	-- 	label = 'Магазин 30 патронов [1]',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный магазин на 30 патронов для M4',
	-- 	client = { image = 'm4_clip_30.png' },
	-- },

	-- ['m4_clip_30_02'] = {
	-- 	label = 'Магазин 30 патронов [2]',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Альтернативный магазин на 30 патронов для M4',
	-- 	client = { image = 'm4_clip_30.png' },
	-- },

	-- ['m4_clip_30_03'] = {
	-- 	label = 'Магазин 30 патронов [3]',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Альтернативный магазин на 30 патронов для M4',
	-- 	client = { image = 'm4_clip_30.png' },
	-- },

	-- ['m4_clip_30_04'] = {
	-- 	label = 'Магазин 30 патронов [4]',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Альтернативный магазин на 30 патронов для M4',
	-- 	client = { image = 'm4_clip_30.png' },
	-- },

	-- ['m4_clip_60_01'] = {
	-- 	label = 'Магазин 60 патронов [1]',
	-- 	weight = 150,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на 60 патронов для M4',
	-- 	client = { image = 'm4_clip_60.png' },
	-- },

	-- ['m4_clip_60_02'] = {
	-- 	label = 'Магазин 60 патронов [2]',
	-- 	weight = 150,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Альтернативный увеличенный магазин на 60 патронов для M4',
	-- 	client = { image = 'm4_clip_60.png' },
	-- },

	-- ['m4_clip_100'] = {
	-- 	label = 'Магазин 100 патронов',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Барабанный магазин на 100 патронов для M4',
	-- 	client = { image = 'm4_clip_100.png' },
	-- },

	-- ['m4_stock_01'] = {
	-- 	label = 'Приклад #1',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Приклад для M4, вариант #1',
	-- 	client = { image = 'm4_stock.png' },
	-- },

	-- ['m4_stock_02'] = {
	-- 	label = 'Приклад #2',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Приклад для M4, вариант #2',
	-- 	client = { image = 'm4_stock.png' },
	-- },

	-- ['m4_stock_03'] = {
	-- 	label = 'Приклад #3',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Приклад для M4, вариант #3',
	-- 	client = { image = 'm4_stock.png' },
	-- },

	-- ['m4_stock_04'] = {
	-- 	label = 'Приклад #4',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Приклад для M4, вариант #4',
	-- 	client = { image = 'm4_stock.png' },
	-- },

	-- ['m4_stock_05'] = {
	-- 	label = 'Приклад #5',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Приклад для M4, вариант #5',
	-- 	client = { image = 'm4_stock.png' },
	-- },

	-- ['m4_handguard_01'] = {
	-- 	label = 'Цевьё #1',
	-- 	weight = 130,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Цевьё для M4, вариант #1',
	-- 	client = { image = 'm4_handguard.png' },
	-- },

	-- ['m4_handguard_02'] = {
	-- 	label = 'Цевьё #2',
	-- 	weight = 130,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Цевьё для M4, вариант #2',
	-- 	client = { image = 'm4_handguard.png' },
	-- },

	-- ['m4_handguard_03'] = {
	-- 	label = 'Цевьё #3',
	-- 	weight = 130,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Цевьё для M4, вариант #3',
	-- 	client = { image = 'm4_handguard.png' },
	-- },

	-- ['m4_grip_01'] = {
	-- 	label = 'Рукоятка #1',
	-- 	weight = 80,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Рукоятка для M4, вариант #1',
	-- 	client = { image = 'm4_grip.png' },
	-- },

	-- ['m4_grip_02'] = {
	-- 	label = 'Рукоятка #2',
	-- 	weight = 80,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Рукоятка для M4, вариант #2',
	-- 	client = { image = 'm4_grip.png' },
	-- },

	-- ['m4_grip_03'] = {
	-- 	label = 'Рукоятка #3',
	-- 	weight = 80,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Рукоятка для M4, вариант #3',
	-- 	client = { image = 'm4_grip.png' },
	-- },

	-- ['m4_grip_04'] = {
	-- 	label = 'Рукоятка #4',
	-- 	weight = 80,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Рукоятка для M4, вариант #4',
	-- 	client = { image = 'm4_grip.png' },
	-- },

	-- ['m4_grip_05'] = {
	-- 	label = 'Рукоятка #5',
	-- 	weight = 80,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Рукоятка для M4, вариант #5',
	-- 	client = { image = 'm4_grip.png' },
	-- },

	-- ['m4_suppressor_01'] = {
	-- 	label = 'Глушитель #1',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Глушитель для M4, вариант #1',
	-- 	client = { image = 'm4_suppressor.png' },
	-- },

	-- ['m4_suppressor_02'] = {
	-- 	label = 'Глушитель #2',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Глушитель для M4, вариант #2',
	-- 	client = { image = 'm4_suppressor.png' },
	-- },

	-- ['m4_suppressor_03'] = {
	-- 	label = 'Глушитель #3',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Глушитель для M4, вариант #3',
	-- 	client = { image = 'm4_suppressor.png' },
	-- },

	-- ['m4_suppressor_04'] = {
	-- 	label = 'Глушитель #4',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Глушитель для M4, вариант #4',
	-- 	client = { image = 'm4_suppressor.png' },
	-- },

	-- ['m4_suppressor_05'] = {
	-- 	label = 'Глушитель #5',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Глушитель для M4, вариант #5',
	-- 	client = { image = 'm4_suppressor.png' },
	-- },

	-- ['m4_suppressor_06'] = {
	-- 	label = 'Глушитель #6',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Глушитель для M4, вариант #6',
	-- 	client = { image = 'm4_suppressor.png' },
	-- },

	-- ['m4_suppressor_07'] = {
	-- 	label = 'Глушитель #7',
	-- 	weight = 140,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Глушитель для M4, вариант #7',
	-- 	client = { image = 'm4_suppressor.png' },
	-- },

	-- ['m4_scope_01'] = {
	-- 	label = 'Прицел #1',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #1',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_02'] = {
	-- 	label = 'Прицел #2',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #2',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_03'] = {
	-- 	label = 'Прицел #3',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #3',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_04'] = {
	-- 	label = 'Прицел #4',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #4',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_05'] = {
	-- 	label = 'Прицел #5',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #5',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_06'] = {
	-- 	label = 'Прицел #6',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #6',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_07'] = {
	-- 	label = 'Прицел #7',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #7',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_08'] = {
	-- 	label = 'Прицел #8',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #8',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_scope_09'] = {
	-- 	label = 'Прицел #9',
	-- 	weight = 120,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Прицел для M4, вариант #9',
	-- 	client = { image = 'm4_scope.png' },
	-- },

	-- ['m4_flashlight_01'] = {
	-- 	label = 'Фонарик #1',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #1',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['m4_flashlight_02'] = {
	-- 	label = 'Фонарик #2',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #2',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['m4_flashlight_03'] = {
	-- 	label = 'Фонарик #3',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #3',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['m4_flashlight_04'] = {
	-- 	label = 'Фонарик #4',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #4',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['m4_flashlight_05'] = {
	-- 	label = 'Фонарик #5',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #5',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['m4_flashlight_06'] = {
	-- 	label = 'Фонарик #6',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #6',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['m4_flashlight_07'] = {
	-- 	label = 'Фонарик #7',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #7',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['m4_flashlight_08'] = {
	-- 	label = 'Фонарик #8',
	-- 	weight = 75,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Фонарик для M4, вариант #8',
	-- 	client = { image = 'm4_flashlight.png' },
	-- },

	-- ['weapon_m37'] = {
	-- 	label = 'Itaca M37',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Классическое американское помповое ружьё Ithaca Model 37, 12-ый калибр',
	-- 	client = { image = 'weapon_m37.png' },
	-- },

	-- ['weapon_m37l'] = {
	-- 	label = 'Itaca M37 Long',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Классическое американское помповое ружьё Ithaca Model 37, в длинном исполнении, 12-ый калибр',
	-- 	client = { image = 'weapon_m37.png' },
	-- },

	-- ['weapon_870p'] = {
	-- 	label = 'Remington 870 Police',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Помповое ружьё 12-ого калибра Remington 870 Police',
	-- 	client = { image = 'weapon_870p.png' },
	-- },

	-- ['weapon_m870'] = {
	-- 	label = 'Remington M870',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Помповое ружьё 12-ого калибра Remington M870',
	-- 	client = { image = 'weapon_m870.png' },
	-- },

	-- ['weapon_winchester'] = {
	-- 	label = 'Winchester M1897',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Классическое американское помповое ружьё, 12-ого калибра',
	-- 	client = { image = 'weapon_winch.png' },
	-- },

	-- ['weapon_saiga'] = {
	-- 	label = 'Saiga-12',
	-- 	weight = 3600,
	-- 	stack = false,
	-- 	description = 'Полуавтоматическое ружьё Saiga-12, 12-ого калибра',
	-- 	client = { image = 'weapon_saiga.png' },
	-- },

	-- ['weapon_cg'] = {
	-- 	label = 'Coach Gun',
	-- 	weight = 2100,
	-- 	stack = false,
	-- 	description = 'Классическая двухстволка 12-ого калибра, в представлении не нуждается',
	-- 	client = { image = 'weapon_cg.png' },
	-- },

	-- ['weapon_beanbago'] = {
	-- 	label = 'BeanBag (Оранжевый)',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Нелетальное ружьё с резиновой пулей',
	-- 	client = { image = 'weapon_beanbago.png' },
	-- },

	-- ['weapon_beanbags'] = {
	-- 	label = 'BeanBag (Жёлтый)',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Нелетальное ружьё с резиновой пулей',
	-- 	client = { image = 'weapon_beanbags.png' },
	-- },

	-- ['weapon_beanbag'] = {
	-- 	label = 'BeanBag (Зелёный)',
	-- 	weight = 3500,
	-- 	stack = false,
	-- 	description = 'Нелетальное ружьё с резиновой пулей',
	-- 	client = { image = 'weapon_beanbag.png' },
	-- },

	-- ['saiga_5_clip'] = {
	-- 	label = 'Магазин на 5 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на Saiga-12',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['saiga_10_clip'] = {
	-- 	label = 'Магазин на 10 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Увеличенный магазин на Saiga-12',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['aa12_8_clip'] = {
	-- 	label = 'Магазин на 8 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Штатный магазин на AA-12',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['aa12_20_clip'] = {
	-- 	label = 'Магазин на 20 патрон',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Барабанный магазин на AA-12',
	-- 	client = { image = 'pistol_extendedclip.png' },
	-- },

	-- ['weapon_petrolcan'] = {
	-- 	label = 'Канистра',
	-- 	weight = 7500,
	-- 	stack = false,
	-- 	description = 'Удобная канистра с бензином',
	-- 	client = { image = 'weapon_petrolcan.png' },
	-- },

	-- ['weapon_fireextinguisher'] = {
	-- 	label = 'Огнетушитель',
	-- 	weight = 5000,
	-- 	stack = false,
	-- 	description = 'Обыкновенный огнетушитель',
	-- 	client = { image = 'weapon_fireextinguisher.png' },
	-- },

	-- ['weapon_hazardcan'] = {
	-- 	label = 'Канистра',
	-- 	weight = 7000,
	-- 	stack = false,
	-- 	description = 'Канистра с какой-то жижей',
	-- 	client = { image = 'weapon_hazardcan.png' },
	-- },

	-- ['45_ammo'] = {
	-- 	label = '.45 ACP',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов и ПП',
	-- 	client = { image = '45_ammo.png' },
	-- },

	-- ['25_ammo'] = {
	-- 	label = '.25 ACP',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов и ПП',
	-- 	client = { image = '25_ammo.png' },
	-- },

	-- ['380_ammo'] = {
	-- 	label = '.380 ACP',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов и ПП',
	-- 	client = { image = '25_ammo.png' },
	-- },

	-- ['919_ammo'] = {
	-- 	label = '9x19mm Parabellum',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов и ПП',
	-- 	client = { image = '919_ammo.png' },
	-- },

	-- ['918_ammo'] = {
	-- 	label = '9x18mm PM',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов и ПП',
	-- 	client = { image = '918_ammo.png' },
	-- },

	-- ['57_ammo'] = {
	-- 	label = '5.7x28mm',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов и ПП',
	-- 	client = { image = '57_ammo.png' },
	-- },

	-- ['762_ammo'] = {
	-- 	label = '7.62x39mm',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для винтовок',
	-- 	client = { image = '556_ammo.png' },
	-- },

	-- ['545_ammo'] = {
	-- 	label = '5.45x45mm',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для винтовок',
	-- 	client = { image = '556_ammo.png' },
	-- },

	-- ['556_ammo'] = {
	-- 	label = '5.56x45mm',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для винтовок',
	-- 	client = { image = '556_ammo.png' },
	-- },

	-- ['762r_ammo'] = {
	-- 	label = '7.62x54mm',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для винтовок',
	-- 	client = { image = '556_ammo.png' },
	-- },

	-- ['762x_ammo'] = {
	-- 	label = '7.62x51mm',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для винтовок',
	-- 	client = { image = '556_ammo.png' },
	-- },

	-- ['762o_ammo'] = {
	-- 	label = '.30-06 Springfield',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для винтовок',
	-- 	client = { image = '556_ammo.png' },
	-- },

	-- ['36_ammo'] = {
	-- 	label = '.36',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для раритетных револьверов',
	-- 	client = { image = 'pistol_ammo.png' },
	-- },

	-- ['musket_ammo'] = {
	-- 	label = '.69',
	-- 	weight = 5,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный пуль и пороха для мушкета',
	-- 	client = { image = 'musket_ammo.png' },
	-- },

	-- ['50_ammo'] = {
	-- 	label = '.50 BMG',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для тяжёлых винтовок',
	-- 	client = { image = 'rifle_ammo.png' },
	-- },

	-- ['44_ammo'] = {
	-- 	label = '.44 Mag',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов',
	-- 	client = { image = '500_ammo.png' },
	-- },

	-- ['357_ammo'] = {
	-- 	label = '.357 Mag',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный патрон для пистолетов',
	-- 	client = { image = '500_ammo.png' },
	-- },

	-- ['500_ammo'] = {
	-- 	label = '.500 Mag',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Охотничий револьверный патрон очень крупного калибра',
	-- 	client = { image = '500_ammo.png' },
	-- },

	-- ['12_ammo'] = {
	-- 	label = '12 Cal',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный заряд дроби для ружий',
	-- 	client = { image = '12_ammo.png' },
	-- },

	-- ['12_ammot'] = {
	-- 	label = '12 Cal Резиновый',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный заряд резинового патрона',
	-- 	client = { image = '12t_ammo.png' },
	-- },

	-- ['mgl1_ammo'] = {
	-- 	label = 'M406 40mm',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Пара стандартных фугасных боеприпасов для гранатомёта MGL',
	-- 	client = { image = 'mgl_ammo.png' },
	-- },

	-- ['mgl2_ammo'] = {
	-- 	label = 'M670 40mm',
	-- 	weight = 100,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Пара стандартных дымовых боеприпасов для гранатомёта MGL',
	-- 	client = { image = 'mgl_ammo.png' },
	-- },

	-- ['rpg_ammo'] = {
	-- 	label = 'PG-7B',
	-- 	weight = 1200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный кумулятивный боеприпас для гранатомёта РПГ-7',
	-- 	client = { image = 'rpg_ammo.png' },
	-- },

	-- ['flare_ammo'] = {
	-- 	label = 'Снаряд для ракетницы',
	-- 	weight = 10,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Стандартный сигнальный снаряд 12-ого калибра для ракетницы',
	-- 	client = { image = 'shotgun_ammo.png' },
	-- },

	-- ['45_ammobox'] = {
	-- 	label = 'Коробка .45 ACP',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон калибра .45 ACP в количестве 50-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['25_ammobox'] = {
	-- 	label = 'Коробка .25 ACP',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон калибра .25 ACP в количестве 50-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['380_ammobox'] = {
	-- 	label = 'Коробка .380 ACP',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон калибра .380 ACP в количестве 50-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['919_ammobox'] = {
	-- 	label = 'Коробка 9x19mm Parabellum',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон калибра 9x19mm Parabellum в количестве 50-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['918_ammobox'] = {
	-- 	label = 'Коробка 9x18mm PM',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон калибра 9x18mm в количестве 50-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['57_ammobox'] = {
	-- 	label = 'Коробка 5,7x28mm',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон калибра 5,7x28mm в количестве 50-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['762_ammobox'] = {
	-- 	label = 'Коробка 7.62x39mm',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка боеприпасов калибра 7.62x39mm в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_rifle.png' },
	-- },

	-- ['556_ammobox'] = {
	-- 	label = 'Коробка 5.56x45mm',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон калибра 5.56x45mm в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_rifle.png' },
	-- },

	-- ['762r_ammobox'] = {
	-- 	label = 'Коробка 7.62x54mm',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка боеприпасов калибра 7.62x39mm в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_rifle.png' },
	-- },

	-- ['762x_ammobox'] = {
	-- 	label = 'Коробка 7.62x51mm',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка боеприпасов калибра 7.62x39mm в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_rifle.png' },
	-- },

	-- ['762o_ammobox'] = {
	-- 	label = 'Коробка .30-06 Springfield',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка боеприпасов калибра 7.62x39mm в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_rifle.png' },
	-- },

	-- ['36_ammobox'] = {
	-- 	label = 'Коробка .36',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка боеприпасов калибра 7.62x39mm в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_rifle.png' },
	-- },

	-- ['50_ammobox'] = {
	-- 	label = 'Коробка .50 Magnum',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон крупного калибра .50 Mag в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['44_ammobox'] = {
	-- 	label = 'Коробка .44 Magnum',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон крупного калибра .44 Mag в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['357_ammobox'] = {
	-- 	label = 'Коробка .357 Magnum',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон крупного калибра .357 Mag в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['500_ammobox'] = {
	-- 	label = 'Коробка .500 Magnum',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка патрон крупного калибра .500 Mag в количестве 20-ти штук',
	-- 	client = { image = 'ammobox_pistol.png' },
	-- },

	-- ['12_ammobox'] = {
	-- 	label = 'Коробка 12 Cal',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка дробных боеприпасов 12 калибра в количестве 24-ти штук',
	-- 	client = { image = 'ammobox_shotgun.png' },
	-- },

	-- ['flare_ammobox'] = {
	-- 	label = 'Коробка сигнальных патрон ',
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = 'Коробка сигнальных снарядов 12 калибра в количестве 24-ти штук',
	-- 	client = { image = 'ammobox_shotgun.png' },
	-- },

	['outfitbag2'] = {
		label = 'Сумка с одеждой',
		weight = 1,
		stack = true,
		close = true,
		description = 'Сумка с готовыми наборами одежды',
		client = { image = 'sport_bag.png' },
	},

	['outfitbag1'] = {
		label = 'Сумка с одеждой',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Сумка с наборами одежды',
		client = { image = 'sport_bag.png' },
	},

	['mdtcitation'] = {
		label = 'Справка',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Справка, выданная офицером полиции',
		client = { image = 'citation.png' },
	},

	['payticket'] = {
		label = 'Чек',
		weight = 0,
		stack = true,
		close = false,
		client = { image = 'ticket.png' },
	},

	['stickynote'] = {
		label = 'Заметки',
		weight = 0,
		stack = false,
		close = false,
		description = 'Бумажная записка',
		client = { image = 'stickynote.png' },
	},

	['notepad'] = {
		label = 'Блокнот',
		weight = 10,
		stack = false,
		close = true,
		client = { image = 'notepad.png' },
	},

	['dice'] = {
		label = 'Игральные кости',
		weight = 90,
		stack = true,
		close = true,
		description = 'Игральные кости',
		client = { image = 'dice.png' },
	},

	['id_card'] = {
		label = 'ID',
		weight = 0,
		stack = false,
		close = false,
		description = 'Подлинный документ идентификации гражданина штата',
		client = { image = 'id_card.png' },
	},

	['driver_license'] = {
		label = 'Водительские права',
		weight = 0,
		stack = false,
		close = false,
		description = 'Подлинный документ водительской лицензии штата',
		client = { image = 'driver_license.png' },
	},

	['lawyerpass'] = {
		label = 'Документ адвоката',
		weight = 0,
		stack = false,
		close = false,
		description = 'Подлинный документ, подтверждающий статус адвоката',
		client = { image = 'lawyerpass.png' },
	},

	['weaponlicense'] = {
		label = 'Оружейная лицензия',
		weight = 0,
		stack = false,
		close = true,
		description = 'Подлинный документ, позволяющий гражданину владение и скрытное ношение зарегестрированного огнестрельного оружия, в рамках оружейных законов штата Сан-Андреас',
		client = { image = 'weapon_license.png' },
	},

	['visa'] = {
		label = 'Банковская карта',
		weight = 0,
		stack = false,
		close = false,
		description = 'Банковская карта, принимается в любом банкомате',
		client = { image = 'visacard.png' },
	},

	['mastercard'] = {
		label = 'Банковская карта',
		weight = 0,
		stack = false,
		close = false,
		description = 'Банковская карта, принимается в любом банкомате',
		client = { image = 'mastercard.png' },
	},

	['security_card_01'] = {
		label = 'Карта доступа А',
		weight = 0,
		stack = true,
		close = true,
		description = 'Стандартная магнитная карта доступа',
		client = { image = 'security_card_01.png' },
	},

	['security_card_02'] = {
		label = 'Карта доступа B',
		weight = 0,
		stack = true,
		close = true,
		description = 'Стандартная магнитная карта доступа',
		client = { image = 'security_card_02.png' },
	},

	['huntinglicense'] = {
		label = 'Охотничья лицензия',
		weight = 0,
		stack = false,
		close = true,
		description = 'Подлинный документ, предоставляющий гражданину право на владение зарегестрированными винтовками и ружьями, а также ведение охоты в охотничьих угодьях штата Сан-Андреас',
		client = { image = 'weapon_license.png' },
	},

	['plastic'] = {
		label = 'Пластик',
		weight = 100,
		stack = true,
		close = false,
		description = 'RECYCLE! - Greta Thunberg 2019',
		client = { image = 'plastic.png' },
	},

	['metalscrap'] = {
		label = 'Металлолом',
		weight = 100,
		stack = true,
		close = false,
		description = 'You can probably make something nice out of this',
		client = { image = 'metalscrap.png' },
	},

	['copper'] = {
		label = 'Медь',
		weight = 100,
		stack = true,
		close = false,
		description = 'Nice piece of metal that you can probably use for something',
		client = { image = 'copper.png' },
	},

	['aluminum'] = {
		label = 'Алюминий',
		weight = 100,
		stack = true,
		close = false,
		description = 'Nice piece of metal that you can probably use for something',
		client = { image = 'aluminum.png' },
	},

	['aluminumoxide'] = {
		label = 'Алюминиевый порошок',
		weight = 100,
		stack = true,
		close = false,
		description = 'Some powder to mix with',
		client = { image = 'aluminumoxide.png' },
	},

	['iron'] = {
		label = 'Железо',
		weight = 100,
		stack = true,
		close = false,
		description = 'Handy piece of metal that you can probably use for something',
		client = { image = 'iron.png' },
	},

	['ironoxide'] = {
		label = 'Железный порошок',
		weight = 100,
		stack = true,
		close = false,
		description = 'Some powder to mix with.',
		client = { image = 'ironoxide.png' },
	},

	['steel'] = {
		label = 'Сталь',
		weight = 100,
		stack = true,
		close = false,
		description = 'Nice piece of metal that you can probably use for something',
		client = { image = 'steel.png' },
	},

	['rubber'] = {
		label = 'Резина',
		weight = 100,
		stack = true,
		close = false,
		description = 'Rubber, I believe you can make your own rubber ducky with it :D',
		client = { image = 'rubber.png' },
	},

	['glass'] = {
		label = 'Стекло',
		weight = 100,
		stack = true,
		close = false,
		description = 'It is very fragile, watch out',
		client = { image = 'glass.png' },
	},

	['aceton'] = {
		label = 'Ацетон',
		weight = 20,
		stack = true,
		close = false,
		description = 'Ёмкость, наполненная ацетоном',
		client = { image = 'aceton.png' },
	},

	['acid'] = {
		label = 'Фосфорная кислота',
		weight = 20,
		stack = true,
		close = false,
		description = 'Ёмкость, наполненная фосфорной кислотой',
		client = { image = 'acid.png' },
	},

	['bismuth'] = {
		label = 'Бисмут',
		weight = 20,
		stack = true,
		close = false,
		description = 'Ёмкость, наполненная бисмутом',
		client = { image = 'bismuth.png' },
	},

	['glycol'] = {
		label = 'Пропиленгликоль',
		weight = 20,
		stack = true,
		close = false,
		description = 'Ёмкость, наполненная пропиленгликолем',
		client = { image = 'glycol.png' },
	},

	['sodium'] = {
		label = 'Бензоат натрия',
		weight = 20,
		stack = true,
		close = false,
		description = 'Ёмкость, наполненная бензоатом натрия',
		client = { image = 'sodium.png' },
	},

	['lithium'] = {
		label = 'Литий',
		weight = 20,
		stack = true,
		close = true,
		description = 'Лёгкий щелочной металл, используемый в батареях и различных химических процессах',
		client = { image = 'lithium.png' },
	},

	['peroxide'] = {
		label = 'Пероксид водорода',
		weight = 20,
		stack = true,
		close = false,
		description = 'Ёмкость, наполненная пероксидом водорода, он же - перикись водорода',
		client = { image = 'peroxide.png' },
	},

	['toluene'] = {
		label = 'Толуол',
		weight = 20,
		stack = true,
		close = false,
		description = 'Ёмкость, наполненная толуолом',
		client = { image = 'toluene.png' },
	},

	['chem-case'] = {
		label = 'Химконтейнер',
		weight = 20,
		stack = false,
		close = false,
		description = 'Плотно запечатанный, непрозрачный химконтейнер',
		client = { image = 'chem-case.png' },
	},

	['expl-metalbox'] = {
		label = 'Ящик взрывчатки',
		weight = 20,
		stack = false,
		close = false,
		description = 'Плотно запечатанный, металический защитный ящик, с предупреждением о взрывоопасности',
		client = { image = 'expl-metalbox.png' },
	},

	['expl-woodbox'] = {
		label = 'Деревянный ящик',
		weight = 20,
		stack = false,
		close = false,
		description = 'Плотно запечатанный, деревянный ящик, с предупреждением о взрывоопасности',
		client = { image = 'expl-woodbox.png' },
	},

	['cash-pack'] = {
		label = 'Пачка долларов',
		weight = 10,
		stack = true,
		close = false,
		description = 'Плотный свёрток купюр долларов США',
		client = { image = 'cash-pack.png' },
	},

	['fakedoc-box'] = {
		label = 'Коробка с документами',
		weight = 500,
		stack = false,
		close = false,
		description = 'Коробка, плотно наполненная неизвестными документами',
		client = { image = 'fakedoc-box.png' },
	},

	['fakedoc-lic'] = {
		label = 'Пачка документов',
		weight = 10,
		stack = true,
		close = false,
		description = 'Плотная пачка с неизвестными документами',
		client = { image = 'fakedoc-lic.png' },
	},

	['unknown-cd'] = {
		label = 'CD диск',
		weight = 10,
		stack = true,
		close = false,
		description = 'Неизвестный CD диск в упаковке',
		client = { image = 'unknown-cd.png' },
	},

	['fakedoc-box2'] = {
		label = 'Коробка с документами',
		weight = 500,
		stack = true,
		close = false,
		description = 'Коробка, плотно наполненная неизвестными паспортами',
		client = { image = 'fakedoc-box2.png' },
	},

	['cash-pack2'] = {
		label = 'Пачка долларов',
		weight = 10,
		stack = true,
		close = false,
		description = 'Плотная пачка купюр долларов США',
		client = { image = 'cash-pack2.png' },
	},

	['batt-longlife'] = {
		label = 'Батарейки',
		weight = 20,
		stack = true,
		close = false,
		description = 'Пачка стандартных батареек "Long Life +" ',
		client = { image = 'batt-longlife.png' },
	},

	['batt-supercell'] = {
		label = 'Батарейки',
		weight = 20,
		stack = true,
		close = false,
		description = 'Пачка стандартных батареек "Super Cell" ',
		client = { image = 'batt-supercell.png' },
	},

	['lockpick'] = {
		label = 'Отмычка',
		weight = 100,
		stack = true,
		close = true,
		description = 'Классическая отмычка, выполенная из подручных средств, при неаккуратном использовании достаточно хрупкая',
		client = { image = 'lockpick.png' },
	},

	['advancedlockpick'] = {
		label = 'Универсальная отмычка',
		weight = 500,
		stack = true,
		close = true,
		description = 'Профессиональный набор для взлома замков, лучший инструмент в работе с любой дверью',
		client = { image = 'advancedlockpick.png' },
	},

	['electronickit'] = {
		label = 'Набор для работы с электроникой',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'electronickit.png' },
	},

	['cleaningkit'] = {
		label = 'Комплект для чистки',
		weight = 200,
		stack = true,
		close = true,
		description = 'Полный набор для ручной мойки автомобиля',
		client = { image = 'cleaningkit.png' },
	},

	['tunerlaptop'] = {
		label = 'Настройщик ЭБУ',
		weight = 2000,
		stack = false,
		close = true,
		description = 'Улучшенное система электронного блока управления двигателя',
		client = { image = 'tunerchip.png' },
	},

	['harness'] = {
		label = 'Гоночные ремни',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Четырехточечные ремни безопасности, полностью сохраненящие положения гонщика в гоночном сидении во время сильных перегрузок',
		client = { image = 'harness.png' },
	},

	['jerry_can'] = {
		label = 'Канистра',
		weight = 10000,
		stack = true,
		close = true,
		description = 'Обыкновенная канистра в 20 литров',
		client = { image = 'jerry_can.png' },
	},

	['bandage'] = {
		label = 'Бинты',
		weight = 0,
		stack = true,
		close = true,
		description = 'Свёрток эластичного бинта с физическим раствором, способный останавливать слабые кровотечения',
		client = { image = 'bandage.png' },
	},

	['phone'] = {
		label = 'Телефон',
		weight = 700,
		stack = false,
		close = false,
		description = 'Современный и многофункциональный мобильный телефон компании Celltowa',
		client = { image = 'phone.png' },
	},

	['radio'] = {
		label = 'Рация',
		weight = 300,
		stack = false,
		close = true,
		description = 'Необходимый инструмент для быстрой коммуникации',
		client = { image = 'radio.png' },
	},

	['iphone'] = {
		label = 'iFruit',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Очень дорогой и современный телефон',
		client = { image = 'iphone.png' },
	},

	['laptop'] = {
		label = 'Ноутбук',
		weight = 4000,
		stack = true,
		close = true,
		description = 'Современный и дорогой ноутбук',
		client = { image = 'laptop.png' },
	},

	['radioscanner'] = {
		label = 'Радио сканнер',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Полезный инструмент для прослушки радиочастот',
		client = { image = 'radioscanner.png' },
	},

	['boombox'] = {
		label = 'Бумбокс',
		weight = 5000,
		stack = false,
		close = true,
		description = 'Кассетный бумбокс с двумя динамиками для проигрывания музыки',
		client = { image = 'boombox.png' },
	},

	['diamond_ring'] = {
		label = 'Кольцо с бриллиантом',
		weight = 150,
		stack = true,
		close = true,
		description = 'Кольцо с маленьким бриллиантом',
		client = { image = 'diamond_ring.png' },
	},

	['diamond'] = {
		label = 'Бриллиант',
		weight = 100,
		stack = true,
		close = true,
		description = 'Самый настоящий маленький бриллиант',
		client = { image = 'diamond.png' },
	},

	['goldchain'] = {
		label = 'Золотая цепь',
		weight = 900,
		stack = true,
		close = true,
		description = 'Простейшая золотая цепь',
		client = { image = 'goldchain.png' },
	},

	['10kgoldchain'] = {
		label = 'Золотая цепь 10 каратт',
		weight = 1800,
		stack = true,
		close = true,
		description = 'Здоровая цепь из золота в 10 каратт',
		client = { image = '10kgoldchain.png' },
	},

	['goldbar'] = {
		label = 'Слиток золота',
		weight = 10000,
		stack = true,
		close = true,
		description = 'Тяжеленный слиток настоящего золота',
		client = { image = 'goldbar.png' },
	},

	['armor'] = {
		label = 'Лёгкий бронежилет',
		weight = 500,
		stack = true,
		close = true,
		description = 'Прочный кевларовый бронежилет, спасает от пистолетных пуль и ножевых ранений',
		client = { image = 'armor.png' },
	},

	['heavyarmor'] = {
		label = 'Тяжёлый бронежилет',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Прочный бронежилет 5 класса, спасает от винтовочных пуль',
		client = { image = 'armor.png' },
	},

	['police_stormram'] = {
		label = 'Таран',
		weight = 18000,
		stack = false,
		close = true,
		description = 'Хорошая вещь что бы пробираться в помещение с преступниками',
		client = { image = 'police_stormram.png' },
	},

	['empty_evidence_bag'] = {
		label = 'Пакет для улик',
		weight = 0,
		stack = true,
		close = false,
		description = 'Закрывающийся пакетик, предназначенный для сбора улик',
		client = { image = 'evidence.png' },
	},

	['filled_evidence_bag'] = {
		label = 'Улика',
		weight = 200,
		stack = false,
		close = false,
		description = 'Закрытый пакетик с каким-то содержимым',
		client = { image = 'evidence.png' },
	},

	['lspdshield'] = {
		label = 'Полицейский щит',
		weight = 13000,
		stack = false,
		close = true,
		description = 'Стальной полицейский щит, предназначенный что-бы штурмовать наркопритоны',
		client = { image = 'shieldp.png' },
	},

	['lssdshield'] = {
		label = 'Полицейский щит',
		weight = 13000,
		stack = false,
		close = true,
		description = 'Стальной полицейский щит, предназначенный что-бы штурмовать наркопритоны',
		client = { image = 'shieldp.png' },
	},

	['spikestrip'] = {
		label = 'Шипы',
		weight = 0,
		stack = false,
		close = true,
		description = 'Шипы.',
		client = { image = 'spikestrip.png' },
	},

	['diving_gear'] = {
		label = 'Акваланг',
		weight = 18000,
		stack = false,
		close = true,
		description = 'Готовое снаряжение для погружения под воду, баллон с воздухом и дыхательная маска',
		client = { image = 'diving_gear.png' },
	},

	['casinochips'] = {
		label = 'Фишки',
		weight = 0,
		stack = true,
		close = false,
		description = 'Стандартные игральные фишки казино',
		client = { image = 'casinochips.png' },
	},

	['casinochips2'] = {
		label = 'Фишки',
		weight = 0,
		stack = true,
		close = false,
		description = 'Игральные фишки казино, исполненные в ярком китайском стиле',
		client = { image = 'casinochips2.png' },
	},

	['moneybag'] = {
		label = 'Мешок с деньгами',
		weight = 2000,
		stack = false,
		close = true,
		description = 'Мешок, наполненные долларами США',
		client = { image = 'moneybag.png' },
	},

	['parachute'] = {
		label = 'Парашут',
		weight = 15000,
		stack = false,
		close = true,
		description = 'Рюкзак с аккуратно укомплектованным парашутом, готов к использованию',
		client = { image = 'parachute.png' },
	},

	['binoculars'] = {
		label = 'Бинокль',
		weight = 600,
		stack = true,
		close = true,
		description = 'Классический оптический бинокль для двух зрительных труб',
		client = { image = 'binoculars.png' },
	},

	['snowball'] = {
		label = 'Снежок',
		weight = 0,
		stack = true,
		close = true,
		description = 'Шарик снега',
		client = { image = 'snowball.png' },
	},

	['certificate'] = {
		label = 'Сертификат',
		weight = 0,
		stack = true,
		close = true,
		description = 'Подлинный сертификат',
		client = { image = 'certificate.png' },
	},

	['markedbills'] = {
		label = 'Сумка меченых долларов',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Вечнозелёный баксы США, пропитанные специальным раствором, не представляют ценности',
		client = { image = 'markedbills.png' },
	},

	['labkey'] = {
		label = 'Ключ-карта',
		weight = 500,
		stack = false,
		close = true,
		description = 'Пластиковая ключ-карта сотрудника',
		client = { image = 'labkey.png' },
	},

	['printerdocument'] = {
		label = 'Документ',
		weight = 500,
		stack = false,
		close = true,
		description = 'Какой-то документ, написанный юридическим языком',
		client = { image = 'printerdocument.png' },
	},

	['cagoule'] = {
		label = 'Мешок',
		weight = 100,
		stack = true,
		close = true,
		description = 'Обыкновенный пустой мешок',
		client = { image = 'moneybag.png' },
	},

	['cash'] = {
		label = 'Доллар',
		weight = 0,
		stack = true,
		close = true,
		description = 'Вечнозеленые баксы США',
		client = { image = 'cash.png' },
	},

	['cash-eu'] = {
		label = 'Евро',
		weight = 0,
		stack = true,
		close = true,
		description = 'Банкноты евросоюза',
		client = { image = 'cash-eu.png' },
	},

	['cash-mex'] = {
		label = 'Мексиканский Песо',
		weight = 0,
		stack = true,
		close = true,
		description = 'Государственная валюта Мексики',
		client = { image = 'cash-mex.png' },
	},

	['cash-ru'] = {
		label = 'Российский Рубль',
		weight = 0,
		stack = true,
		close = true,
		description = 'Валюта прямиком из Российской Федерации',
		client = { image = 'cash-ru.png' },
	},

	['cash-bag'] = {
		label = 'Багамский Доллар',
		weight = 0,
		stack = true,
		close = true,
		description = 'Государственная валюта Багамских островов',
		client = { image = 'cash-bag.png' },
	},

	['cash-yn'] = {
		label = 'Японская йена',
		weight = 0,
		stack = true,
		close = true,
		description = 'Национальная валюта Японии',
		client = { image = 'cash-yn.png' },
	},

	['cash-un'] = {
		label = 'Китайский юань',
		weight = 0,
		stack = true,
		close = true,
		description = 'Национальная валюта КНР',
		client = { image = 'cash-un.png' },
	},

	['camera'] = {
		label = 'Фотоаппарат',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Обычная фотокамера. Запечатлите важный для себя момент',
		client = { image = 'camera.png' },
	},

	['photo'] = {
		label = 'Фотография',
		weight = 500,
		stack = false,
		close = true,
		description = 'Распечатанная фотография. Подарите близкому человеку или сохраните для себя, как воспоминание о важном моменте в жизни ',
		client = { image = 'photo.png' },
	},

	['apple'] = {
		label = 'Яблоко',
		weight = 500,
		stack = true,
		close = true,
		description = 'Вкусное, наливное яблоко',
		client = { image = 'apple.png' },
	},

	['appledrink'] = {
		label = 'Яблочный сок',
		weight = 500,
		stack = true,
		close = true,
		description = 'Натуральный яблочный сок из свежих яблок',
		client = { image = 'appledrink.png' },
	},

	['applecocktail'] = {
		label = 'Яблочный коктейль',
		weight = 500,
		stack = true,
		close = true,
		description = 'Освежающий яблочный коктейль, богатый витаминами и натуральными вкусами',
		client = { image = 'applecocktail.png' },
	},

	['banana'] = {
		label = 'Банан',
		weight = 500,
		stack = true,
		close = true,
		description = 'Обыкновенный банан. Сладкий, питательный, богат калием',
		client = { image = 'banana.png' },
	},

	['bananadrink'] = {
		label = 'Бананный коктейль',
		weight = 500,
		stack = true,
		close = true,
		description = 'Сладкий банановый коктейль с мягким вкусом.',
		client = { image = 'bananadrink.png' },
	},

	['beer'] = {
		label = 'Пиво',
		weight = 500,
		stack = true,
		close = true,
		description = 'Легкое, освежающее пиво, с мягким солодовым вкусом',
		client = { image = 'beer.png' },
	},

	['brandy'] = {
		label = 'Бренди',
		weight = 500,
		stack = true,
		close = true,
		description = 'Крепкий, ароматный брэнди, с нотками фруктов',
		client = { image = 'brandy.png' },
	},

	['hulkcocktail'] = {
		label = 'Халк коктейль',
		weight = 500,
		stack = true,
		close = true,
		description = 'Коктейль зеленого цвета, с ярким цитрусовым вкусом',
		client = { image = 'hulkcocktail.png' },
	},

	['ice'] = {
		label = 'Лёд',
		weight = 500,
		stack = true,
		close = true,
		description = 'Обыкновенный лёд',
		client = { image = 'ice.png' },
	},

	['morangos'] = {
		label = 'Клубника',
		weight = 500,
		stack = true,
		close = true,
		description = 'Вкусная клубника, прямиком из Мексики',
		client = { image = 'morangos.png' },
	},

	['strawberriesdrink'] = {
		label = 'Клубничнный коктейль',
		weight = 500,
		stack = true,
		close = true,
		description = 'Изысканный клубничный коктейль с бархатистым послевкусием',
		client = { image = 'strawberriesdrink.png' },
	},

	['orange'] = {
		label = 'Апельсин',
		weight = 20,
		stack = true,
		close = false,
		description = 'Обыкновенный апельсин',
		client = { image = 'orange.png' },
	},

	['lime'] = {
		label = 'Лайм',
		weight = 500,
		stack = true,
		close = true,
		description = 'Кислый, спелый лайм из Индонезии',
		client = { image = 'lime.png' },
	},

	['orangedrink'] = {
		label = 'Апельсиновый сок (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Освежающий напиток с ярким цитрусовым вкусом, богатый витамином С, калием, фолиевой кислотой и антиоксидантами',
		client = { image = 'orangedrink.png' },
	},

	['vodka'] = {
		label = 'Водка',
		weight = 500,
		stack = true,
		close = true,
		description = 'Водка, прямиком из России',
		client = { image = 'vodka.png' },
	},

	['vodkacocktail'] = {
		label = 'Коктейль с водкой',
		weight = 500,
		stack = true,
		close = true,
		description = 'Крепкий коктейль из водки, с нотками хлеба, в классическом исполнения',
		client = { image = 'vodkacocktail.png' },
	},

	['vanillamenu'] = {
		label = 'Меню',
		weight = 500,
		stack = true,
		close = true,
		description = 'Меню заведения',
		client = { image = 'vanillamenu.png' },
	},

	['goldstrike'] = {
		label = 'Голд страйк',
		weight = 500,
		stack = true,
		close = true,
		description = 'Элегантный коктейль с нотками цитруса, золотистым оттенком',
		client = { image = 'goldstrike.png' },
	},

	['absinthe'] = {
		label = 'Абсент',
		weight = 500,
		stack = true,
		close = true,
		description = 'Фирменный абсент, анисовый, крепкий, с нотками трав',
		client = { image = 'absinthe.png' },
	},

	['jackdaniels'] = {
		label = 'Джек Дэниелс',
		weight = 500,
		stack = true,
		close = true,
		description = 'Классический виски, с нотками карамели и дуба, мягкий, с дымным послевкусием',
		client = { image = 'jackdaniels.png' },
	},

	['champagne'] = {
		label = 'Шампанское',
		weight = 500,
		stack = true,
		close = true,
		description = 'Классическое, игристое шампанское',
		client = { image = 'champagne.png' },
	},

	['tequilagold'] = {
		label = 'Текилла-голд',
		weight = 500,
		stack = true,
		close = true,
		description = 'Текила золотистого цвета, с нотками ванили и дуба',
		client = { image = 'tequilagold.png' },
	},

	['martinibianco'] = {
		label = 'Мартини Bianko',
		weight = 500,
		stack = true,
		close = true,
		description = 'Сладкий Мартини, с нотками ванили, мягкий, с лёгким цветочным ароматом',
		client = { image = 'martinibianco.png' },
	},

	['martiniextradry'] = {
		label = 'Мартини Экстрадри',
		weight = 500,
		stack = true,
		close = true,
		description = 'Сухой Мартини, с нотками трав, лёгкий',
		client = { image = 'martiniextradry.png' },
	},

	['martinirosato'] = {
		label = 'Мартини Rosato',
		weight = 500,
		stack = true,
		close = true,
		description = 'Сладкий Мартини, с нотками ягод, лёгкий, с цветочным ароматом',
		client = { image = 'martinirosato.png' },
	},

	['martinirosso'] = {
		label = 'Мартини Rosso',
		weight = 500,
		stack = true,
		close = true,
		description = 'Мартини, с нотками специй и трав, насыщенный, с бархатным послевкусием',
		client = { image = 'martinirosso.png' },
	},

	['bombaysaphire'] = {
		label = 'Бомбэй Сапфир',
		weight = 500,
		stack = true,
		close = true,
		description = 'Джин Бомбэй Сапфир, лёгкий, с нотками цитруса и лакрицы, мягкий',
		client = { image = 'bombaysaphire.png' },
	},

	['ciroc'] = {
		label = 'Водка Ciroc',
		weight = 500,
		stack = true,
		close = true,
		description = 'Мягкая водка, с нотками цитруса, изготовлена из французского винограда, премиальная.',
		client = { image = 'ciroc.png' },
	},

	['cirocapple'] = {
		label = 'Водка Яблочный Ciroc',
		weight = 500,
		stack = true,
		close = true,
		description = 'Водка, с яркими нотками зелёного яблока, с лёгким, сладким послевкусием',
		client = { image = 'cirocapple.png' },
	},

	['cirocred'] = {
		label = 'Водка Ciroc (красный)',
		weight = 500,
		stack = true,
		close = true,
		description = 'Водка, с натуральными ягодным вкусом',
		client = { image = 'cirocred.png' },
	},

	['eristoffblack'] = {
		label = 'Эристофф чёрный',
		weight = 500,
		stack = true,
		close = true,
		description = 'Водка премиум-класса с ароматом лесных ягод: малина и черная смородина',
		client = { image = 'eristoffblack.png' },
	},

	['frutosvermelhos'] = {
		label = 'Вишня',
		weight = 500,
		stack = true,
		close = true,
		description = 'Red fruits',
		client = { image = 'frutosvermelhos.png' },
	},

	['lima'] = {
		label = 'Лима',
		weight = 500,
		stack = true,
		close = true,
		description = 'Злаковый напиток без холестерина, сахара и лактозы, идеален для вегетарианцев',
		client = { image = 'lima.png' },
	},

	['cocacola'] = {
		label = 'Кока-Кола',
		weight = 500,
		stack = true,
		close = true,
		description = 'Lime',
		client = { image = 'cocacola.png' },
	},

	['chaser'] = {
		label = 'Шоколад Chaser',
		weight = 70,
		stack = true,
		close = true,
		description = 'Шоколад Chaser — сладкое лакомство для любителей шоколада',
		client = { image = 'chaser.png' },
	},

	['meteorite'] = {
		label = 'Шоколад Meteorite',
		weight = 80,
		stack = true,
		close = true,
		description = 'Шоколад Meteorite — уникальный вкус, как будто с космоса',
		client = { image = 'meteorite.png' },
	},

	['hotdog'] = {
		label = 'Хотдог',
		weight = 120,
		stack = true,
		close = true,
		description = 'Сочный хотдог — идеальный перекус на ходу',
		client = { image = 'hotdog.png' },
	},

	['taco'] = {
		label = 'Тако',
		weight = 100,
		stack = true,
		close = true,
		description = 'Вкусное тако с разнообразными начинками',
		client = { image = 'taco.png' },
	},

	['coffe'] = {
		label = 'Кофе',
		weight = 330,
		stack = true,
		close = true,
		description = 'Ароматный кофе, чтобы взбодриться в любое время дня',
		client = { image = 'coffe.png' },
	},

	['shot_glass'] = {
		label = 'Шот',
		weight = 50,
		stack = true,
		close = true,
		description = 'Маленький стаканчик для крепких напитков',
		client = { image = 'shot_glass.png' },
	},

	['whiskey_glass'] = {
		label = 'Рюмка',
		weight = 200,
		stack = true,
		close = true,
		description = 'Стакан для виски, идеально подходит для наслаждения напитком',
		client = { image = 'whiskey_glass.png' },
	},

	['wine_glass'] = {
		label = 'Бокал',
		weight = 150,
		stack = true,
		close = true,
		description = 'Бокал для вина, чтобы насладиться его вкусом и ароматом',
		client = { image = 'wine_glass.png' },
	},

	['flute_glass'] = {
		label = 'Фужер',
		weight = 150,
		stack = true,
		close = true,
		description = 'Высокий узкий бокал для шампанского, чтобы подчеркнуть его игристый характер',
		client = { image = 'flute_glass.png' },
	},

	['tall_glass'] = {
		label = 'Стеклянный стакан',
		weight = 200,
		stack = true,
		close = true,
		description = 'Высокий стеклянный стакан, подходящий для различных напитков',
		client = { image = 'tall_glass.png' },
	},

	['plastic_cup'] = {
		label = 'Пластиковый стакан',
		weight = 30,
		stack = true,
		close = true,
		description = 'Красный пластиковый стакан, удобный для повседневного использования',
		client = { image = 'cup_red.png' },
	},

	['plastic_cup2'] = {
		label = 'Пластиковый стакан',
		weight = 30,
		stack = true,
		close = true,
		description = 'Синий пластиковый стакан, подходящий для любых напитков',
		client = { image = 'cup_blue.png' },
	},

	['redw'] = {
		label = 'Пачка сигарет',
		weight = 200,
		stack = true,
		close = true,
		description = 'Пачка самых популярных сигарет в Америке - Redwood',
		client = { image = 'redw.png' },
	},

	['cubancigar'] = {
		label = 'Сигара',
		weight = 30,
		stack = true,
		close = true,
		description = 'Солидная кубинская сигара',
		client = { image = 'cubancigar.png' },
	},

	['redwcig'] = {
		label = 'Сигарета',
		weight = 10,
		stack = true,
		close = true,
		description = 'Классическая сигарета Redwood',
		client = { image = 'redwcig.png' },
	},

	['bong'] = {
		label = 'Бонг',
		weight = 400,
		stack = true,
		close = true,
		description = 'Классический бонг',
		client = { image = 'bong.png' },
	},

	['ocb_paper'] = {
		label = 'Сигаретная бумага',
		weight = 5,
		stack = true,
		close = true,
		description = 'Обыкновенная дешёвая сигаретная бумага',
		client = { image = 'ocb_paper.png' },
	},

	['lighter'] = {
		label = 'Зажигалка',
		weight = 40,
		stack = true,
		close = true,
		description = 'Стандартная бензиновая зажигалка',
		client = { image = 'lighter.png' },
	},

	['lighter2'] = {
		label = 'Зажигалка',
		weight = 40,
		stack = true,
		close = true,
		description = 'Стандартная бензиновая зажигалка',
		client = { image = 'lighter2.png' },
	},

	['lighter3'] = {
		label = 'Зажигалка',
		weight = 40,
		stack = true,
		close = true,
		description = 'Стандартная бензиновая зажигалка',
		client = { image = 'lighter3.png' },
	},

	['e-cola'] = {
		label = 'E-Cola',
		weight = 330,
		stack = true,
		close = true,
		description = 'Сладкая газировка, известная по всему миру кола, в маленькой банке',
		client = { image = 'ecola-s.png' },
	},

	['sprunk'] = {
		label = 'Sprunk',
		weight = 330,
		stack = true,
		close = true,
		description = 'Сладкая газировка со вкусом лимона и лайма в маленькой банке',
		client = { image = 'sprunk-s.png' },
	},

	['orang'] = {
		label = 'Orang-O-Tang',
		weight = 330,
		stack = true,
		close = true,
		description = 'Сладкая газировка со вкусом апельсина в маленькой банке',
		client = { image = 'orang-s.png' },
	},

	['flow'] = {
		label = 'Flow',
		weight = 500,
		stack = true,
		close = true,
		description = 'Премиальный бренд воды для активных людей',
		client = { image = 'flow-w.png' },
	},

	['raine'] = {
		label = 'Raine',
		weight = 500,
		stack = true,
		close = true,
		description = 'Популярнейший бренд питьевой воды в Америке',
		client = { image = 'raine-w.png' },
	},

	['e-cola-t'] = {
		label = 'E-Cola Tonic',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бодрящий, горько-кислый тоник от газированного магната',
		client = { image = 'ecola-tonic.png' },
	},

	['energy_drink'] = {
		label = 'Junk',
		weight = 500,
		stack = true,
		close = true,
		description = 'Популярный энергетический напиток, который взбодрит любого американца, словно доза кокаина',
		client = { image = 'energy_drink.png' },
	},

	['cerv-beer'] = {
		label = 'Cerveza Barracho',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка известного мексиканского светлого лагера',
		client = { image = 'cerv-b.png' },
	},

	['piss-beer'] = {
		label = 'Pißwasser',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка популярного американского светлого лагера',
		client = { image = 'piss-b.png' },
	},

	['pride-beer'] = {
		label = 'Pride Brew',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка ямайского светлого лагера',
		client = { image = 'pride-b.png' },
	},

	['am-beer'] = {
		label = 'A.M.',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка японского светлого лагера',
		client = { image = 'am-b.png' },
	},

	['blar-beer'] = {
		label = 'Blarneys Stout',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка ирландского тёмного лагера',
		client = { image = 'blar-b.png' },
	},

	['dusch-beer'] = {
		label = 'Dusche Gold',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка немецкого светлого лагера',
		client = { image = 'dusch-b.png' },
	},

	['jakey-beer'] = {
		label = 'Jakeys',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка австралийского светлого лагера',
		client = { image = 'jakey-b.png' },
	},

	['logg-beer'] = {
		label = 'Logger',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка светлого лагера с Среднего Запада',
		client = { image = 'logg-b.png' },
	},

	['patr-beer'] = {
		label = 'Patriot',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка светлого лагера с Восточного побережья',
		client = { image = 'patr-b.png' },
	},

	['stron-beer'] = {
		label = 'Stronzo',
		weight = 500,
		stack = true,
		close = true,
		description = 'Бутылка итальянского светлого лагера',
		client = { image = 'stron-b.png' },
	},

	['mount-wh'] = {
		label = 'Виски The Mount',
		weight = 550,
		stack = true,
		close = true,
		description = 'Классический теннессийский виски',
		client = { image = 'mount-wh.png' },
	},

	['rich-wh'] = {
		label = 'Виски Richard',
		weight = 650,
		stack = true,
		close = true,
		description = 'Классический виски из Кентукки',
		client = { image = 'rich-wh.png' },
	},

	['macb-wh'] = {
		label = 'Виски Macbeth',
		weight = 750,
		stack = true,
		close = true,
		description = 'Классический шотландский виски',
		client = { image = 'macb-wh.png' },
	},

	['nogo-v'] = {
		label = 'Водка Nogo',
		weight = 650,
		stack = true,
		close = true,
		description = 'Популярнейшая водка из Америки для американцев',
		client = { image = 'nogo-v.png' },
	},

	['cher-v'] = {
		label = 'Водка Cherenkov',
		weight = 650,
		stack = true,
		close = true,
		description = 'Известная первоклассная водка',
		client = { image = 'cher-v.png' },
	},

	['cher-v2'] = {
		label = 'Водка Cherenkov',
		weight = 650,
		stack = true,
		close = true,
		description = 'Известная первоклассная водка',
		client = { image = 'cher-v2.png' },
	},

	['cher-v3'] = {
		label = 'Водка Cherenkov',
		weight = 650,
		stack = true,
		close = true,
		description = 'Известная первоклассная водка',
		client = { image = 'cher-v3.png' },
	},

	['cher-v4'] = {
		label = 'Водка Cherenkov',
		weight = 650,
		stack = true,
		close = true,
		description = 'Известная первоклассная водка',
		client = { image = 'cher-v4.png' },
	},

	['ragga-rum'] = {
		label = 'Ром Ragga Rum',
		weight = 600,
		stack = true,
		close = true,
		description = 'Бутылка известного ямайского рома',
		client = { image = 'ragga-r.png' },
	},

	['ragga-rum-coctail'] = {
		label = 'Ром Ragga Rum (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Мини-бутылка известного ямайского рома. Обычно используется для приготовления коктейлей',
		client = { image = 'ragga-r.png' },
	},

	['nogo-v-coctail'] = {
		label = 'Водка Nogo (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Мини-бутылка популярнейшей водки из Америки',
		client = { image = 'nogo-v.png' },
	},

	['pissh-liquor'] = {
		label = 'Ликер (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Мини-бутылка настоящего, классического ликера',
		client = { image = 'pissh-liquor.png' },
	},

	['cranberry-juice'] = {
		label = 'Клюквенный сок (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Кислый, освежающий напиток, богатый витамином C, антиоксидантами, полезен для иммунитета и мочевыводящих путей',
		client = { image = 'juice-pineapple.png' },
	},

	['bourg-con'] = {
		label = 'Коньяк Bourgeoix',
		weight = 650,
		stack = true,
		close = true,
		description = 'Бутылка известного коньяка',
		client = { image = 'bourg-c.png' },
	},

	['gold-t'] = {
		label = 'Текилла Gold',
		weight = 700,
		stack = true,
		close = true,
		description = 'Бутылка модной текилы',
		client = { image = 'gold-t.png' },
	},

	['cardi-br'] = {
		label = 'Бренди Cardiaque',
		weight = 700,
		stack = true,
		close = true,
		description = 'Классический французский бренди',
		client = { image = 'cardi-br.png' },
	},

	['bleu-ch'] = {
		label = 'Шампанское Blêuterd',
		weight = 750,
		stack = true,
		close = true,
		description = 'Известнейшее французское шампанское',
		client = { image = 'bleuterd.png' },
	},

	['bleu-ch2'] = {
		label = 'Шампанское Blêuterd Silver',
		weight = 750,
		stack = true,
		close = true,
		description = 'Известнейшее французское шампанское серебрянного издания',
		client = { image = 'bleu-silv-ch.png' },
	},

	['bleu-ch3'] = {
		label = 'Шампанское Blêuterd Gold',
		weight = 750,
		stack = true,
		close = true,
		description = 'Известнейшее французское шампанское золотого издания',
		client = { image = 'bleu-gold-ch.png' },
	},

	['bleu-ch4'] = {
		label = 'Шампанское Blêuterd Diamond',
		weight = 750,
		stack = true,
		close = true,
		description = 'Известнейшее французское шампанское, эксклюзивного бриллиантового издания, прославившееся своей огромной ценой',
		client = { image = 'bleu-plat-ch.png' },
	},

	['vine-wi'] = {
		label = 'Вино Vinewood White',
		weight = 600,
		stack = true,
		close = true,
		description = 'Классический белое вино Вайнвуд',
		client = { image = 'vine-wi.png' },
	},

	['vine-red-wi'] = {
		label = 'Вино Vinewood Red',
		weight = 600,
		stack = true,
		close = true,
		description = 'Классическое красное вино Вайнвуд',
		client = { image = 'vine-red-wi.png' },
	},

	['delp-wi'] = {
		label = 'Вино Costa Del Perro',
		weight = 600,
		stack = true,
		close = true,
		description = 'Классическое белое вино Дель-Пьерро',
		client = { image = 'delp-wi.png' },
	},

	['rock-wi'] = {
		label = 'Вино Rockford White',
		weight = 600,
		stack = true,
		close = true,
		description = 'Классическое белое вино Рокфорд',
		client = { image = 'rock-wi.png' },
	},

	['rock-red-wi'] = {
		label = 'Вино Rockford Red',
		weight = 600,
		stack = true,
		close = true,
		description = 'Классическое красное вино Рокфорд',
		client = { image = 'rock-red-wi.png' },
	},

	['cerv-6pack'] = {
		label = 'Упаковка Cerveza',
		weight = 3000,
		stack = true,
		close = true,
		description = 'Пачка из 6 бутылок пива Cerveza Barracho',
		client = { image = 'cerv-6.png' },
	},

	['pride-6pack'] = {
		label = 'Упаковка Pride Brew',
		weight = 3000,
		stack = true,
		close = true,
		description = 'Пачка из 6 бутылок пива Pride Brew',
		client = { image = 'pride-6.png' },
	},

	['am-6pack'] = {
		label = 'Упаковка A.M.',
		weight = 3000,
		stack = true,
		close = true,
		description = 'Пачка из 6 бутылок пива A.M.',
		client = { image = 'am-6.png' },
	},

	['dusch-6pack'] = {
		label = 'Упаковка Dusche Gold',
		weight = 3000,
		stack = true,
		close = true,
		description = 'Пачка из 6 бутылок пива Dusche Gold',
		client = { image = 'dusch-6.png' },
	},

	['patr-12pack'] = {
		label = 'Упаковка Patriot',
		weight = 6000,
		stack = true,
		close = true,
		description = 'Пачка из 12 бутылок пива Patriot',
		client = { image = 'patr-12.png' },
	},

	['logg-12pack'] = {
		label = 'Упаковка Logger',
		weight = 6000,
		stack = true,
		close = true,
		description = 'Пачка из 12 бутылок пива Logger',
		client = { image = 'logg-12.png' },
	},

	['piss-12pack'] = {
		label = 'Упаковка Pißwasser',
		weight = 6000,
		stack = true,
		close = true,
		description = 'Пачка из 12 бутылок пива Pißwasser',
		client = { image = 'piss-12.png' },
	},

	['jakey-12pack'] = {
		label = 'Упаковка Jakey Lager',
		weight = 6000,
		stack = true,
		close = true,
		description = 'Пачка из 12 бутылок пива Jakey Lager',
		client = { image = 'jakey-12.png' },
	},

	['nn-burger-b'] = {
		label = 'Большой Бургер',
		weight = 210,
		stack = true,
		close = true,
		description = 'Большой бургер из пары говяжьих котлет, салата и соусов',
		client = { image = 'nn-burger-b.png' },
	},

	['nn-burger-s'] = {
		label = 'Бургер',
		weight = 210,
		stack = true,
		close = true,
		description = 'Классический бургер из говяжей котлетки, листа салата и кетчупа',
		client = { image = 'nn-burger-s.png' },
	},

	['nn-coffee1'] = {
		label = 'Кофе Капучино',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный капучино из ресторана быстрого питания',
		client = { image = 'nn-coffee.png' },
	},

	['nn-coffee2'] = {
		label = 'Кофе Американо',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный американо из ресторана быстрого питания',
		client = { image = 'nn-coffee.png' },
	},

	['nn-coffee3'] = {
		label = 'Кофе Латте',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный латте из ресторана быстрого питания',
		client = { image = 'nn-coffee.png' },
	},

	['nn-fries'] = {
		label = 'Картофель Фри',
		weight = 330,
		stack = true,
		close = true,
		description = 'Классический обжаренный картофель из ресторана быстрого питания',
		client = { image = 'nn-fries.png' },
	},

	['nn-longer'] = {
		label = 'Хот-Дог',
		weight = 110,
		stack = true,
		close = true,
		description = 'Классический хот-дог с сосиской на грилле и соусами, из ресторана быстрого питания',
		client = { image = 'nn-longer.png' },
	},

	['nn-soda1'] = {
		label = 'Стакан E-Cola',
		weight = 500,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка E-Cola, из ресторана быстрого питания',
		client = { image = 'nn-soda.png' },
	},

	['nn-soda2'] = {
		label = 'Стакан Sprunk',
		weight = 500,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка Sprunk, из ресторана быстрого питания',
		client = { image = 'nn-soda.png' },
	},

	['bs-burger-b'] = {
		label = 'Большой Бургер',
		weight = 210,
		stack = true,
		close = true,
		description = 'Большой бургер из пары говяжьих котлет, салата и соусов',
		client = { image = 'bs-burger-b.png' },
	},

	['bs-burger-s'] = {
		label = 'Бургер',
		weight = 210,
		stack = true,
		close = true,
		description = 'Классический бургер из говяжей котлетки, листа салата и кетчупа',
		client = { image = 'bs-burger-s.png' },
	},

	['bs-coffee1'] = {
		label = 'Кофе Капучино',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный капучино из ресторана Burger Shot',
		client = { image = 'bs-coffee.png' },
	},

	['bs-coffee2'] = {
		label = 'Кофе Американо',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный американо из ресторана Burger Shot',
		client = { image = 'bs-coffee.png' },
	},

	['bs-coffee3'] = {
		label = 'Кофе Латте',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный латте из ресторана Burger Shot',
		client = { image = 'bs-coffee.png' },
	},

	['bs-fries'] = {
		label = 'Картофель Фри',
		weight = 300,
		stack = true,
		close = true,
		description = 'Классический обжаренный картофель из ресторана Burger Shot',
		client = { image = 'bs-fries.png' },
	},

	['bs-longer'] = {
		label = 'Хот-Дог',
		weight = 110,
		stack = true,
		close = true,
		description = 'Классический хот-дог с сосиской на грилле и соусами, из ресторана Burger Shot',
		client = { image = 'bs-longer.png' },
	},

	['bs-soda1'] = {
		label = 'Стакан E-Cola',
		weight = 500,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка E-Cola, из ресторана Burger Shot',
		client = { image = 'bs-soda.png' },
	},

	['bs-soda2'] = {
		label = 'Стакан Sprunk',
		weight = 500,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка Sprunk, из ресторана Burger Shot',
		client = { image = 'bs-soda.png' },
	},

	['bs-bun'] = {
		label = 'Булочка',
		weight = 125,
		stack = true,
		close = true,
		description = 'Мягкая булочка',
		client = { image = 'bs_bun.png' },
	},

	['bs-meat'] = {
		label = 'Жаренная котлета',
		weight = 125,
		stack = true,
		close = true,
		description = 'Жаренная котлета из мраморной говядины',
		client = { image = 'bs_patty.png' },
	},

	['bs-lettuce'] = {
		label = 'Салат',
		weight = 125,
		stack = true,
		close = true,
		description = 'Лист салата',
		client = { image = 'bs_lettuce.png' },
	},

	['bs-tomato'] = {
		label = 'Помидоры',
		weight = 125,
		stack = true,
		close = true,
		description = 'Свежие помидоры',
		client = { image = 'bs_tomato.png' },
	},

	['bs-raw'] = {
		label = 'Сырая котлета',
		weight = 125,
		stack = true,
		close = true,
		description = 'Сырая котлета из мраморной говядины',
		client = { image = 'bs_patty_raw.png' },
	},

	['bs-potato'] = {
		label = 'Мешок картошки',
		weight = 1500,
		stack = true,
		close = true,
		description = 'Мешок очищенной картошки',
		client = { image = 'bs_potato.png' },
	},

	['cb-burger-b'] = {
		label = 'Большой Бургер',
		weight = 210,
		stack = true,
		close = true,
		description = 'Большой бургер из пары куриных котлет, салата и соусов',
		client = { image = 'cb-burger-b.png' },
	},

	['cb-burger-s'] = {
		label = 'Бургер',
		weight = 210,
		stack = true,
		close = true,
		description = 'Классический бургер из куриной котлетки, листа салата и кетчупа',
		client = { image = 'cb-burger-s.png' },
	},

	['cb-coffee1'] = {
		label = 'Кофе Капучино',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный капучино из ресторана Cluckin Bell',
		client = { image = 'cb-coffee.png' },
	},

	['cb-coffee2'] = {
		label = 'Кофе Американо',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный американо из ресторана Cluckin Bell',
		client = { image = 'cb-coffee.png' },
	},

	['cb-coffee3'] = {
		label = 'Кофе Латте',
		weight = 330,
		stack = true,
		close = true,
		description = 'Обыкновенный латте из ресторана Cluckin Bell',
		client = { image = 'cb-coffee.png' },
	},

	['cb-fries'] = {
		label = 'Картофель Фри',
		weight = 110,
		stack = true,
		close = true,
		description = 'Классический обжаренный картофель из ресторана Cluckin Bell',
		client = { image = 'cb-fries.png' },
	},

	['cb-legs'] = {
		label = 'Куриные ножки',
		weight = 120,
		stack = true,
		close = true,
		description = 'Обжаренные и сочные, очень жирные куриные ножки в панировке из ресторана Cluckin Bell',
		client = { image = 'cb-legs.png' },
	},

	['cb-wings'] = {
		label = 'Куриные крылышки',
		weight = 120,
		stack = true,
		close = true,
		description = 'Обжаренные и сочные, очень жирные куриные крылышки в панировке из ресторана Cluckin Bell',
		client = { image = 'cb-wings.png' },
	},

	['cb-soda1'] = {
		label = 'Стакан E-Cola',
		weight = 120,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка E-Cola, из ресторана Cluckin Bell',
		client = { image = 'cb-soda.png' },
	},

	['cb-soda2'] = {
		label = 'Стакан Sprunk',
		weight = 120,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка Sprunk, из ресторана Cluckin Bell',
		client = { image = 'cb-soda.png' },
	},

	['cb-bun'] = {
		label = 'Булочка',
		weight = 125,
		stack = true,
		close = true,
		description = 'Мягкая булочка',
		client = { image = 'bs_bun.png' },
	},

	['cb-meat'] = {
		label = 'Жаренная котлета',
		weight = 125,
		stack = true,
		close = true,
		description = 'Жаренная котлета из мраморной говядины',
		client = { image = 'bs_patty.png' },
	},

	['cb-lettuce'] = {
		label = 'Салат',
		weight = 125,
		stack = true,
		close = true,
		description = 'Лист салата',
		client = { image = 'bs_lettuce.png' },
	},

	['cb-tomato'] = {
		label = 'Помидоры',
		weight = 125,
		stack = true,
		close = true,
		description = 'Свежие помидоры',
		client = { image = 'bs_tomato.png' },
	},

	['cb-raw'] = {
		label = 'Сырая котлета',
		weight = 125,
		stack = true,
		close = true,
		description = 'Сырая котлета из мраморной говядины',
		client = { image = 'bs_patty_raw.png' },
	},

	['cb-potato'] = {
		label = 'Мешок картошки',
		weight = 1500,
		stack = true,
		close = true,
		description = 'Мешок очищенной картошки',
		client = { image = 'bs_potato.png' },
	},

	['lp-burger-b'] = {
		label = 'Большой Бургер',
		weight = 120,
		stack = true,
		close = true,
		description = 'Большой бургер из пары куриных котлет, салата и соусов',
		client = { image = 'cb-burger-b.png' },
	},

	['lp-burger-s'] = {
		label = 'Бургер',
		weight = 120,
		stack = true,
		close = true,
		description = 'Классический бургер из куриной котлетки, листа салата и кетчупа',
		client = { image = 'cb-burger-s.png' },
	},

	['lp-coffee1'] = {
		label = 'Кофе Капучино',
		weight = 120,
		stack = true,
		close = true,
		description = 'Обыкновенный капучино из ресторана Cluckin Bell',
		client = { image = 'cb-coffee.png' },
	},

	['lp-coffee2'] = {
		label = 'Кофе Американо',
		weight = 120,
		stack = true,
		close = true,
		description = 'Обыкновенный американо из ресторана Cluckin Bell',
		client = { image = 'cb-coffee.png' },
	},

	['lp-coffee3'] = {
		label = 'Кофе Латте',
		weight = 120,
		stack = true,
		close = true,
		description = 'Обыкновенный латте из ресторана Cluckin Bell',
		client = { image = 'cb-coffee.png' },
	},

	['lp-fries'] = {
		label = 'Картофель Фри',
		weight = 120,
		stack = true,
		close = true,
		description = 'Классический обжаренный картофель из ресторана Cluckin Bell',
		client = { image = 'cb-fries.png' },
	},

	['lp-legs'] = {
		label = 'Куриные ножки',
		weight = 120,
		stack = true,
		close = true,
		description = 'Обжаренные и сочные, очень жирные куриные ножки в панировке из ресторана Cluckin Bell',
		client = { image = 'cb-legs.png' },
	},

	['lp-wings'] = {
		label = 'Куриные крылышки',
		weight = 120,
		stack = true,
		close = true,
		description = 'Обжаренные и сочные, очень жирные куриные крылышки в панировке из ресторана Cluckin Bell',
		client = { image = 'cb-wings.png' },
	},

	['lp-soda1'] = {
		label = 'Стакан E-Cola',
		weight = 120,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка E-Cola, из ресторана Cluckin Bell',
		client = { image = 'cb-soda.png' },
	},

	['lp-soda2'] = {
		label = 'Стакан Sprunk',
		weight = 120,
		stack = true,
		close = true,
		description = 'Стакан, полный сладкого напитка Sprunk, из ресторана Cluckin Bell',
		client = { image = 'cb-soda.png' },
	},

	['lp-bun'] = {
		label = 'Булочка',
		weight = 125,
		stack = true,
		close = true,
		description = 'Мягкая булочка',
		client = { image = 'bs_bun.png' },
	},

	['lp-meat'] = {
		label = 'Жаренная котлета',
		weight = 125,
		stack = true,
		close = true,
		description = 'Жаренная котлета из мраморной говядины',
		client = { image = 'bs_patty.png' },
	},

	['lp-lettuce'] = {
		label = 'Салат',
		weight = 125,
		stack = true,
		close = true,
		description = 'Лист салата',
		client = { image = 'bs_lettuce.png' },
	},

	['lp-tomato'] = {
		label = 'Помидоры',
		weight = 125,
		stack = true,
		close = true,
		description = 'Свежие помидоры',
		client = { image = 'bs_tomato.png' },
	},

	['lp-raw'] = {
		label = 'Сырая котлета',
		weight = 125,
		stack = true,
		close = true,
		description = 'Сырая котлета из мраморной говядины',
		client = { image = 'bs_patty_raw.png' },
	},

	['lp-potato'] = {
		label = 'Мешок картошки',
		weight = 1500,
		stack = true,
		close = true,
		description = 'Мешок очищенной картошки',
		client = { image = 'bs_potato.png' },
	},

	['burger'] = {
		label = 'Бургер c говядиной',
		weight = 210,
		stack = true,
		close = false,
		description = 'Обыкновенный бургер с говядиной. Прекрасен на вкус и запах',
		client = { image = 'burger.png' },
	},

	['burger-s'] = {
		label = 'Бургер',
		weight = 120,
		stack = true,
		close = true,
		description = 'Классический бургер из говяжей котлетки, листа салата и кетчупа',
		client = { image = 'burger-s.png' },
	},

	['chicken-burger'] = {
		label = 'Большой Бургер',
		weight = 120,
		stack = true,
		close = true,
		description = 'Большой бургер из пары куриных котлет, салата и соусов',
		client = { image = 'chicken-burger.png' },
	},

	['chicken-burger-s'] = {
		label = 'Бургер',
		weight = 120,
		stack = true,
		close = true,
		description = 'Классический бургер из куриных котлетки, листа салата и кетчупа',
		client = { image = 'chicken-burger-s.png' },
	},

	['bread'] = {
		label = 'Хлеб',
		weight = 120,
		stack = true,
		close = true,
		description = 'Пачка обыкновенного нарезанного белого хлеба',
		client = { image = 'bread.png' },
	},

	['canned-corn'] = {
		label = 'Кукуруза',
		weight = 120,
		stack = true,
		close = true,
		description = 'Банка консервированной кукурузы',
		client = { image = 'canned-corn.png' },
	},

	['canned-tomatos'] = {
		label = 'Томаты',
		weight = 120,
		stack = true,
		close = true,
		description = 'Банка консервированных томатов',
		client = { image = 'canned-tomatos.png' },
	},

	['canned-tuna'] = {
		label = 'Тунец',
		weight = 120,
		stack = true,
		close = true,
		description = 'Банка консервированного тунца',
		client = { image = 'canned-tuna.png' },
	},

	['cereals'] = {
		label = 'Хлопья',
		weight = 120,
		stack = true,
		close = true,
		description = 'Упаковка хлопьев для плотного завтрака',
		client = { image = 'cereals.png' },
	},

	['chicken-pack'] = {
		label = 'Упаковка лапши',
		weight = 120,
		stack = true,
		close = true,
		description = 'Упаковка лапши быстрого приготовления со вкусом курицы',
		client = { image = 'chicken-pack.png' },
	},

	['eggs'] = {
		label = 'Упаковка яиц',
		weight = 120,
		stack = true,
		close = true,
		description = 'Упаковка свежих куриных яиц',
		client = { image = 'eggs.png' },
	},

	['ketchup'] = {
		label = 'Кетчуп',
		weight = 120,
		stack = true,
		close = true,
		description = 'Стандартная бутылка томатного кетчупа',
		client = { image = 'ketchup.png' },
	},

	['mustard'] = {
		label = 'Горчица',
		weight = 120,
		stack = true,
		close = true,
		description = 'Стандартная банка сладкой горчицы',
		client = { image = 'mustard.png' },
	},

	['plain-flour'] = {
		label = 'Мука',
		weight = 120,
		stack = true,
		close = true,
		description = 'Упаковка стандартной пшеничной муки',
		client = { image = 'plain-flour.png' },
	},

	['tomato-soup'] = {
		label = 'Томатный суп',
		weight = 120,
		stack = true,
		close = true,
		description = 'Банка с консервированным томатным супом',
		client = { image = 'tomato-soup.png' },
	},

	['vegetable-soup'] = {
		label = 'Овощной суп',
		weight = 120,
		stack = true,
		close = true,
		description = 'Банка с консервированным овощным супом',
		client = { image = 'vegetable-soup.png' },
	},

	['sodiumbicarbonate'] = {
		label = 'Пищевая сода',
		weight = 120,
		stack = true,
		close = true,
		description = 'Упаковка пищевой соды',
		client = { image = 'baking-soda.png' },
	},

	['sudz-soda'] = {
		label = 'Стиральный порошок',
		weight = 120,
		stack = true,
		close = true,
		description = 'Упаковка стирального порошка Sudz',
		client = { image = 'sudz-soda.png' },
	},

	['pow-milk'] = {
		label = 'Порошковое молоко',
		weight = 120,
		stack = true,
		close = true,
		description = 'Упаковка порошкового молока',
		client = { image = 'pow-milk.png' },
	},

	['blox-clean'] = {
		label = 'Моющее средство',
		weight = 120,
		stack = true,
		close = true,
		description = 'Канистра моющего средства Blox',
		client = { image = 'blox-clean.png' },
	},

	['ron-oil'] = {
		label = 'Масло Ron',
		weight = 120,
		stack = true,
		close = true,
		description = 'Канистра моторного масла Ron',
		client = { image = 'ron-oil.png' },
	},

	['xero-oil'] = {
		label = 'Масло Xero',
		weight = 120,
		stack = true,
		close = true,
		description = 'Канистра моторного масла Xero',
		client = { image = 'xero-oil.png' },
	},

	['key_unmarked'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Неизвестные ключи',
		client = { image = 'key.png' },
	},

	['vehiclekey_unmarked'] = {
		label = 'Автомобильные ключи',
		weight = 0,
		stack = false,
		close = true,
		description = 'Неизвестный автомобильный ключ',
		client = { image = 'vehiclekeys.png' },
	},

	['key_cypress-garage1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от гаража на Сайпресс-Флетс',
		client = { image = 'key.png' },
	},

	['key_cypress-garage2'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от автомагазина на Сайпресс-Флетс',
		client = { image = 'key.png' },
	},

	['key_rancho-garage1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Hayes на Ранчо',
		client = { image = 'key.png' },
	},

	['key_berton-lsc'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Los Santos Customs Бертон',
		client = { image = 'key.png' },
	},

	['key_lapuerta-lsc'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Los Santos Customs Ла-Пуерта',
		client = { image = 'key.png' },
	},

	['key_lamesa-lsc'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Los Santos Customs Ла-Меса',
		client = { image = 'key.png' },
	},

	['key_lamesa-autocare'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Autocare',
		client = { image = 'key.png' },
	},

	['key_strawberry-bennys'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Bennys Original Motorworks',
		client = { image = 'key.png' },
	},

	['key_eastside-garage1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Дэвис',
		client = { image = 'key.png' },
	},

	['key_mirror-jermaine'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Jermaine Team Racing',
		client = { image = 'key.png' },
	},

	['key_rancho-stash'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от мастерской Hayes на Ранчо',
		client = { image = 'key.png' },
	},

	['key_grovest-house1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от территории дома с Грув-Стрит',
		client = { image = 'key.png' },
	},

	['key_ktown-cafe'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от рестаранчика Red Mantis',
		client = { image = 'key.png' },
	},

	['key_ktown-lp'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от заведения Lucky Plucker Маленький Сеул',
		client = { image = 'key.png' },
	},

	['key_lamesa-bar'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от заведения BAR',
		client = { image = 'key.png' },
	},

	['key_vesp-bar'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от заведения Jamaica',
		client = { image = 'key.png' },
	},

	['key_vesp-smoke'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от заведения Smoke On The Water',
		client = { image = 'key.png' },
	},

	['key_strawberry-lp'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от заведения Lucky Plucker Строуберри',
		client = { image = 'key.png' },
	},

	['key_delp-burger'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от заведения Burger Shot',
		client = { image = 'key.png' },
	},

	['key_eastside-carwash1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от автомойки Ronnys',
		client = { image = 'key.png' },
	},

	['key_ktown-club'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от клуба Wu-Chang',
		client = { image = 'key.png' },
	},

	['key_lapuerta-scrapyard1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от свалки на Ла-Пуерта',
		client = { image = 'key.png' },
	},

	['key_strawberry-warehouse'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от старого комплекса LS Paper Co.',
		client = { image = 'key.png' },
	},

	['key_strawberry-club1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от клуба Vanilla Unicorn на Строберри',
		client = { image = 'key.png' },
	},

	['key_strawberry-tattoo1'] = {
		label = 'Ключи',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект ключей от тату-салона Los Santos Tattoo на Строберри',
		client = { image = 'key.png' },
	},

	['vehiclekey'] = {
		label = 'Автомобильные ключи',
		weight = 0,
		stack = false,
		close = true,
		description = 'Обеспечивает доступ к дверям и возможность запуска транспортного средства',
		client = { image = 'vehiclekeys.png' },
	},

	['mechanic_tools'] = {
		label = 'Инструменты механика',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Полноценный комплект инструментов для быстрой диагностики состояния элементов транспорта и ремонта его основных узов',
		client = { image = 'mechanic_tools.png' },
	},

	['toolbox'] = {
		label = 'Инструменты демонтажа',
		weight = 1000,
		stack = false,
		close = true,
		client = { image = 'toolbox.png' },
	},

	['ducttape'] = {
		label = 'Ремкомплект',
		weight = 100,
		stack = false,
		close = true,
		description = 'Минимальный комплект запчастей для частичной реанимации двигателя',
		client = { image = 'bodyrepair.png' },
	},

	['mechboard'] = {
		label = 'Планшет',
		weight = 0,
		stack = false,
		close = true,
		client = { image = 'mechboard.png' },
	},

	['newplate'] = {
		label = 'Новый номер',
		weight = 200,
		stack = true,
		close = true,
		client = { image = 'cleaningkit.png' },
	},

	['stancerkit'] = {
		label = 'Набор для регулировки подвески',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Специальный комплект инструментов, позволяющий регулировать сход и развал подвески',
		client = { image = 'tunerchip.png' },
	},

	['turbo'] = {
		label = 'Турбонаддув Спорт',
		weight = 600,
		stack = true,
		close = true,
		description = 'Спортивная система турбонаддува, существенно повышающая мощность автомобиля',
		client = { image = 'turbo.png' },
	},

	['nos'] = {
		label = 'Баллон нитро',
		weight = 200,
		stack = false,
		close = true,
		description = 'Готовый для установки, полностью заправленный баллон закиси азота',
		client = { image = 'nos.png' },
	},

	['noscan'] = {
		label = 'Баллон нитро (пуст)',
		weight = 200,
		stack = true,
		close = true,
		description = 'Пустой баллон из-под закиси азота',
		client = { image = 'noscan.png' },
	},

	['noscolour'] = {
		label = 'Краситель нитро',
		weight = 0,
		stack = true,
		close = true,
		description = 'Краситель для изменения цвета газа закиси азота',
		client = { image = 'noscolour.png' },
	},

	['engine1'] = {
		label = 'Двигатель Спорт I',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект начального улучшения двигателя, повышает мощность автомобиля',
		client = { image = 'engine1.png' },
	},

	['engine2'] = {
		label = 'Двигатель Спорт II',
		weight = 400,
		stack = true,
		close = true,
		description = 'Комплект легкого улучшения двигателя, повышает мощность автомобиля',
		client = { image = 'engine2.png' },
	},

	['engine3'] = {
		label = 'Двигатель Спорт III',
		weight = 800,
		stack = true,
		close = true,
		description = 'Комплект среднего улучшение двигателя, повышает мощность автомобиля',
		client = { image = 'engine3.png' },
	},

	['engine4'] = {
		label = 'Двигатель Спорт IV',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Комплект сильного улучшение двигателя, повышает мощность автомобиля',
		client = { image = 'engine4.png' },
	},

	['engine5'] = {
		label = 'Двигатель Проф',
		weight = 1400,
		stack = true,
		close = true,
		description = 'Комплект профессионального улучшение двигателя, максимально повышает мощность автомобиля, подходит не для всех автомобилей',
		client = { image = 'engine5.png' },
	},

	['transmission1'] = {
		label = 'Трансмиссия Спорт I',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект легкого улучшение трансмиссии, улучшает скорость и качество переключения передач',
		client = { image = 'transmission1.png' },
	},

	['transmission2'] = {
		label = 'Трансмиссия Спорт II',
		weight = 400,
		stack = true,
		close = true,
		description = 'Комплект среднего улучшение трансмиссии, улучшает скорость и качество переключения передач',
		client = { image = 'transmission2.png' },
	},

	['transmission3'] = {
		label = 'Трансмиссия Спорт III',
		weight = 800,
		stack = true,
		close = true,
		description = 'Комплект сильного улучшение трансмиссии, улучшает скорость и качество переключения передач',
		client = { image = 'transmission3.png' },
	},

	['transmission4'] = {
		label = 'Трансмиссия Проф',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Комплект профессионального улучшение трансмиссии, добавляет дополнительную передачу, подходит не для всех автомобилей',
		client = { image = 'transmission4.png' },
	},

	['brakes1'] = {
		label = 'Тормоза Спорт I',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект легкого улучшение тормозной системы, увеличивает силу тормозов',
		client = { image = 'brakes1.png' },
	},

	['brakes2'] = {
		label = 'Тормоза Спорт II',
		weight = 600,
		stack = true,
		close = true,
		description = 'Комплект среднего улучшение тормозной системы, увеличивает силу тормозов',
		client = { image = 'brakes2.png' },
	},

	['brakes3'] = {
		label = 'Тормоза Спорт III',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Комплект сильного улучшение тормозной системы, максимально увеличивает силу тормозов',
		client = { image = 'brakes3.png' },
	},

	['suspension1'] = {
		label = 'Занижение I',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект элементов подвески для незначительного уменшения клиренса',
		client = { image = 'suspension1.png' },
	},

	['suspension2'] = {
		label = 'Занижение II',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект элементов подвески для легкого уменшения клиренса',
		client = { image = 'suspension2.png' },
	},

	['suspension3'] = {
		label = 'Занижение III',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект элементов подвески для среднего уменшения клиренса',
		client = { image = 'suspension3.png' },
	},

	['suspension4'] = {
		label = 'Занижение IV',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект элементов подвески для сильного уменшения клиренса',
		client = { image = 'suspension4.png' },
	},

	['suspension5'] = {
		label = 'Занижение V',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комплект элементов подвески для максимального уменшения клиренса',
		client = { image = 'suspension5.png' },
	},

	['bprooftires'] = {
		label = 'Пулестойкие шины',
		weight = 6000,
		stack = true,
		close = true,
		description = 'Полный комплект покрышек, использующая плотную резину и специальное армирование',
		client = { image = 'bprooftires.png' },
	},

	['drifttires'] = {
		label = 'Шины для дрифта',
		weight = 6000,
		stack = true,
		close = true,
		description = 'Полный комплект покрышек, специально оборудованных для снижения сцепления с поверхностью',
		client = { image = 'drifttires.png' },
	},

	['underglow_controller'] = {
		label = 'Настройщик световых аксессуаров',
		weight = 200,
		stack = false,
		close = true,
		description = 'Настройщик световых аксессуаров для автомобиля, позволяющий настроить неоновый свет для днища автомобиля и цветные LED фонари для передних фар.',
		client = { image = 'underglow_controller.png' },
	},

	['headlights'] = {
		label = 'Тюнингованная оптика',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект обновленных передних фар.',
		client = { image = 'headlights.png' },
	},

	['manual'] = {
		label = 'Ручная КПП',
		weight = 0,
		stack = false,
		close = true,
		description = 'Спортивная ручная коробка передач.',
		client = { image = 'manual.png' },
	},

	['underglow'] = {
		label = 'Неоновая подсветка',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект полной неоновой подсветки днища для автомобиля. Для редактирования воспользуйтесь настройщиком световых аксессуаров.',
		client = { image = 'underglow.png' },
	},

	['tint_supplies'] = {
		label = 'Комплект тонировки',
		weight = 100,
		stack = true,
		close = true,
		description = 'Сырьё и инструменты для нанесения тонировки',
		client = { image = 'tint_supplies.png' },
	},

	['customplate'] = {
		label = 'Автомобильные номера',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'plate.png' },
	},

	['hood'] = {
		label = 'Капот',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'hood.png' },
	},

	['roof'] = {
		label = 'Крыша',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'roof.png' },
	},

	['spoiler'] = {
		label = 'Спойлер',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'spoiler.png' },
	},

	['bumper'] = {
		label = 'Бампер',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'bumper.png' },
	},

	['skirts'] = {
		label = 'Юбки',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'skirts.png' },
	},

	['exhaust'] = {
		label = 'Выхлоп',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'exhaust.png' },
	},

	['seat'] = {
		label = 'Сидения',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'seat.png' },
	},

	['rollcage'] = {
		label = 'Каркас',
		weight = 100,
		stack = true,
		close = true,
		client = { image = 'rollcage.png' },
	},

	['rims'] = {
		label = 'Комплект колес',
		weight = 100,
		stack = true,
		close = true,
		description = 'Комлект колес для вашего автомобиля',
		client = { image = 'rims.png' },
	},

	['livery'] = {
		label = 'Комплект ливрей',
		weight = 0,
		stack = true,
		close = true,
		description = 'Набор из различных наклеек, позволяющий нанести на автомобиль множество комплектов ливрей',
		client = { image = 'livery.png' },
	},

	['paintcan'] = {
		label = 'Автомобильная краска',
		weight = 0,
		stack = true,
		close = true,
		description = 'Набор из множества красок, позволяет нанести цвет на выбор: из каталога или используя палитру',
		client = { image = 'spraycan.png' },
	},

	['tires'] = {
		label = 'Цветной дым',
		weight = 0,
		stack = true,
		close = true,
		description = 'Выбор специальной резины, использовать цветной дым во время скольжения',
		client = { image = 'tires.png' },
	},

	['car_armor'] = {
		label = 'Автомобильная броня',
		weight = 0,
		stack = false,
		close = true,
		description = 'Комплект армированных пластин, позволяющий установить на автомобиль легкую и незаметную броню',
		client = { image = 'armour.png' },
	},

	['horn'] = {
		label = 'Автомобильный гудок',
		weight = 0,
		stack = true,
		close = true,
		description = 'Комплект автомобильных гудков, обладающих индивидуальными звуками',
		client = { image = 'horn.png' },
	},

	['internals'] = {
		label = 'Аксессуары интерьера',
		weight = 0,
		stack = true,
		close = true,
		client = { image = 'internals.png' },
	},

	['externals'] = {
		label = 'Аксессуары экстерьера',
		weight = 0,
		stack = true,
		close = true,
		client = { image = 'mirror.png' },
	},

	['rims2'] = {
		label = 'Custom Wheel Rims',
		weight = 0,
		stack = true,
		close = true,
		client = { image = 'rims.png' },
	},

	['rimsShal337'] = {
		label = 'Custom Wheel Rims1',
		weight = 0,
		stack = true,
		close = true,
		client = { image = 'rims.png' },
	},

	['newoil'] = {
		label = 'Автомобильное масло',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['sparkplugs'] = {
		label = 'Свечи зажигания',
		weight = 0,
		stack = true,
		close = false,
		client = { image = 'sparkplugs.png' },
	},

	['carbattery'] = {
		label = 'Автомобильный аккамулятор',
		weight = 1000,
		stack = true,
		close = false,
		client = { image = 'carbattery.png' },
	},

	['axleparts'] = {
		label = 'Запчасти ходовой системы',
		weight = 0,
		stack = true,
		close = false,
		client = { image = 'axleparts.png' },
	},

	['sparetire'] = {
		label = 'Запасное колесо',
		weight = 1000,
		stack = true,
		close = false,
		client = { image = 'sparetire.png' },
	},

	['oilp1'] = {
		label = 'Автомобильное масло 1',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['oilp2'] = {
		label = 'Автомобильное масло 2',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['oilp3'] = {
		label = 'Автомобильное масло 3',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['drives1'] = {
		label = 'Запчасть ходовой 1',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['drives2'] = {
		label = 'Запчасть ходовой 2',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['drives3'] = {
		label = 'Запчасть ходовой 3',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['cylind1'] = {
		label = 'Запчасть двигателя 1',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['cylind2'] = {
		label = 'Запчасть двигателя 2',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['cylind3'] = {
		label = 'Запчасть двигателя 3',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['cables1'] = {
		label = 'Автомобильная проводка 1',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['cables2'] = {
		label = 'Автомобильная проводка 2',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['cables3'] = {
		label = 'Автомобильная проводка 3',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['fueltank1'] = {
		label = 'Топливный бак 1',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['fueltank2'] = {
		label = 'Топливный бак 2',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['fueltank3'] = {
		label = 'Топливный бак 3',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['antilag'] = {
		label = 'Система Антилаг',
		weight = 500,
		stack = true,
		close = false,
		client = { image = 'xero-oil.png' },
	},

	['burnerphone'] = {
		label = 'Одноразовый телефон',
		weight = 250,
		stack = true,
		close = true,
		description = 'A burner phone, what do you need one of these for?',
		client = { image = 'burnerphone.png' },
	},

	['drug_shears'] = {
		label = 'Садовые ножницы',
		weight = 250,
		stack = true,
		close = false,
		description = 'Инструмент для обрезки растений и веток',
		client = { image = 'drug_shears.png' },
	},

	['drug_scales'] = {
		label = 'Весы',
		weight = 150,
		stack = true,
		close = false,
		description = 'Минималистичные весы, для быстрого взвешивания чего-то очень небольшого',
		client = { image = 'drug_scales.png' },
	},

	['drug_grinder'] = {
		label = 'Гриндер',
		weight = 150,
		stack = true,
		close = false,
		description = 'Ручное устройство для перемалывания растений',
		client = { image = 'drug_grinder.png' },
	},

	['rollingpapers'] = {
		label = 'Сигаретная бумага',
		weight = 20,
		stack = true,
		close = false,
		description = 'Бумага для скручивания сигарет',
		client = { image = 'rollingpapers.png' },
	},

	['empty_weed_bag'] = {
		label = 'Пустой пакетик',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пустой пакетик для хранения мелких предметов',
		client = { image = 'empty_weed_bag.png' },
	},

	['weed_fertilizer'] = {
		label = 'Удобрения',
		weight = 120,
		stack = true,
		close = false,
		description = 'Удобрения для улучшения роста растений',
		client = { image = 'weed_fertilizer.png' },
	},

	['distilled_water'] = {
		label = 'Дист. вода',
		weight = 900,
		stack = true,
		close = false,
		description = 'Дистиллированная вода для различных целей',
		client = { image = 'distilled_water.png' },
	},

	['trowel'] = {
		label = 'Лопатка',
		weight = 120,
		stack = true,
		close = false,
		description = 'Стандартный инструмент для набора садовода',
		client = { image = 'trowel.png' },
	},

	['razorblade'] = {
		label = 'Одноразовое лезвие',
		weight = 25,
		stack = true,
		close = true,
		description = 'Острое одноразовое лезвие для различных целей',
		client = { image = 'razorblade.png' },
	},

	['syringe'] = {
		label = 'Шприц',
		weight = 20,
		stack = true,
		close = true,
		description = 'Медицинский шприц для инъекций и других медицинских процедур',
		client = { image = 'syringe.png' },
	},

	['plasticjerrycan'] = {
		label = 'Пластиковая канистра',
		weight = 500,
		stack = true,
		close = true,
		description = 'Небольшая и лёгкая канистра для хранения различных жидкостей',
		client = { image = 'plasticjerrycan.png' },
	},

	['emptyvial'] = {
		label = 'Пустой флакон',
		weight = 90,
		stack = true,
		close = true,
		description = 'Пустой стеклянный флакон для хранения жидкостей или порошков',
		client = { image = 'emptyvial.png' },
	},

	['drug_cuttingkit'] = {
		label = 'Зеркальце и лезвие',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Набор, включающий зеркальце и лезвие для подготовки веществ',
		client = { image = 'drug_cuttingkit.png' },
	},

	['weed_skunk_seed_m'] = {
		label = 'Семена Skunk',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена сорта Skunk, известного своим сильным ароматом и устойчивостью',
		client = { image = 'weed_skunk_seed_m.png' },
	},

	['weed_og-kush_seed_m'] = {
		label = 'Семена OG-Kush',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена популярного сорта OG-Kush, ценимые за их качество и эффект',
		client = { image = 'weed_og-kush_seed_m.png' },
	},

	['weed_white-widow_seed_m'] = {
		label = 'Семена White-Widow',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена сорта White Widow, известного своим мощным эффектом и высоким содержанием каннабиноидов',
		client = { image = 'weed_white-widow_seed_m.png' },
	},

	['weed_ak47_seed_m'] = {
		label = 'Семена AK47',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена сорта AK-47, известного своей высокой урожайностью и стабильным эффектом',
		client = { image = 'weed_ak47_seed_m.png' },
	},

	['weed_amnesia_seed_m'] = {
		label = 'Семена Amnesia',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена сорта Amnesia, известного своим сильным психоактивным эффектом',
		client = { image = 'weed_amnesia_seed_m.png' },
	},

	['weed_purple-haze_seed_m'] = {
		label = 'Семена Purple-Haze',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена сорта Purple Haze, известного своим уникальным ароматом и цветом',
		client = { image = 'weed_purple-haze_seed_m.png' },
	},

	['weed_gelato_seed_m'] = {
		label = 'Семена Gelato',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена сорта Gelato, ценимые за их сладкий аромат и сбалансированный эффект',
		client = { image = 'weed_gelato_seed_m.png' },
	},

	['weed_zkittlez_seed_m'] = {
		label = 'Семена Zkittlez',
		weight = 1,
		stack = true,
		close = true,
		description = 'Семена сорта Zkittlez, известного своим фруктовым вкусом и расслабляющим эффектом',
		client = { image = 'weed_zkittlez_seed_m.png' },
	},

	['weed_skunk_crop'] = {
		label = 'Срез Skunk',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_skunk_crop.png' },
	},

	['weed_og-kush_crop'] = {
		label = 'Срез OG-Kush',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_og-kush_crop.png' },
	},

	['weed_white-widow_crop'] = {
		label = 'Срез White-Widow',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_white-widow_crop.png' },
	},

	['weed_ak47_crop'] = {
		label = 'Срез AK47',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_ak47_crop.png' },
	},

	['weed_amnesia_crop'] = {
		label = 'Срез Amnesia',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_amnesia_crop.png' },
	},

	['weed_purple-haze_crop'] = {
		label = 'Срез Purple-Haze',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_purple-haze_crop.png' },
	},

	['weed_gelato_crop'] = {
		label = 'Срез Gelato',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_gelato_crop.png' },
	},

	['weed_zkittlez_crop'] = {
		label = 'Срез Zkittlez',
		weight = 400,
		stack = true,
		close = false,
		description = 'Свежесобранная травка',
		client = { image = 'weed_zkittlez_crop.png' },
	},

	['weed_skunk'] = {
		label = 'Пакетик Skunk',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_skunk.png' },
	},

	['weed_og-kush'] = {
		label = 'Пакетик OG-Kush',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_og-kush.png' },
	},

	['weed_white-widow'] = {
		label = 'Пакетик White-Widow',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_white-widow.png' },
	},

	['weed_ak47'] = {
		label = 'Пакетик AK47',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_ak47.png' },
	},

	['weed_amnesia'] = {
		label = 'Пакетик Amnesia',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_amnesia.png' },
	},

	['weed_purple-haze'] = {
		label = 'Пакетик Purple-Haze',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_purple-haze.png' },
	},

	['weed_gelato'] = {
		label = 'Пакетик Gelato',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_gelato.png' },
	},

	['weed_zkittlez'] = {
		label = 'Пакетик Zkittlez',
		weight = 2,
		stack = true,
		close = false,
		description = 'Пакетик расфасованной травки',
		client = { image = 'weed_zkittlez.png' },
	},

	['weed_skunk_joint'] = {
		label = 'Джоинт Skunk',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с сортом Skunk, известным своим сильным ароматом',
		client = { image = 'weed_skunk_joint.png' },
	},

	['weed_og-kush_joint'] = {
		label = 'Джоинт OG-Kush',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с популярным сортом OG-Kush, ценимый за качество и эффект',
		client = { image = 'weed_og-kush_joint.png' },
	},

	['weed_white-widow_joint'] = {
		label = 'Джоинт White-Widow',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с сортом White Widow, известным мощным эффектом',
		client = { image = 'weed_white-widow_joint.png' },
	},

	['weed_ak47_joint'] = {
		label = 'Джоинт AK-47',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с сортом AK-47, известным высокой урожайностью и стабильным эффектом',
		client = { image = 'weed_ak47_joint.png' },
	},

	['weed_amnesia_joint'] = {
		label = 'Джоинт Amnesia',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с сортом Amnesia, известным сильным психоактивным эффектом',
		client = { image = 'weed_amnesia_joint.png' },
	},

	['weed_purple-haze_joint'] = {
		label = 'Джоинт Purple-Haze',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с сортом Purple Haze, известным уникальным ароматом и цветом',
		client = { image = 'weed_purple-haze_joint.png' },
	},

	['weed_gelato_joint'] = {
		label = 'Джоинт Gelato',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с сортом Gelato, ценимый за сладкий аромат и сбалансированный эффект',
		client = { image = 'weed_gelato_joint.png' },
	},

	['weed_zkittlez_joint'] = {
		label = 'Джоинт Zkittlez',
		weight = 1,
		stack = true,
		close = false,
		description = 'Джоинт с сортом Zkittlez, известным фруктовым вкусом и расслабляющим эффектом',
		client = { image = 'weed_zkittlez_joint.png' },
	},

	['cement'] = {
		label = 'Цемент',
		weight = 1200,
		stack = true,
		close = true,
		description = 'Обыкновенный строительный цемент',
		client = { image = 'cement.png' },
	},

	['slakedlime'] = {
		label = 'Гашёная известь',
		weight = 140,
		stack = true,
		close = true,
		description = 'Используется в строительстве и других химических процессах',
		client = { image = 'slakedlime.png' },
	},

	['ammonia'] = {
		label = 'Аммиак',
		weight = 120,
		stack = true,
		close = true,
		description = 'Используется в промышленности и лабораториях для различных химических реакций',
		client = { image = 'ammonia.png' },
	},

	['aceticacid'] = {
		label = 'Уксусная кислота',
		weight = 290,
		stack = true,
		close = true,
		description = 'Широко используется в химической промышленности и пищевых технологиях',
		client = { image = 'aceticacid.png' },
	},

	['hydrochloricacid'] = {
		label = 'Соляная кислота',
		weight = 20,
		stack = true,
		close = false,
		description = 'Сильная минеральная кислота, используемая в химических процессах и лабораториях',
		client = { image = 'hydrochloricacid.png' },
	},

	['ether'] = {
		label = 'Петролейный эфир',
		weight = 630,
		stack = true,
		close = true,
		description = 'Используется как растворитель и в медицинских целях',
		client = { image = 'ether.png' },
	},

	['sodiumcarbonate'] = {
		label = 'Стиральный порошок',
		weight = 20,
		stack = true,
		close = true,
		description = 'Используется в быту и промышленности',
		client = { image = 'sodiumcarbonate.png' },
	},

	['opium'] = {
		label = 'Опиум',
		weight = 20,
		stack = true,
		close = true,
		description = 'Наркотическое вещество, получаемое из опиумного мака',
		client = { image = 'opium.png' },
	},

	['morphinebase'] = {
		label = 'Морфиновая основа',
		weight = 20,
		stack = true,
		close = true,
		description = 'Основа для производства морфина, используемая в медицинских и химических целях',
		client = { image = 'morphinebase.png' },
	},

	['heroinbase'] = {
		label = 'Героиновая основа',
		weight = 20,
		stack = true,
		close = true,
		description = 'Основа для производства героина, используемая в нелегальных химических процессах',
		client = { image = 'heroinbase.png' },
	},

	['sterilewater'] = {
		label = 'Стерильная вода',
		weight = 850,
		stack = true,
		close = true,
		description = 'Стерильная вода для разбавки медикаментов перед инъекцией',
		client = { image = 'sterilewater.png' },
	},

	['morphine'] = {
		label = 'Флакон с морфином',
		weight = 10,
		stack = true,
		close = true,
		description = 'Готовый к инъекции, медицинский морфин',
		client = { image = 'morphine.png' },
	},

	['morphinebaggy'] = {
		label = 'Пакетик морфина',
		weight = 5,
		stack = true,
		close = true,
		description = 'Расфасованный медицинский морфин, для употребления необходим шприц',
		client = { image = 'morphinebaggy.png' },
	},

	['heroinbaggy'] = {
		label = 'Пакетик героина',
		weight = 5,
		stack = true,
		close = true,
		description = 'Пакетик с великим и ужасным героином',
		client = { image = 'heroinbaggy.png' },
	},

	['liquidheroin'] = {
		label = 'Флакон с героином',
		weight = 10,
		stack = true,
		close = true,
		description = 'Готовый к инъекции, разбавленный героин',
		client = { image = 'liquidheroin.png' },
	},

	['heroin_1oz'] = {
		label = 'Унция героина',
		weight = 280,
		stack = true,
		close = true,
		description = 'Огромная масса героина',
		client = { image = 'heroin_1oz.png' },
	},

	['acetone'] = {
		label = 'Ацетон',
		weight = 20,
		stack = true,
		close = false,
		description = 'Органический растворитель, широко используемый для очистки и в химических реакциях',
		client = { image = 'acetone.png' },
	},

	['methylamine'] = {
		label = 'Метиламин',
		weight = 20,
		stack = true,
		close = true,
		description = 'Органическое соединение, используемое в химической промышленности и лабораториях',
		client = { image = 'methylamine.png' },
	},

	['meth'] = {
		label = 'Метамфетамин',
		weight = 5,
		stack = true,
		close = true,
		description = 'Пакетик готового к употреблению кристаллического метамфетамина',
		client = { image = 'meth.png' },
	},

	['meth_1oz'] = {
		label = 'Унция метамфетамина',
		weight = 280,
		stack = true,
		close = true,
		description = 'Нерасфасонванный метамфетамин',
		client = { image = 'meth_1oz.png' },
	},

	['cocaleaf'] = {
		label = 'Лист коки',
		weight = 20,
		stack = true,
		close = false,
		description = 'Лист, собранный с золотоносного куста коки',
		client = { image = 'cocaineleaf.png' },
	},

	['illegalgasoline'] = {
		label = 'Индустриальный бензин',
		weight = 1500,
		stack = true,
		close = true,
		description = 'Бензин, используемый в различных промышленных процессах',
		client = { image = 'illegalgasoline.png' },
	},

	['benzocaine'] = {
		label = 'Бензокаин',
		weight = 20,
		stack = true,
		close = true,
		description = 'Местный анестетик, используемый для обезболивания кожи и слизистых оболочек',
		client = { image = 'benzocaine.png' },
	},

	['water_jerrycan'] = {
		label = 'Бутыль с водой',
		weight = 900,
		stack = true,
		close = false,
		description = 'Бутыль воды объемом 2.5 литра',
		client = { image = 'water_jerrycan.png' },
	},

	['cokebaggy'] = {
		label = 'Кокаин',
		weight = 10,
		stack = true,
		close = true,
		description = 'Пакетик одного из самых попсовых и дорогих наркотиков Америки. Готов к употреблению',
		client = { image = 'cocaine_baggy.png' },
	},

	['coke_1oz'] = {
		label = 'Унция кокаина',
		weight = 280,
		stack = true,
		close = true,
		description = 'Нерасфасованный кокаин',
		client = { image = 'coke_1oz.png' },
	},

	['crack_baggy'] = {
		label = 'Крэк-кокаин',
		weight = 10,
		stack = true,
		close = true,
		description = 'Пакетик одного из самых разрушительных и доступных наркотиков Америки. Готов к употреблению',
		client = { image = 'crack_baggy.png' },
	},

	['crack_1oz'] = {
		label = 'Унция крэк-кокаина',
		weight = 280,
		stack = true,
		close = true,
		description = 'Нерасфасовынный крэк-кокаин',
		client = { image = 'crack_1oz.png' },
	},

	['liquidketamine'] = {
		label = 'Флакон кетамина',
		weight = 500,
		stack = true,
		close = true,
		description = 'Фалакончик с медицинским кетамином, синтетический галюценоген используемный для анастезии',
		client = { image = 'liquidketamine.png' },
	},

	['ketamine_1oz'] = {
		label = 'Унция кетамина',
		weight = 280,
		stack = true,
		close = true,
		description = 'Нерасфасованная твердый кетамин',
		client = { image = 'ketamine_1oz.png' },
	},

	['ketamine'] = {
		label = 'Кетамин',
		weight = 100,
		stack = true,
		close = true,
		description = 'Пакетик синтетического галюценогена - кетамина. Готов к употреблению',
		client = { image = 'ketamine.png' },
	},

	['xtcbaggy'] = {
		label = 'Экстази',
		weight = 5,
		stack = true,
		close = true,
		description = 'Таблетка экстази, он же МДМА. Синтетический стимулятор с психоделическим действием',
		client = { image = 'xtc_baggy.png' },
	},

	['lsdbaggy'] = {
		label = 'ЛСД',
		weight = 5,
		stack = true,
		close = true,
		description = 'Доза ЛСД – один из самых известных психоделликов',
		client = { image = 'lsd_baggy.png' },
	},

	['potato'] = {
		label = 'Картофель',
		weight = 0,
		stack = true,
		close = false,
		description = 'Обыкновенный картофель',
		client = { image = 'potato.png' },
	},

	['slicedpotato'] = {
		label = 'Нарезанный картофель',
		weight = 500,
		stack = true,
		close = false,
		description = 'Нарезанная картошка',
		client = { image = 'burger-slicedpotato.png' },
	},

	['slicedonion'] = {
		label = 'Нарезанный лук',
		weight = 500,
		stack = true,
		close = false,
		description = 'Нарезанный лук',
		client = { image = 'burger-slicedonion.png' },
	},

	['icecream'] = {
		label = 'Мороженое',
		weight = 500,
		stack = true,
		close = false,
		description = 'Мороженое',
		client = { image = 'burger-icecream.png' },
	},

	['milk'] = {
		label = 'Молоко',
		weight = 500,
		stack = true,
		close = true,
		description = 'Пакет молока',
		client = { image = 'burger-milk.png' },
	},

	['lettuce'] = {
		label = 'Салат',
		weight = 0,
		stack = true,
		close = false,
		description = 'Свежий салат',
		client = { image = 'lettuce.png' },
	},

	['onion'] = {
		label = 'Лук',
		weight = 500,
		stack = true,
		close = false,
		description = 'Луковица',
		client = { image = 'burger-onion.png' },
	},

	['frozennugget'] = {
		label = 'Замороженные наггетсы',
		weight = 500,
		stack = true,
		close = false,
		description = 'Пакет с замороженными наггетсами',
		client = { image = 'burger-frozennugget.png' },
	},

	['cheddar'] = {
		label = 'Сыр чеддер',
		weight = 500,
		stack = true,
		close = false,
		description = 'Кусочек сыра чеддер',
		client = { image = 'cheddar.png' },
	},

	['burgerbun'] = {
		label = 'Булка',
		weight = 100,
		stack = true,
		close = false,
		description = 'Большая булочка для бургера',
		client = { image = 'burgerbun.png' },
	},

	['burgerpatty'] = {
		label = 'Котлетка',
		weight = 500,
		stack = true,
		close = false,
		description = 'Сырая котлета для бургера',
		client = { image = 'burgerpatty.png' },
	},

	['burgermeat'] = {
		label = 'Мясо',
		weight = 500,
		stack = true,
		close = false,
		description = 'Приготовленное мясо для бургера',
		client = { image = 'burgermeat.png' },
	},

	['milkshake'] = {
		label = 'Милкшейк',
		weight = 500,
		stack = true,
		close = true,
		description = 'Милкшейк из BurgerShot',
		client = { image = 'burger-milkshake.png' },
	},

	['shotnuggets'] = {
		label = 'Наггетсы',
		weight = 200,
		stack = true,
		close = true,
		description = 'Наггетсы из BurgerShot',
		client = { image = 'burger-shotnuggets.png' },
	},

	['shotrings'] = {
		label = 'Луковые кольца',
		weight = 200,
		stack = true,
		close = true,
		description = 'Луковые кольца из BurgerShot',
		client = { image = 'burger-shotrings.png' },
	},

	['heartstopper'] = {
		label = 'HeartStopper',
		weight = 200,
		stack = true,
		close = true,
		description = 'Heartstopper',
		client = { image = 'burger-heartstopper.png' },
	},

	['shotfries'] = {
		label = 'Картофель Фри',
		weight = 200,
		stack = true,
		close = true,
		description = 'Картофель фри',
		client = { image = 'burger-fries.png' },
	},

	['moneyshot'] = {
		label = 'Money Shot',
		weight = 200,
		stack = true,
		close = true,
		description = 'Money Shot',
		client = { image = 'burger-moneyshot.png' },
	},

	['meatfree'] = {
		label = 'Meat Free',
		weight = 200,
		stack = true,
		close = true,
		description = 'Бургер без мяса',
		client = { image = 'burger-meatfree.png' },
	},

	['bleeder'] = {
		label = 'Кровавый бургер',
		weight = 270,
		stack = true,
		close = true,
		description = 'Кровавый бургер',
		client = { image = 'burger-bleeder.png' },
	},

	['bscoffee'] = {
		label = 'Кофе',
		weight = 200,
		stack = true,
		close = true,
		description = 'Кофе из BurgerShot',
		client = { image = 'burger-coffee.png' },
	},

	['bscoke'] = {
		label = 'Кола',
		weight = 200,
		stack = true,
		close = true,
		description = 'Кола из BurgerShot',
		client = { image = 'burger-softdrink.png' },
	},

	['torpedo'] = {
		label = 'Torpedo',
		weight = 200,
		stack = true,
		close = true,
		description = 'BurgerShot Torpedo',
		client = { image = 'burger-torpedo.png' },
	},

	['rimjob'] = {
		label = 'Бургер «Римминг»',
		weight = 200,
		stack = true,
		close = true,
		description = 'Бургер «Римминг»',
		client = { image = 'burger-rimjob.png' },
	},

	['creampie'] = {
		label = 'Бургер «Кремовый пирог»',
		weight = 200,
		stack = true,
		close = true,
		description = 'Бургер «Кремовый пирог»',
		client = { image = 'burger-creampie.png' },
	},

	['cheesewrap'] = {
		label = 'BS Cheese Wrap',
		weight = 150,
		stack = true,
		close = true,
		description = 'BurgerShot Cheese Wrap',
		client = { image = 'burger-chickenwrap.png' },
	},

	['chickenwrap'] = {
		label = 'BS Goat Cheese Wrap',
		weight = 150,
		stack = true,
		close = true,
		description = 'BurgerShot Goat Cheese Wrap',
		client = { image = 'burger-goatwrap.png' },
	},

	['murderbag'] = {
		label = 'Упаковочная бумага',
		weight = 0,
		stack = false,
		close = true,
		description = 'Упаковочная бумага для бургеров',
		client = { image = 'burgerbag.png' },
	},

	['buns'] = {
		label = 'Булочки',
		weight = 0,
		stack = true,
		close = false,
		description = 'Булочки для бургера',
		client = { image = 'buns.png' },
	},

	['cheese'] = {
		label = 'Сыр',
		weight = 0,
		stack = true,
		close = false,
		description = 'Сыр тильзитер',
		client = { image = 'cheese.png' },
	},

	['onions'] = {
		label = 'Лук',
		weight = 0,
		stack = true,
		close = false,
		description = 'Свежий репчатый лук',
		client = { image = 'onions.png' },
	},

	['raw_patty'] = {
		label = 'Сырая котлета',
		weight = 0,
		stack = true,
		close = false,
		description = 'Сырая котлета для бургера',
		client = { image = 'raw_patty.png' },
	},

	['cooked_patty'] = {
		label = 'Приготовленная котлета',
		weight = 0,
		stack = true,
		close = false,
		description = 'Приготовленная котлета для бургера',
		client = { image = 'cooked_patty.png' },
	},

	['tomato'] = {
		label = 'Помидор',
		weight = 0,
		stack = true,
		close = false,
		description = 'Помидор',
		client = { image = 'tomato.png' },
	},

	['double_burger'] = {
		label = 'Двойной чизбургер',
		weight = 250,
		stack = true,
		close = false,
		description = 'Вкуснейший двойной чизбургер',
		client = { image = 'double_burger.png' },
	},

	['triple_burger'] = {
		label = 'Тройной чизбургер',
		weight = 310,
		stack = true,
		close = false,
		description = 'Погоди, что? Тройной, мать его, чизбургер',
		client = { image = 'triple_burger.png' },
	},

	['fries'] = {
		label = 'Картофель фри',
		weight = 0,
		stack = true,
		close = false,
		description = 'Жирный картофель фри',
		client = { image = 'fries.png' },
	},

	['tortilla'] = {
		label = 'Тортилья',
		weight = 100,
		stack = true,
		close = false,
		description = 'Обыкновенная тортилья',
		client = { image = 'tortilla.png' },
	},

	['cooked_fish'] = {
		label = 'Приготовленная рыба',
		weight = 200,
		stack = true,
		close = false,
		description = 'Приготовленная оыба',
		client = { image = 'cooked_fish.png' },
	},

	['raw_fish'] = {
		label = 'Сырая рыба',
		weight = 200,
		stack = true,
		close = false,
		description = 'Сырая рыба высокого качества',
		client = { image = 'raw_fish.png' },
	},

	['raw_chicken'] = {
		label = 'Сырая курица',
		weight = 70,
		stack = true,
		close = false,
		description = 'Сырая курица, прямо с фермы',
		client = { image = 'raw_chicken.png' },
	},

	['cooked_chicken'] = {
		label = 'Приготовленная курица',
		weight = 450,
		stack = true,
		close = false,
		description = 'Прожаренная, приготовленная курица',
		client = { image = 'cooked_chicken.png' },
	},

	['orange_chicken'] = {
		label = 'Курица в апельсиновом соусе',
		weight = 300,
		stack = true,
		close = false,
		description = 'Жареная курочка в апельсионовом соусе',
		client = { image = 'orange_chicken.png' },
	},

	['sushi'] = {
		label = 'Суши',
		weight = 250,
		stack = true,
		close = false,
		description = 'Суши',
		client = { image = 'sushi.png' },
	},

	['fish_taco'] = {
		label = 'Рыбное тако',
		weight = 80,
		stack = true,
		close = false,
		description = 'Рыбное тако. Кто это вообще ест?',
		client = { image = 'fish_taco.png' },
	},

	['rice'] = {
		label = 'Рис',
		weight = 60,
		stack = true,
		close = false,
		description = 'Дальневосточный рис',
		client = { image = 'rice.png' },
	},

	['fried_rice'] = {
		label = 'Жареный рис',
		weight = 120,
		stack = true,
		close = false,
		description = 'Жареный рис, в традиционном исполнении',
		client = { image = 'fried_rice.png' },
	},

	['receipt'] = {
		label = 'Чек',
		weight = 0,
		stack = true,
		close = false,
		description = 'Чек',
		client = { image = 'receipt.png' },
	},

	['brusketa_mocarela'] = {
		label = 'Брускетта моцарелла',
		weight = 60,
		stack = true,
		close = false,
		description = 'Простое итальянское блюдо, сытный или легкий перекус - обеспечен',
		client = { image = 'brusketa_mocarela.png' },
	},

	['cherry_tomato'] = {
		label = 'Томаты черри',
		weight = 80,
		stack = true,
		close = false,
		description = 'Маленькие, сладкие и сочные помидорки',
		client = { image = 'cherry_tomato.png' },
	},

	['chiabata'] = {
		label = 'Хлеб чиабатта',
		weight = 40,
		stack = true,
		close = false,
		description = 'Хрустящий, мягкий, итальянский хлеб',
		client = { image = 'chiabata.png' },
	},

	['mocarella'] = {
		label = 'Сыр моцарелла',
		weight = 30,
		stack = true,
		close = false,
		description = 'Итальянский сыр, изготовленный из коровьего молока',
		client = { image = 'mocarella.png' },
	},

	['spaghetti'] = {
		label = 'Спагетти Аглио',
		weight = 220,
		stack = true,
		close = false,
		description = 'Нежное и ароматное блюдо. Просто и изысканно',
		client = { image = 'spaghetti.png' },
	},

	['pack_spaghetti'] = {
		label = 'Пачка спагетти',
		weight = 220,
		stack = true,
		close = false,
		description = 'Идеальная текстура, насыщенный вкус, готовится быстро',
		client = { image = 'pack_spaghetti.png' },
	},

	['garlic'] = {
		label = 'Чеснок',
		weight = 30,
		stack = true,
		close = false,
		description = 'Обыкновенный чеснок, для приготовления блюд',
		client = { image = 'garlic.png' },
	},

	['olive_oil'] = {
		label = 'Оливковое масло',
		weight = 100,
		stack = true,
		close = false,
		description = 'Масло из свежих оливок, для приготовления блюд',
		client = { image = 'olive_oil.png' },
	},

	['rizotto'] = {
		label = 'Ризотто',
		weight = 220,
		stack = true,
		close = false,
		description = 'Изысканное итальянское блюдо из риса',
		client = { image = 'rizotto.png' },
	},

	['mushrooms'] = {
		label = 'Грибы',
		weight = 30,
		stack = true,
		close = false,
		description = 'Грибы шампиньоны',
		client = { image = 'mushrooms.png' },
	},

	['dough'] = {
		label = 'Тесто',
		weight = 50,
		stack = true,
		close = false,
		description = 'Тесто для пиццы',
		client = { image = 'dough.png' },
	},

	['fish_tomato'] = {
		label = 'Запеченная рыба с томатами',
		weight = 120,
		stack = true,
		close = false,
		description = 'Запечённая сочная рыба с жареными помидорами и ароматным соусом',
		client = { image = 'fish_tomato.png' },
	},

	['jerk_chicken'] = {
		label = 'Джерк наггетсы',
		weight = 210,
		stack = true,
		close = false,
		description = 'Традиционное ямайское блюдо с острым маринадом и ароматным дымным вкусом',
		client = { image = 'jerk_chicken.png' },
	},

	['omelette'] = {
		label = 'Омлет Ямайка',
		weight = 100,
		stack = true,
		close = false,
		description = 'Яркий и ароматный омлет с пряностями',
		client = { image = 'omelette.png' },
	},

	['pancakes_corn'] = {
		label = 'Кукурузные блинчики',
		weight = 100,
		stack = true,
		close = false,
		description = 'Нежные, ароматные, с хрустящей корочкой, идеально подходят для сладких и солёных начинок',
		client = { image = 'pancakes_corn.png' },
	},

	['pizza_margarita'] = {
		label = 'Пицца Маргарита',
		weight = 450,
		stack = true,
		close = false,
		description = 'Традиционная итальянская пицца с томатами, моцареллой и базиликом',
		client = { image = 'pizza_margarita.png' },
	},

	['meatballs_spaghetti'] = {
		label = 'Спагетти с фрикадельками',
		weight = 220,
		stack = true,
		close = false,
		description = 'Сочные мясные шарики инежное спагетти с ароматным томатным соусом',
		client = { image = 'meatballs_spaghetti.png' },
	},

	['parmigian_sliders'] = {
		label = 'Бургер Пармиджано',
		weight = 90,
		stack = true,
		close = false,
		description = 'Бургер с куриной котлетой, моцареллой, салатом и соусом Цезарь',
		client = { image = 'parmigian_sliders.png' },
	},

	['beef_sandwich'] = {
		label = 'Сэндвич с говядиной',
		weight = 110,
		stack = true,
		close = false,
		description = 'Сочный итальянский сэндвич с нежной говядиной, ароматными специями и свежей булочкой',
		client = { image = 'beef_sandwich.png' },
	},

	['meatball_pizza'] = {
		label = 'Пицца с фрикадельками',
		weight = 450,
		stack = true,
		close = false,
		description = 'Пицца с ароматными фрикадельками, томатным соусом и расплавленным сыром',
		client = { image = 'meatball_pizza.png' },
	},

	['baked_ziti'] = {
		label = 'Зити',
		weight = 190,
		stack = true,
		close = false,
		description = 'Нежные трубочки зити, запечённые в томатном соусе с мясным рагу и тягучим сыром',
		client = { image = 'baked_ziti.png' },
	},

	['freeze_meatballs'] = {
		label = 'Замороженные фрикадельки',
		weight = 150,
		stack = true,
		close = false,
		description = 'Замороженные фрикадельки: быстрый обед, идеальны для супа или просто пожарить на сковороде',
		client = { image = 'freeze_meatballs.png' },
	},

	['pasta_ziti'] = {
		label = 'Паста зити',
		weight = 300,
		stack = true,
		close = false,
		description = 'Идеальны для супа или просто пожарить на сковороде',
		client = { image = 'pasta_ziti.png' },
	},

	['rikotta'] = {
		label = 'Рикотта',
		weight = 230,
		stack = true,
		close = false,
		description = 'Нежный итальянский сыр с мягкой текстурой и нежным сливочным вкусом',
		client = { image = 'rikotta.png' },
	},

	['spices'] = {
		label = 'Специи',
		weight = 120,
		stack = true,
		close = false,
		description = 'Придают блюдам аромат, вкус и насыщенность, делая их неповторимыми',
		client = { image = 'spices.png' },
	},

	['tomato_sauce'] = {
		label = 'Томатный соус',
		weight = 230,
		stack = true,
		close = false,
		description = 'Яркий, ароматный, идеально подходит для пасты, пиццы и других блюд',
		client = { image = 'tomato_sauce.png' },
	},

	['pickled_peppers'] = {
		label = 'Маринованные перцы',
		weight = 120,
		stack = true,
		close = false,
		description = 'Острые и хрустящие, добавляют пикантность и яркий вкус блюдам',
		client = { image = 'pickled_peppers.png' },
	},

	['chicken_fried_rice'] = {
		label = 'Жареный рис с курицей',
		weight = 120,
		stack = true,
		close = false,
		description = 'Ароматное, сытное блюдо с овощами и соевым соусом',
		client = { image = 'chicken_fried_rice.png' },
	},

	['asianomelette'] = {
		label = 'Азиатский омлет',
		weight = 120,
		stack = true,
		close = false,
		description = 'Сытный омлет с рыбой',
		client = { image = 'asianomelette.png' },
	},

	['pinacolada'] = {
		label = 'Коктейль "Пинаколада"',
		weight = 500,
		stack = true,
		close = true,
		description = 'Тропический коктейль из рома, ананасового сока и кокосового молока, освежающий, сладкий, с ярким фруктовым вкусом',
		client = { image = 'pinacolada.png' },
	},

	['juice-pineapple'] = {
		label = 'Ананасовый сок (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Ароматный, слегка терпкий напиток, богатый витаминами и минералами, хорошо освежает и улучшает пищеварение',
		client = { image = 'juice-pineapple.png' },
	},

	['coco-milk'] = {
		label = 'Кокосовое молоко (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Молочно-белая, непрозрачная жидкость из мякоти кокоса, с насыщенным вкусом, богато жирами, витаминами и минералам',
		client = { image = 'coco-milk.png' },
	},

	['blue-laguna'] = {
		label = 'Коктейль "Голубая лагуна"',
		weight = 500,
		stack = true,
		close = true,
		description = 'Освежающий коктейль ярко-голубого цвета на основе водки, ликёра и газировки, с цитрусовым вкусом',
		client = { image = 'blue-laguna.png' },
	},

	['sex-beach'] = {
		label = 'Коктейль "Секс на пляже"',
		weight = 500,
		stack = true,
		close = true,
		description = 'Яркий, сладкий коктейль с водкой, апельсиновым и клюквенным соком, освежающий, фруктовый, летний вкус',
		client = { image = 'sex-beach.png' },
	},

	['otvertka'] = {
		label = 'Коктейль "Отвертка"',
		weight = 500,
		stack = true,
		close = true,
		description = 'Алкогольный напиток, состоящий из водки и апельсинового сока, отличающийся простотой приготовления и освежающим вкусом',
		client = { image = 'otvertka.png' },
	},

	['bloody-marry'] = {
		label = 'Коктейль "Кровавая мэри"',
		weight = 500,
		stack = true,
		close = true,
		description = 'Коктейль с водкой, томатным соком, специями, лимоном, острым вкусом, пикантный, освежающий, овощной, классика баров',
		client = { image = 'bloody-marry.png' },
	},

	['tomato-drink'] = {
		label = 'Томатный сок (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Густой, насыщенный, кисло-сладкий напиток, богат витаминами, минералами, освежает, питателен, полезен для здоровья',
		client = { image = 'tomato-drink.png' },
	},

	['mohito'] = {
		label = 'Коктейль "Мохито"',
		weight = 500,
		stack = true,
		close = true,
		description = 'Освежающий коктейль с ромом, лаймом, мятой, сахаром, содовой, льдом; сладкий, цитрусовый, мятный, летний вкус, кубинское происхождение',
		client = { image = 'mohito.png' },
	},

	['lime-juice'] = {
		label = 'Лимонный сок (для коктейлей)',
		weight = 330,
		stack = true,
		close = true,
		description = 'Натуральный напиток из лимонов, освежает, тонизирует, укрепляет иммунитет, широко используется в кулинарии и напитках',
		client = { image = 'lime-juice.png' },
	},

	['long-island'] = {
		label = 'Коктейль "Лонг айленд"',
		weight = 500,
		stack = true,
		close = true,
		description = 'Крепкий коктейль с водкой, джином, ромом, текилой, ликёром, лимонным соком, колой; сладко-кислый, освежающий вкус',
		client = { image = 'long-island.png' },
	},

	['kebab'] = {
		label = 'Люля-кебаб',
		weight = 250,
		stack = true,
		close = true,
		description = 'Восточное блюдо из мясного фарша с луком и специями, нанизанного на шампур и зажаренного на углях',
		client = { image = 'kebab.png' },
	},

	['doner'] = {
		label = 'Дёнер',
		weight = 250,
		stack = true,
		close = true,
		description = 'Традиционный турецкий стритфуд: мясо, обжаренное на вертикальном гриле, нарезается, укладывается в хлеб с овощами и соусом',
		client = { image = 'doner.png' },
	},

	['lavash'] = {
		label = 'Лаваш',
		weight = 50,
		stack = true,
		close = true,
		description = 'Обыкновенный лаваш',
		client = { image = 'lavash.png' },
	},

	['fakeplate'] = {
		label = 'Номер-дубликат',
		weight = 0,
		stack = false,
		close = true,
		description = 'Используется для изменения номерного знака или возврата к исходному',
		client = { image = 'image1.png' },
	},

	['torque_wrench'] = {
		label = 'Балонный ключ',
		weight = 500,
		stack = false,
		close = true,
		description = 'Автомобильный балонный ключ',
		client = { image = 'torque_wrench.png' },
	},

	['wheel'] = {
		label = 'Колесо',
		weight = 3300,
		stack = false,
		close = false,
		description = 'Обыкновенное колесо',
		client = { image = 'wheel.png' },
	},

	['halfrims'] = {
		label = 'Неполный комлпект колес',
		weight = 6300,
		stack = false,
		close = false,
		description = 'Неполный комлпект колес',
		client = { image = 'halfrims.png' },
	},

	['low_printer'] = {
		label = 'Принтер',
		weight = 120,
		stack = true,
		close = false,
		client = { image = 'low_printer.png' },
	},

	['paper'] = {
		label = 'Бумага',
		weight = 120,
		stack = false,
		close = false,
		client = { image = 'printer_paper.png' },
	},

	['print_document'] = {
		label = 'Распечатаный документ',
		weight = 120,
		stack = false,
		close = false,
		client = { image = 'print_document.png' },
	},

	['basketball_hoop'] = {
		label = 'Баскетбольное кольцо',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Баскетбольное кольцо для установки на улице или в спортивном зале',
		client = { image = 'basketball_hoop.png' },
	},

	['basketball'] = {
		label = 'Баскетбольный Мяч',
		weight = 0,
		stack = true,
		close = true,
		description = 'Баскетбольный мяч для игры в баскетбол',
		client = { image = 'basketball.png' },
	},

	['metal_wand'] = {
		label = 'Металлодетектор',
		weight = 740,
		stack = true,
		close = true,
		client = { image = 'metal_wand.png' },
	},

	['zelda'] = {
		label = 'Катридж Zelda',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой Zelda',
	},

	['castlevaniaadventure'] = {
		label = 'Катридж Castlevania: The Adventure',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой Castlevania: The Adventure',
	},

	['сontra'] = {
		label = 'Катридж Contra',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой Contra',
	},

	['ducktales'] = {
		label = 'Катридж Duck Tales',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой Duck Tales',
	},

	['hugo'] = {
		label = 'Катридж Hugo',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой Hugo',
	},

	['lionking'] = {
		label = 'Катридж The Lion King',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой The Lion King',
	},

	['spiderman'] = {
		label = 'Катридж Spider-Man',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой Spider-Man',
	},

	['tetris'] = {
		label = 'Катридж Tetris',
		weight = 100,
		stack = true,
		close = true,
		description = 'Катридж для приставки GameBoy с игрой Tetris',
	},

	['gameboy'] = {
		label = 'Игровая приставка GameBoy',
		weight = 200,
		stack = true,
		close = true,
		description = 'Популярная игровая приставка GameBoy. Удобно помещается в карман, поддерживает более 900 игр',
		client = { image = 'gameboy.png' },
	},

	['pinnes-b'] = {
		label = 'Пиво Pinnes',
		weight = 500,
		stack = true,
		close = true,
		description = 'Может, он у тебя не первый, но точно последний. Он – лучший в своём роде',
		client = { image = 'pinnes-b.png' },
	},

	['oldf-wh-m'] = {
		label = 'Ирландский виски (для мини-бара)',
		weight = 350,
		stack = true,
		close = true,
		description = 'Классика, прошедшая проверку временем. С ним, Вы и есть Old Money. Маленкая бутылка для мини-бара',
		client = { image = 'oldf-wh-m.png' },
	},

	['oldf-wh'] = {
		label = 'Ирландский виски',
		weight = 500,
		stack = true,
		close = true,
		description = 'Классика, прошедшая проверку временем. С ним, Вы и есть Old Money',
		client = { image = 'oldf-wh.png' },
	},

	['c-old'] = {
		label = 'Коктейль OldFashioned',
		weight = 500,
		stack = true,
		close = true,
		description = 'Классика, прошедшая проверку временем. С ним, Вы и есть Old Money',
		client = { image = 'c-old.png' },
	},

	['irish-c'] = {
		label = 'Ирландский кофе',
		weight = 500,
		stack = true,
		close = true,
		description = 'Взбодрит с утра, снимет стресс днём, согреет вечером. Разве что в лоб не поцелует, но можно проверить?',
		client = { image = 'irish-c.png' },
	},

	['boxty'] = {
		label = 'Боксти',
		weight = 250,
		stack = true,
		close = true,
		description = 'Если вы не можете приготовить Боксти, вы никогда не получите мужчину! - старая ирландская поговорка',
		client = { image = 'boxty.png' },
	},

	['i-ragu'] = {
		label = 'Ирландское рагу',
		weight = 350,
		stack = true,
		close = true,
		description = 'Порадует даже самый искушенный желудок, не хуже Рататуя. Одобрено Реми',
		client = { image = 'i-ragu.png' },
	},

	['creme'] = {
		label = 'Сливки',
		weight = 200,
		stack = true,
		close = true,
		description = 'Обыкновенные, 40% сливки',
		client = { image = 'creme.png' },
	},

	['raw-beef'] = {
		label = 'Сырая говядина',
		weight = 600,
		stack = true,
		close = true,
		description = 'Сырая говядина для приготовления кулинарных изысков',
		client = { image = 'raw-beef.png' },
	},

	['carrot'] = {
		label = 'Морковь',
		weight = 150,
		stack = true,
		close = true,
		description = 'Марковь, в упаковке. Для приготовления блюд разной сложности. Можно, в целом, и просто погрызть',
		client = { image = 'carrot.png' },
	},

	['coffee-roasted'] = {
		label = 'Зерна кофе',
		weight = 200,
		stack = true,
		close = true,
		description = 'Подходит для ценителей крепкого зернового кофе с глубоким, насыщенным вкусом и ароматом',
		client = { image = 'coffee-roasted.png' },
	},

	['sugar'] = {
		label = 'Сахар',
		weight = 50,
		stack = true,
		close = true,
		description = 'Просто сахар, просто сладкий',
		client = { image = 'sugar.png' },
	},

	['solod'] = {
		label = 'Ячмень (Солод)',
		weight = 150,
		stack = true,
		close = true,
		description = 'Зерна ячменя, прошедшие термическую обработку',
		client = { image = 'solod.png' },
	},

	['meetdish'] = {
		label = 'Мясная тарелка',
		weight = 2,
		stack = true,
		close = true,
		description = 'Классическая мясная тарелка с ветчиной, оливками и помидорками черри',
		client = { image = 'meetdish.png' },
	},

	['ham'] = {
		label = 'Ветчина',
		weight = 120,
		stack = true,
		close = true,
		description = 'Просто ветчина из упаковки. Где-то плачет одна коровка',
		client = { image = 'ham.png' },
	},

	['olive'] = {
		label = 'Оливки',
		weight = 120,
		stack = true,
		close = true,
		description = 'Стеклянная банка с оливками',
		client = { image = 'olive.png' },
	},

	['teachina1'] = {
		label = 'Чай Дя Хун Ло',
		weight = 60,
		stack = true,
		close = true,
		description = 'Красный китайский чай из провинции Юньнань',
		client = { image = 'teachina1.png' },
	},

	['teachina2'] = {
		label = 'Чай Лун Цзин Си Ху',
		weight = 60,
		stack = true,
		close = true,
		description = 'Зелёный, с насыщенным ароматом, маслянистым вкусом, цветочными нотами и лёгкой горчинкой, освежает и бодрит',
		client = { image = 'teachina2.png' },
	},

	['teachina3'] = {
		label = 'Чай Да Хун Пао',
		weight = 60,
		stack = true,
		close = true,
		description = 'Тёмный улун с насыщенным, сладковатым вкусом, пряным ароматом, оттенками шоколада, меда, орехов. Расслабляет, бодрит, улучшает настроение и здоровье.',
		client = { image = 'teachina3.png' },
	},

	['cup_china1'] = {
		label = 'Чашка чая Дя Хун Ло',
		weight = 150,
		stack = true,
		close = true,
		description = 'Красный китайский чай из провинции Юньнань',
		client = { image = 'cup.png' },
	},

	['cup_china2'] = {
		label = 'Чашка чая Лун Цзин Си Ху',
		weight = 150,
		stack = true,
		close = true,
		description = 'Зелёный, с насыщенным ароматом, маслянистым вкусом, цветочными нотами и лёгкой горчинкой, освежает и бодрит',
		client = { image = 'cup.png' },
	},

	['cup_china3'] = {
		label = 'Чашка чая Да Хун Пао',
		weight = 150,
		stack = true,
		close = true,
		description = 'Тёмный улун с насыщенным, сладковатым вкусом, пряным ароматом, оттенками шоколада, меда, орехов. Расслабляет, бодрит, улучшает настроение и здоровье.',
		client = { image = 'cup.png' },
	},

	['wok'] = {
		label = 'Вок с курицей',
		weight = 150,
		stack = true,
		close = true,
		description = 'Вкуснешая лапша в трациционном приготовлении',
		client = { image = 'wok.png' },
	},

	['tabasco'] = {
		label = 'Соус Табаско',
		weight = 120,
		stack = true,
		close = true,
		description = 'Острый соус Табаско',
		client = { image = 'tabasco.png' },
	},

	['cane'] = {
		label = 'Трость',
		weight = 500,
		stack = true,
		close = false,
		description = 'Отдай трость Лестеру, животное!',
		client = { image = 'cane.png' },
	},

	['walking_stick'] = {
		label = 'Трость',
		weight = 500,
		stack = true,
		close = false,
		description = 'Когда вы хотите выглядеть мудрым, угрожайте голубям или просто тыкайте туда, куда не следует',
		client = { image = 'walking_stick.png' },
	},

	['staff'] = {
		label = 'Staff',
		weight = 500,
		stack = true,
		close = false,
		description = 'Украдено у великого волшебника Ибтага',
		client = { image = 'staff.png' },
	},

	['raw_stake'] = {
		label = 'Сырой стэйк',
		weight = 750,
		stack = true,
		close = true,
		description = 'Мраморный говяжий стэйк. Подойдет для изысканых блюд',
		client = { image = 'raw_stake.png' },
	},

	['stake'] = {
		label = 'Стэйк',
		weight = 600,
		stack = true,
		close = true,
		description = 'Готовый стэйк из мраморной говядины. Не то чтобы по вкусу вкусно, но по сути - вкусно!',
		client = { image = 'stake.png' },
	},

	['police_tape'] = {
		label = 'Полицейская лента',
		weight = 100,
		stack = true,
		close = true,
		description = 'Полицейская лента. Длина: 30 метров',
		client = { image = 'police_tape.png' },
	},

	['kq_drifttire'] = {
		label = 'Дрифт-шины',
		weight = 1500,
		stack = true,
		close = true,
		description = ' Повышают управляемость в дрифте, увеличивают сцепление при боковом скольжении и снижают износ при экстремальных манёврах',
		client = { image = 'kq_drifttire.png' },
	},

	['kq_regulartire'] = {
		label = 'Обыкновенные шины',
		weight = 2000,
		stack = true,
		close = true,
		description = 'Подходят для большинства транспортных средств, не дают особых бонусов, но надёжны и долговечныe',
		client = { image = 'kq_regulartire.png' },
	},

	['kq_carjack'] = {
		label = 'Домкрат',
		weight = 3000,
		stack = true,
		close = true,
		description = 'Компактное механическое или гидравлическое устройство для подъёма автомобиля при ремонте или замене колёс',
		client = { image = 'kq_carjack.png' },
	},

	['ingridients'] = {
		label = 'Компоненты для блюд',
		weight = 150,
		stack = true,
		close = true,
		description = 'Натуральные или обработанные продукты, ингредиенты, компоненты для приготовления блюд',
		client = { image = 'ingridients.png' },
	},

	['alchogol'] = {
		label = 'Компоненты для алкоголя',
		weight = 150,
		stack = true,
		close = true,
		description = 'Разнообразные спиртные напитки, используемые как основа или ароматизатор для создания сбалансированных, вкусовых и визуально привлекательных миксов',
		client = { image = 'alchogol.png' },
	},

	['drinks'] = {
		label = 'Компоненты для напитков',
		weight = 150,
		stack = true,
		close = true,
		description = 'Натуральные соки, сиропы, фруктовые пюре, газированная вода, травы, специи, лёд и декор, придающие освежающий вкус и оригинальный вид безалкогольным напиткам',
		client = { image = 'drinks.png' },
	},

	['carkeys'] = {
		label = 'Ключи от автомобиля',
		weight = 150,
		stack = true,
		close = true,
		description = 'Связка ключей для автомобиля',
		client = { image = 'vehiclekeys.png' },
	},

	['police_report'] = {
    label = 'Полицейский отчёт',
    weight = 140,
    stack = true,
    description = "Отчёт о полицейском инциденте"
},
	['evidence_report'] = {
		label = 'Отчёт с доказательствами',
		weight = 150,
		stack = true,
		description = "Отчёт, содержащий доказательства по полицейскому делу"
	},
	['police_bodycam'] = {
		label = 'Нагрудная камера',
		weight = 950,
		stack = true,
		description = "Нагрудная камера для полицейских"
	},
	['police_shield'] = {
		label = 'Полицейский щит',
		weight = 3500,
		stack = true,
		description = "Щит для полицейских"
	},
	['police_snakecam'] = {
		label = 'Камера-змейка',
		weight = 700,
		stack = true,
		description = "Камера-змейка для использования полицейскими"
	},
	['evidence_camera'] = {
		label = 'Камера для доказательств',
		weight = 900,
		stack = true,
		description = "Камера для сбора доказательств, используемая полицейскими"
	},
	['breathalyzer'] = {
		label = 'Алкотестер',
		weight = 300,
		stack = true,
		description = "Алкотестер для проверки опьянения"
	},
	['fingerprint_scanner'] = {
		label = 'Сканер отпечатков',
		weight = 450,
		stack = true,
		description = "Сканер отпечатков пальцев для полицейских"
	},
	['grappler'] = {
		label = 'Грэпплер',
		weight = 2500,
		stack = true,
		description = "Устройство для захвата автомобиля, используемое полицейскими"
	},
	['handcuffs'] = {
		label = 'Наручники',
		weight = 350,
		stack = true,
		description = "Наручники для задержания подозреваемых"
	},
	['stab_sticks'] = {
		label = 'Шипы для колёс',
		weight = 1000,
		stack = true,
		description = "Шипы для прокалывания шин, используемые полицейским"
	},
	['gsr'] = {
		label = 'Сканер cледов пороха',
		weight = 190,
		stack = true,
		description = "Сканер для проверки следов пороха на руках подозреваемого"
	},
	['blood_test'] = {
		label = 'Анализ крови',
		weight = 170,
		stack = true,
		description = "Анализ крови, используемый как доказательство"
	},

	['watertank'] = {
    label = 'Балон с водой',
    weight = 1900,
    stack = true,
    close = true,
    description = nil
},


}
