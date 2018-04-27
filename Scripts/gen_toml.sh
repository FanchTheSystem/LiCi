
workdir=confd.for.branch.creation/
sourcedir=$workdir/templates/
targetdir=$workdir/conf.d/

for i in $(find $sourcedir -name '*.tmpl')
do
    fn=$(echo $i | sed -e s:$sourcedir::g)
    tn=$(echo $fn | sed -e s:tmpl:toml:g)
    cn=$(echo $fn | sed -e s:tmpl::g)
    dn=$(dirname $fn)

    mkdir -p $targetdir/$dn

    echo '[template]' > $targetdir/$tn
    echo "src = '$tn'" >> $targetdir/$tn
    echo "dest = '$cn'" >> $targetdir/$tn
    echo 'keys = [' >> $targetdir/$tn
    for j in $(grep getv $i|sed -e s/' '//g|cut -f2 -d'"')
    do
        echo "'$j'," >> $targetdir/$tn
    done
    echo ']' >> $targetdir/$tn

done
