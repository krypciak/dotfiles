#!/bin/bash

arch_java_install() {
    echo 'jdk-openjdk'
    if [ "$TYPE" != "iso" ]; then
        echo 'jdk17-openjdk jdk8-openjdk'
    fi
}

arch_java_configure() {
    if [ "$TYPE" != "iso" ]; then
        archlinux-java set java-17-openjdk
    fi
}
