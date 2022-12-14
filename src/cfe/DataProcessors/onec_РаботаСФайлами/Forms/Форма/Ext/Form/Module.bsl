
#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ПутьКФайлуНаКлиентеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выберите файл для обработки";
	Диалог.Фильтр = "TXT (*.txt)|*.txt";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.ПолноеИмяФайла = "";
	Если Диалог.Выбрать() Тогда
		ПутьКФайлуНаКлиенте = Диалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуНаКлиентеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог для сохранения нового файла";
	Диалог.Каталог = "";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Если Диалог.Выбрать() Тогда
		ПутьККаталогуНаКлиенте = Диалог.Каталог;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьФайлСКлиентаНаСервере(Команда)
	Если НЕ ЗначениеЗаполнено(ПутьКФайлуНаКлиенте) ИЛИ НЕ ЗначениеЗаполнено(ПутьККаталогуНаКлиенте) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Операция не может быть выполнена.
		|Проверьте заполнение полей ""Путь к файлу на сервере"" и ""Путь к каталогу на сервере"".";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьФайлСКлиентаНаСервереЗавершение", ЭтотОбъект);
	НачатьПомещениеФайлаНаСервер(ОповещениеОЗавершении, , , "", ПутьКФайлуНаКлиенте, УникальныйИдентификатор);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФуннкции

&НаКлиенте
Процедура ЗаполнитьФайлСКлиентаНаСервереЗавершение(ОписаниеПомещенногоФайла, ДополнительныеПараметры) Экспорт
	АдресНовогоФайлаВХранилище = ОбработатьПереданныйФайл(ОписаниеПомещенногоФайла.Адрес);
	ПутьКНовомуФайлу = ПутьККаталогуНаКлиенте + "/oneCi_test.txt";
	НачатьПолучениеФайлаССервера(, АдресНовогоФайлаВХранилище, ПутьКНовомуФайлу);
КонецПроцедуры

&НаСервере
Функция ОбработатьПереданныйФайл(АдресФайлаВХранилище)
	ДанныеДокумента = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
	ИмяФайла = КаталогВременныхФайлов() + "oneCi_test.txt";
	ДанныеДокумента.Записать(ИмяФайла);
	
	Чтение = Новый ЧтениеТекста;
	Чтение.Открыть(ИмяФайла);
	ТекстФайла = "Файл был прочитан " + Формат(ТекущаяДатаСеанса(), "ДФ='yyyy-MM-dd HH:mm'")
		+ Символы.ПС + Чтение.Прочитать();
	Чтение.Закрыть();
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
	КонецПопытки;
	
	Возврат ПоместитьВоВременноеХранилище(ТекстФайла, УникальныйИдентификатор);
КонецФункции

#КонецОбласти