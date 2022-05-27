#!/bin/bash
clear

echo "======GERADOR DE URA======"
echo "Digite o nome da ura (este nome sera usado para contexto do asterisk)"
read nome_ura

echo "Digite quantas opções"
read opcoes_ura

saudacao='same=> n,ExecIfTime(00:00-11:59,*,*,*?Read(OPCAO,'$nome_ura'/menu_bom_dia,1,,1,5))
same=> n,ExecIfTime(12:00-17:59,*,*,*?Read(OPCAO,'$nome_ura'/menu_boa_tarde,1,,1,5))
same=> n,ExecIfTime(17:59-23:59,*,*,*?Read(OPCAO,'$nome_ura'/menu_boa_noite,1,,1,5))'

inicio='exten => s,1,NoOp(LIGACAO DE ${CALLERID(num)} PARA ${EXTEN} NO CANAL ${CHANNEL})
same=> n,Answer()'
op_inicial=1

echo "Possui saudacao (BOM DIA/BOA TARDE/BOA NOITE) ?  (s/n)"
read op_saudacao
case $op_saudacao in
	s) op_saudacao=$saudacao;;
	n) op_saudacao='same=> n,ExecIfTime(00:00-23:59,*,*,*?Read(OPCAO,'$nome_ura'/menu_padrao,1,,1,5)';;
esac
clear
echo "=============================================================="
echo "[ura_$nome_ura]"
echo ";INICIO"
echo "$inicio"
echo ""
echo ";SAUDACAO"
echo "$op_saudacao"
echo ""
echo ";OPCOES ATIVAS"
while [ $op_inicial -le $opcoes_ura ]
do
	echo 'same => n,ExecIf($["${OPCAO}"="'$op_inicial'"]?goto(default,100001,1))  ;< alterar o contexto e a extensao ';
	let op_inicial=$op_inicial+1
done
echo""
echo ";OPCOES DESATIVADAS"
let op_inicial=$op_inicial-1

echo 'same=> n,ExecIf($["${OPCAO}" > "'$op_inicial'"]?goto(ura_'$nome_ura',s,1))'
echo 'same=> n,ExecIf($["${OPCAO}" = "*"]?goto(ura_'$nome_ura',s,1))
same=> n,ExecIf($["${OPCAO}" = "#"]?goto(ura_'$nome_ura',s,1))
same=> n,ExecIf($["${OPCAO}" = "0"]?goto(ura_'$nome_ura',s,1))'
echo "


=============================================================="
echo "=========================IMPORTANTE==========================="
echo "=============================================================="
echo '1 - Criar a pasta dos audios dentro da pasta do asterisk'
echo 'mkdir /var/lib/asterisk/sounds/'$nome_ura' ; chmod 777 /var/lib/asterisk/sounds/'$nome_ura
echo "2 - Fazer o upload dos arquivos e converter com"
echo 'sox arquivos.wav -r 8000 -c 1 /var/lib/asterisk/sounds/'$nome_ura'/arquivo_ura.wav'
echo "3 - Atualize na linha do read o nome do arquivo de audio"
echo "4 - Declare no extension.conf
#tryinclude diretorio/ura_cliente.conf"
echo "5 - Por ultimo
asterisk -rx 'dialplan reload'"

cowsay só testar jovem
