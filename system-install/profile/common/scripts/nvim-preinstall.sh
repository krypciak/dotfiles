#!/bin/bash
set +e

wait_time="${1-50000}"

ts_langs="asm bash c c_sharp cmake commonlisp cpp css d desktop diff dockerfile elixir fish fsharp git_config gitattributes gitcommit gitignore go groovy haskell html ini java javascript json jsonc julia kotlin latex lua make markdown nasm nix objdump pascal passwd pem perl php properties proto puppet python ruby rust scss sql toml tsx typescript vim vimdoc vue xml yaml zig hyprlang"

timeout 60s nvim --headless \
    "+Lazy! sync" \
    "+TSInstall $ts_langs" \
    "+MasonToolsUpdate" \
    "+lua vim.defer_fn(function() vim.cmd('qa') end, $wait_time)" >/dev/null 2>&1

set -e
exit 0
