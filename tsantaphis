#!/data/data/com.termux/files/usr/bin/bash

TSANTAPHIS_ROOT="/data/data/com.termux/files/usr/opt/tsantaphis"
if [[ ! -d "$TSANTAPHIS_ROOT" ]]; then
    TSANTAPHIS_ROOT="$(pwd)"
fi

# Fanamarinana ny fiarovana (Security check)
clear
echo -e "\033[31m────────────────────────────────────────────────────────────\033[0m"
echo -e "\033[32m[#] \033[33mFIAROVANA TSANTAPHIS - FIDIRANA VOAFETRA\033[0m"
echo -e "\033[31m────────────────────────────────────────────────────────────\033[0m"
read -p "$(echo -e '\033[32m[+]\033[36m Ampidiro ny laharana fankatoavana : \033[34m')" auth_input

# Fanamarinana ny laharana (038 70 47 479)
if [[ "$auth_input" != "0387047479" && "$auth_input" != "038 70 47 479" ]]; then
    echo -e "\n\033[31m[!]\033[31m Lahara diso! Tsy manana alalana hampiasa an'ity ianao.\033[0m"
    exit 1
fi

echo -e "\n\033[32m[✓]\033[32m Marina ny laharana. Manokatra an'i Tsantaphis...\033[0m"
sleep 1

if [[ $1 == '-h' || $1 == 'help' ]]; then
    echo "Raha handefa an'i Tsantaphis dia soraty hoe \`Tsantaphis\` ao amin'ny terminal."
    echo
    echo "Fanampiana (Help):"
    echo " -h | help : Asehoy ity menio ity & Mivoaha"
    echo " -c | auth : Jereo ireo kaonty voatahiry"
    echo " -i | ip   : Jereo ireo IP an'ireo niharam-boina"
    echo
elif [[ $1 == '-c' || $1 == 'auth' ]]; then
    cat $TSANTAPHIS_ROOT/auth/usernames.dat 2>/dev/null || {
        echo "Tsy misy kaonty na teny miafina voatahiry hatreto!"
        exit 1
    }
elif [[ $1 == '-i' || $1 == 'ip' ]]; then
    cat $TSANTAPHIS_ROOT/auth/ip.txt 2>/dev/null || {
        echo "Tsy misy adiresy IP voatahiry hatreto!"
        exit 1
    }
else
    cd $TSANTAPHIS_ROOT
    bash ./tsantaphis.sh
fi
