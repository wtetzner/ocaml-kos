#!/bin/bash

set -e

checkout="$1"
commit="$2"
sh_toolchain="${checkout}/sh-elf"
arm_toolchain="${checkout}/arm-eabi"

mkdir -p "${checkout}"
mkdir -p "${sh_toolchain}"
mkdir -p "${arm_toolchain}"

git clone git@github.com:KallistiOS/KallistiOS.git "${checkout}/kos" || echo "Already checked out..."
if [[ -n "${commit}" ]]; then
    (cd "${checkout}/kos" && git fetch origin && git checkout "${commit}")
fi

(cd "${checkout}/kos" && git merge origin/libpthread)

# Enter the dc-chain directory
cd "${checkout}/kos/utils/dc-chain"

if command -v nproc &> /dev/null
then
    logical_cpus=$(nproc)
else
    logical_cpus=$(sysctl -n hw.logicalcpu)
    export CPATH=/opt/homebrew/include
    export LIBRARY_PATH=/opt/homebrew/lib
fi

num_parallel=$(($logical_cpus - 2))
num_parallel=$(( $num_parallel < 1 ? 1 : $num_parallel ))

make makejobs="${num_parallel}" default_precision=m4-single sh_toolchain_path="${sh_toolchain}" arm_toolchain_path="${arm_toolchain}"

# toolchain_profile="13.2.1-dev"
# toolchain_profile="14.1.1-dev"

cat "${checkout}/kos/doc/environ.sh.sample" \
    | perl -pe "s|export KOS_BASE=.*|export KOS_BASE='${checkout}/kos'|" \
    | perl -pe "s|export KOS_PORTS=.*|export KOS_PORTS='${checkout}/kos-ports'|" \
    | perl -pe "s|export KOS_CC_BASE=.*|export KOS_CC_BASE='${sh_toolchain}'|" \
    | perl -pe "s|export DC_ARM_BASE=.*|export DC_ARM_BASE='${arm_toolchain}'|" \
    | perl -pe "s|export KOS_SH4_PRECISION=.*|export KOS_SH4_PRECISION='-m4-single'|" \
           > "${checkout}/kos/environ.sh"

(source "${checkout}/kos/environ.sh" && cd "${checkout}/kos" && make)
