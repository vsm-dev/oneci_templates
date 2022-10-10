﻿
#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПрочитатьСтрокуJSONВДеревоЗначенийНаСервере()
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	КоллекцияJSON = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	ЗаполнитьДеревоJSON(КоллекцияJSON);
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьСтрокуJSONВДеревоЗначений(Команда)
	ПрочитатьСтрокуJSONВДеревоЗначенийНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТекущаяДатаВJSONНаСервере()
	КоллекцияJSON = Новый Структура("datetime", ТекущаяДатаСеанса());
	
	ПараметрыJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыJSON);
	ЗаписатьJSON(ЗаписьJSON, КоллекцияJSON, Новый НастройкиСериализацииJSON);
	СтрокаJSON = ЗаписьJSON.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяДатаВJSON(Команда)
	ТекущаяДатаВJSONНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФуннкции

&НаСервере
Функция ЗаполнитьСтрокиДереваJSON(КоллекцияJson, ТекущаяСтрокаДерева, ИндексЭлементаМассива = 0)
	Для Каждого Элемент Из КоллекцияJson Цикл
		ДочерняяСтрокаДерева = ТекущаяСтрокаДерева.Строки.Добавить();
		// коллекция может быть либо массивом, либо структурой/соответствием
		Если ТипЗнч(КоллекцияJson) = Тип("Массив") Тогда 
			ДочерняяСтрокаДерева.Ключ = СтрШаблон("[%1]", ИндексЭлементаМассива);
			ИндексЭлементаМассива = ИндексЭлементаМассива + 1;
			Значение = Элемент; // элементы массива: примитивы, структуры/соответствия, массивы
		Иначе // коллекция - структура/соответствие, элементы - ключ и значение
			ДочерняяСтрокаДерева.Ключ = Элемент.Ключ;
			Значение = Элемент.Значение; // значения: примитивы, структуры/соответствия, массивы
		КонецЕсли;
		
		Если ТипЗнч(Значение) = Тип("Соответствие") ИЛИ ТипЗнч(Значение) = Тип("Структура") Тогда
			ДочерняяСтрокаДерева.Значение = СтрШаблон("{%1}", Значение.Количество());
			ДочерняяСтрокаДерева.Тип = "Объект";
			ЗаполнитьСтрокиДереваJSON(Значение, ДочерняяСтрокаДерева);
		ИначеЕсли ТипЗнч(Значение) = Тип("Массив") Тогда
			ДочерняяСтрокаДерева.Значение = СтрШаблон("[%1]", Значение.Количество());
			ДочерняяСтрокаДерева.Тип = "Массив";
			ЗаполнитьСтрокиДереваJSON(Значение, ДочерняяСтрокаДерева);
		Иначе // примитив
			ДочерняяСтрокаДерева.Значение=Значение;
			ДочерняяСтрокаДерева.Тип = ТипЗнч(Значение);
		КонецЕсли;
	КонецЦикла;
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоJSON(КоллекцияJSON)
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Ключ");
	Дерево.Колонки.Добавить("Значение");
	Дерево.Колонки.Добавить("Тип");
	
	КореньДерева = Дерево.Строки.Добавить();
	КореньДерева.Ключ = "Представление JSON";
	ЗаполнитьСтрокиДереваJSON(КоллекцияJSON, КореньДерева);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоJSON");
КонецПроцедуры

#КонецОбласти