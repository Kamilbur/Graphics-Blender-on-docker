FROM ubuntu:22.04

RUN apt-get update -y   &&\
    apt-get install \
        cmake \
        gcc \
        gpg-agent \
        g++ \
        libfontconfig1 \
        libglu1-mesa-dev \
        libxfixes-dev \
        libxi6 \
        libxkbcommon-x11-0 \
        libxrender1 \
        libxxf86vm-dev \
        make \
        openssh-server \
        python3-dev \
#        python3-vtk9 \
        software-properties-common \
        unzip \
        wget \
        xauth \
        xz-utils \
        zip \
    --no-install-recommends -y


RUN wget https://github.com/Kitware/VTK/archive/refs/tags/v9.0.2.zip &&\
    unzip v9.0.2.zip &&\
    cd VTK-9.0.2/ &&\
    sed -i '1s/^/#include <limits>\n /' \
        Common/Core/vtkGenericDataArrayLookupHelper.h \
        Common/DataModel/vtkPiecewiseFunction.cxx \
        Filters/HyperTree/vtkHyperTreeGridThreshold.cxx \
        Rendering/Core/vtkColorTransferFunction.cxx \
    &&\
    mkdir build &&\
    cd build &&\
    cmake .. &&\
    make -j4 &&\
    make install

RUN wget https://github.com/EPhysLab-UVigo/VisualSPHysics/archive/master.zip &&\
    unzip master.zip &&\
    cd VisualSPHysics-master &&\
    mkdir build &&\
    cd build &&\
    cmake .. -DPYTHON_INCLUDE_DIR=/usr/include/python3.10 -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu &&\
    make -j4 &&\
    zip -j VisualSPHysics.zip ../blendermodule/VisualSPHysics.py foamsimulator/diffuseparticles.so vtkimporter/vtkimporter.so

RUN apt-get update && apt-get install -y python3-vtk9

WORKDIR /root

RUN wget https://ftp.nluug.nl/pub/graphics/blender/release/Blender2.93/blender-2.93.13-linux-x64.tar.xz &&\
    tar -xf blender-2.93.13-linux-x64.tar.xz

RUN echo "cd /root/blender-2.93.13-linux-x64" >> /root/.bashrc

RUN mv /VisualSPHysics-master/build/VisualSPHysics.zip .


ARG HOME=/root

RUN mkdir /run/sshd &&\
    mkdir -p ${HOME}/.ssh

COPY docker.pub ${HOME}/.ssh/authorized_keys

COPY sshd_config /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-p", "10000", "-D"]
