FROM innovanon/doom-base:latest as builder-01
USER root
#COPY --from=innovanon/freetype    /tmp/freetype2.txz   /tmp/
#RUN extract.sh

ARG LFS=/mnt/lfs
WORKDIR $LFS/sources
USER lfs
RUN env
RUN sleep 31                                                                                 \
 && git clone --depth=1 --recursive https://github.com/libexpat/libexpat.git                 \
 && cd                                                                        libexpat     \
 && ./buildconf.sh                                                                           \
 && ./configure --prefix=/usr/local --disable-shared --enable-static                         \
 && make                                                                                     \
 && make DESTDIR=/tmp/libexpat install                                                     \
 && rm -rf                                                                    libexpat     \
 && cd           /tmp/libexpat                                                             \
 && strip.sh .                                                                               \
 && tar  pacf      ../libexpat.txz .                                                       \
 && cd ..                                                                                    \
 && rm -rf       /tmp/libexpat

FROM scratch as final
COPY --from=builder-01 /tmp/expat.txz /tmp/

