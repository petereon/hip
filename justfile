lint:
    ormolu --mode inplace $(find src app test -name '*.hs')
    hlint $(find src app test -name '*.hs')
    cabal-fmt *.cabal -i

lint-watch:
    watchexec -e cabal,hs -c -r 'just lint'

test:
    cabal test

test-watch:
    watchexec -e cabal,hs -c -r 'just test'