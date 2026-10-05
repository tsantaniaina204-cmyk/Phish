#!/data/data/com.termux/files/usr/bin/bash

echo -e "\033[32m[+] Fametrahan'i Tsantaphis eo an-toerana...\033[0m"

# Fanaovana azy ho azo tanterahina (Executable)
chmod +x tsantaphis tsantaphis.sh

# Fametrahana azy ao amin'ny system-bin raha ao Termux
if [[ -d "/data/data/com.termux/files/usr/bin" ]]; then
    cp -f tsantaphis /data/data/com.termux/files/usr/bin/tsantaphis
    mkdir -p /data/data/com.termux/files/usr/opt/tsantaphis
    cp -r . /data/data/com.termux/files/usr/opt/tsantaphis/
    echo -e "\n\033[32m[✓] Vita ny fametrahana! Azonao atao ny manoratra hoe \033[33mTsantaphis\033[32m na aiza na aiza.\033[0m"
else
    echo -e "\n\033[33m[i] Raha tsy ao anaty Termux ianao dia mandehana mivantana amin'ny fampiasana an'i ./tsantaphis.sh\033[0m"
fi
