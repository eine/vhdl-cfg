FROM ghdl/synth:beta

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    python3-pip \
 && pip3 install -U setuptools wheel \
 && curl -fsSL https://gitlab.com/rodrigomelo9/pyfpga/-/archive/master/pyfpga-master.tar.gz | tar xzf - \
 && cd pyfpga-master \
 && pip3 install . \
 && cd .. \
 && rm -rf pyfpga-master
