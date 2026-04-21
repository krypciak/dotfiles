#!/bin/bash

arch_cups_install() {
    echo 'cups'
}

arch_cups_configure() {
    systemctl enable cups
}

