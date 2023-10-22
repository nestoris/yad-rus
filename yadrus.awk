#!/usr/bin/gawk -f
# Этот скрипт позволяет в три этапа делать почти мгновенный перевод любого файла po в данном случае с украинского на русский.
# В данном скрипте есть функции вытаскивания строк из исходника локализации в текстовый файл для дальнейшего перевода их через любой переводчик.
# Можно с таким же успехом перевести с любого языка на любой другой. Он просто вытаскивает строки из uk.po, а потом их впихивает в ru.po посредством txt и docx

BEGIN{
getpo() # скачать uk.po
po2txt() # вытащить строки msgstr
txt2po() # запихнуть строки обратно, но уже русифицированные
}

function getpo(){
	cmd="curl -s https://raw.githubusercontent.com/v1cont/yad/master/po/uk.po"
	#cmd="wget https://raw.githubusercontent.com/v1cont/yad/master/po/uk.po"
	while((cmd|getline)>0){
		ukpo=ukpo (ukpo?"\n":"") $0
	}
	print ukpo > "uk.po"
	close("uk.po")
	close(cmd)
	print "uk.po вроде, скачан.Проверь."
}

function po2txt(	i){
	rs=RS
	RS="\n\n"
	while((getline<"uk.po")>0){
		i++
		if(match($0,/^(.*)\nmsgid "(.*)"\nmsgstr "(.*)"/,a[i])){
			print a[i][3] "\n" > "uk.txt"
		}
	}
	close("uk.po")
	close("uk.txt")
	RS=rs
	print "Строки из файла PO извлечены в uk.txt"
}

function txt2po(	i){
	print "Преобразуй файл 'uk.txt' в 'uk.docx', переведи docx гугл-переводчиком, потом сохрани и преобразуй в 'ru.txt' (проследите, чтобы вконце файла была пустая строка!), или нажми Ctrl+C для отмены."
	if(getline choice < "/dev/stdin"){
		i=0
		rs=RS
		RS="\n\n"
		while((getline<"ru.txt")>0){
			i++
			a[i][3]=$0
		}
		RS=rs
		gsub("Ukrainian","Russian",a[1][1])
		gsub("Victor Ananjevsky","Google Translator",a[1][1])
		gsub("ananasik","translator",a[1][1])
		gsub("Последний переводчик: Виктор Ananjevsky <ananasik@gmail.com>","Last-Translator: Google Translator <translator@gmail.com>",a[1][3])

		for(i in a){
			print a[i][1] "\n" "msgid \"" a[i][2] "\"\n" "msgstr \"" a[i][3] "\"" (i<length(a)?"\n":"") > "ru.po"
		}
	}else{
		print "Отменено"
	}
}
