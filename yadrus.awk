#!/usr/bin/gawk -f
#@load "errno"
#@load "filefuncs"
#@load "fnmatch"
#@load "fork"
#@load "gd"
#@load "inplace"
#@load "intdiv"
#@load "json"
#@load "ordchr"
#@load "readdir"
#@load "readfile"
#@load "revoutput"
#@load "revtwoway"
#@load "rwarray"
#@load "select"
#@load "time"

#@include "abspath"
@include "arraytree"
#@include "assert"
#@include "bits2str"
#@include "cliff_rand"
#@include "ctime"
#@include "ftrans"
#@include "getopt"
#@include "gettime"
#@include "group"
#@include "gtk-server"
#@include "have_mpfr"
#@include "ini"
#@include "inplace"
#@include "intdiv0"
#@include "isnumeric"
#@include "join"
#@include "libintl"
#@include "noassign"
#@include "ns_passwd"
#@include "ord"
#@include "passwd"
#@include "processarray"
#@include "quicksort"
#@include "readable"
#@include "readfile"
#@include "rewind"
#@include "round"
#@include "shellquote"
#@include "strtonum"
#@include "walkarray"
#@include "zerofile"

BEGIN{
getpo()
po2txt()
txt2po()
}


function getpo(){
cmd="curl -s https://raw.githubusercontent.com/v1cont/yad/master/po/uk.po"
#cmd="wget https://raw.githubusercontent.com/v1cont/yad/master/po/uk.po"
#print system(cmd)
while((cmd|getline)>0){
ukpo=ukpo (ukpo?"\n":"") $0
}
print ukpo > "uk.po"
close("uk.po")
close(cmd)
print "uk.po вроде, скачан."
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
print "Преобразуй файл 'uk.txt' в 'uk.docx', переведи гугл-переводчиком, потом сохрани и преобразуй в 'ru.txt' (проследите, чтобы вконце файла была пустая строка!), или нажми Ctrl+C для отмены."
if(getline choice < "/dev/stdin"){
i=0
rs=RS
RS="\n\n"
while((getline<"ru.txt")>0){
i++
#print a[i][3] "\n"$0"\n--------------\n"
#print a[i][3] "\n"$0"\n--------------\n"
a[i][3]=$0
}
RS=rs
gsub("Ukrainian","Russian",a[1][1])
gsub("Victor Ananjevsky","Google Translator",a[1][1])
gsub("ananasik","translator",a[1][1])
gsub("Последний переводчик: Виктор Ananjevsky <ananasik@gmail.com>","Last-Translator: Google Translator <translator@gmail.com>",a[1][3])

for(i in a){
if(a[i][1]||a[i][2]||a[i][3]||2==2){
print a[i][1] "\n" "msgid \"" a[i][2] "\"\n" "msgstr \"" a[i][3] "\"" (i<length(a)?"\n":"") > "ru.po"
#print "\"" a[i][3] "\""
}
}

}else{print "Отменено"}
}

