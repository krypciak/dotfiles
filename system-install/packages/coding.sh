#!/bin/sh

arch_coding_install() {
    # TODO: not enough stuff here
    echo 'esbuild git-filter-repo github-cli jdk17-openjdk jdk8-openjdk jdk-openjdk rust typescript-language-server'
}

artix_coding_configure() {
    archlinux-java set java-17-openjdk
}

arch_coding_configure() {
    archlinux-java set java-17-openjdk
}
