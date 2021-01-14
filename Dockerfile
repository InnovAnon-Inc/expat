FROM innovanon/doom-base:latest as builder-01
USER root
#COPY --from=innovanon/freetype    /tmp/freetype2.txz   /tmp/
#RUN extract.sh

ARG LFS=/mnt/lfs
WORKDIR $LFS/sources
USER lfs
RUN sleep 31                                                                                 \
 && git clone --depth=1 --recursive https://github.com/libexpat/libexpat.git                 \
 && cd                                                          libexpat/expat               \
 && ./buildconf.sh                                                                           \
 && ./configure --prefix=/usr/local --disable-shared --enable-static                         \
 && make                                                                                     \
 && make DESTDIR=/tmp/expat install                                                          \
 && cd ../..                                                                                 \
 && rm -rf                                                       libexpat                  \
 && cd           /tmp/expat                                                             \
 && strip.sh .                                                                               \
 && tar  pacf      ../expat.txz .                                                       \
 && cd ..                                                                                    \
 && rm -rf       /tmp/expat

FROM scratch as final
COPY --from=builder-01 /tmp/expat.txz /tmp/

