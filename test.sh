#!/bin/ash

usecase=$1

case $usecase in

    "generic")
        echo "Test generic installer"
        mkdir $usecase
        cd $usecase
        sh ../install.sh
        cd -
        ;;

    *)
        echo "Test AVD installer"
        mkdir $usecase
        cd $usecase
        sh ../docs/$usecase/install.sh
        cd -
        ;;
esac
