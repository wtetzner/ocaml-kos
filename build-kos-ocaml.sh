#!/bin/bash

set -e

ocaml_repo="$1"

# export SAK_CC="cc"
# export SAK_LD="ld"
# export SAK_AR="ar"
# export SAK_AS="as"

export CC="kos-cc -I${KOS_BASE}/include"
export LD="kos-ld"
export AR="kos-ar"
export AS="kos-as"

cd "${ocaml_repo}"

OCAML_BASE="${KOS_BASE}/../ocaml"
mkdir -p "${OCAML_BASE}"
OCAML_BASE="$(realpath "${OCAML_BASE}")"

./configure --prefix="${OCAML_BASE}" --enable-warn-error --host sh-elf --target sh-elf --build aarch64-apple-darwin --disable-unix-lib

echo "CFLAGS: ${CFLAGS}"

SAK_CC="/usr/bin/cc"

SAK_CFLAGS="-O2 -fno-strict-aliasing -fwrapv  -g -Wall -Wint-conversion -Wstrict-prototypes -Wold-style-definition -Werror -fno-common -Wvla  -I./runtime  -D_FILE_OFFSET_BITS=64  -DCAMLDLLIMPORT= -DIN_CAML_RUNTIME -DCAMLDLLIMPORT= -DIN_CAML_RUNTIME "

SAK_LINK="${SAK_CC} -O2 -fno-strict-aliasing -fwrapv  -g -Wall -Wint-conversion -Wstrict-prototypes -Wold-style-definition -Werror -fno-common -Wvla -o \$(1) \$(2)"

export LIBDIR="${OCAML_BASE}/lib/ocaml"

make -j16 \
     V_MKEXE="" \
     LIBDIR="${OCAML_BASE}/lib/ocaml" \
     SAK_CC="${SAK_CC}" \
     SAK_LINK="${SAK_LINK}" \
     SAK_CFLAGS="${SAK_CFLAGS}"
 #runtime/libcamlrun.a
