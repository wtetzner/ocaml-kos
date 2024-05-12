
This repository is just to keep track of my work on getting [OCaml](https://github.com/ocaml/ocaml) to build for the Dreamcast (using [KallistiOS](https://github.com/KallistiOS/KallistiOS)).

To get a KOS build setup:
```
./kos-setup.sh ~/ocaml-kos ocaml
```

Checkout OCaml:
```
git clone git@github.com:wtetzner/ocaml.git ~/wip/ocaml
(cd ~/wip/ocaml && git checkout kos-5.1.1)
```

To build the OCaml runtime:
```
(source ~/ocaml-kos/environ.sh && ~/bin/build-kos-ocaml.sh ~/wip/ocaml)
```
