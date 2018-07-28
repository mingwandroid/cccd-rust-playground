#!/usr/bin/env bash

export CARGO_HOME=/opt/rust/.cargo.$(uname)
export CARGO_CONFIG=${CARGO_HOME}/config
export RUSTUP_HOME=${CARGO_HOME}/rustup

if [[ ! -d ${RUSTUP_HOME}/toolchains ]]; then
  pushd /tmp
    curl https://sh.rustup.rs -sSf > rustup.sh
    chmod +x rustup.sh
    ./rustup.sh --default-toolchain nightly
    source ~/.profile
    # Welcome to Rust!
    #
    # This will download and install the official compiler for the Rust programming
    # language, and its package manager, Cargo.
    #
    # It will add the cargo, rustc, rustup and other commands to Cargo's bin
    # directory, located at:
    #
    #   /opt/rust/.cargo.Linux/bin
    #
    # This path will then be added to your PATH environment variable by modifying the
    # profile file located at:
    #
    #  /home/rdonnelly/.profile
  popd
fi

if [[ $(uname) == Darwin ]]; then
  export CONDA_BUILD_SYSROOT=/opt/MacOSX10.9.sdk
  echo "You may want to add this to /etc/launchd.conf for VSCode"
  echo "..  but actually it seems to source ~/.bash_profile for you so maybe better to just export these vars there (and conda activate devenv)"
  echo "setenv RUSTUP_HOME ${RUSTUP_HOME}"
  echo "setenv CARGO_HOME ${CARGO_HOME}"
  echo "setenv CARGO_CONFIG ${CARGO_CONFIG}"
fi
. /opt/conda/bin/activate devenv
# So since I like cross-compilation and keeping binaries around:
TARGET=$(basename ${CC%-*})
echo CARGO_CONFIG = ${CARGO_CONFIG}
rm ${CARGO_CONFIG}
echo "[target.${TARGET}]" > ${CARGO_CONFIG}
echo "linker = \"/opt/conda/envs/devenv/bin/${TARGET}-cc\"" >> ${CARGO_CONFIG}
echo "[target.x86_64-apple-darwin]" >> ${CARGO_CONFIG}
echo "linker = \"/opt/conda/envs/devenv/bin/x86_64-apple-darwin13.4.0-clang\"" >> ${CARGO_CONFIG}
echo "[target.i686-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"/opt/conda-32/envs/devenv/bin/i686-conda_cos6-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "[target.x86_64-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"/opt/conda/envs/devenv/bin/x86_64-conda_cos6-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "[target.'cfg(...)']" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-flags=-Wl,-rpath-link=${CONDA_PREFIX}/lib,-rpath=${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}


echo "[target.x86_64-apple-darwin13.4.0]" > ${CARGO_CONFIG}
echo "linker = \"/opt/conda/envs/devenv/bin/x86_64-apple-darwin13.4.0-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath,/opt/conda/envs/devenv/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}
echo "[target.x86_64-apple-darwin]" >> ${CARGO_CONFIG}
echo "linker = \"/opt/conda/envs/devenv/bin/x86_64-apple-darwin13.4.0-clang\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath,/opt/conda/envs/devenv/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}
echo "[target.i686-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"/opt/conda-32/envs/devenv/bin/i686-conda_cos6-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,/opt/conda/envs/devenv/lib\", \"-C\", \"link-arg=-Wl,-rpath,/opt/conda/envs/devenv/lib\", \"-C\", \"opt-level=s\"]" >> ${CARGO_CONFIG}
echo "[target.x86_64-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"/opt/conda/envs/devenv/bin/x86_64-conda_cos6-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,/opt/conda/envs/devenv/lib\", \"-C\", \"link-arg=-Wl,-rpath,/opt/conda/envs/devenv/lib\", \"-C\", \"opt-level=s\"]" >> ${CARGO_CONFIG}
echo "# Not sure about this stuff:" >> ${CARGO_CONFIG}
echo "# [target.'cfg(...)']" >> ${CARGO_CONFIG}
echo "# [build]" >> ${CARGO_CONFIG}
echo "# rustflags = [\"-C\", \"link-arg=-Wl,-rpath,/opt/conda/envs/devenv/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}


export PATH=${CARGO_HOME}/bin:${PATH}
rustup self update
rustup default nightly

