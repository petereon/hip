lint:
    ormolu --mode inplace $(find app -name '*.hs')
    hlint app
    cabal-fmt *.cabal -i

lint-watch:
    watchexec -e cabal,hs -c -r 'just lint'

test:
    cabal test

test-watch:
    watchexec -e cabal,hs -c -r 'just test'