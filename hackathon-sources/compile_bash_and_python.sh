
#!/bin/bash
level=$1
if [ -z "$1" ]; then
    echo "Uso: compile_python.sh <LIVELLO>"
    exit 1
fi

sudo -v
# remove leftovers
rm ./evaluate_level"$level"
rm ./level"$level"

#compile sh
shc -Sr -f level"$level".sh

#compile python
mkdir ../compile
cp evaluate_level"$level".py ../compile/evaluate_level"$level".py
cd ../compile
/root/.local/share/pipx/venvs/pyinstaller/bin/pyinstaller --onefile ./evaluate_level"$level".py
cd ../SHARED
mv ../compile/evaluate_level"$level".py evaluate_level"$level".py
mv ../compile/dist/evaluate_level"$level" evaluate_level"$level"

#clean
rm ./level"$level".sh.x.c
mv ./level"$level".sh.x ./level"$level"
rm -rf  ../compile
