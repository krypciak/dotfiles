#!/bin/bash

arch_office_install() {
    echo 'onlyoffice-bin'

    if [ "$TYPE" != 'iso' ]; then
        echo 'libreoffice-fresh  krita'
    fi
}
