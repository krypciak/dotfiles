#!/bin/bash

arch_java_install() {
    echo 'jdk17-openjdk jdk8-openjdk jdk-openjdk'
}

arch_java_configure() {
    archlinux-java set java-17-openjdk
}
