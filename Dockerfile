FROM registry.access.redhat.com/ubi8/ubi AS ubi-nano-build

RUN mkdir -p /mnt/rootfs
RUN dnf -y --installroot /mnt/rootfs --releasever 8 --setopt=install_weak_deps=false --nodocs install glibc-minimal-langpack coreutils-single libstdc++ zlib
RUN dnf -y --installroot /mnt/rootfs --releasever 8 clean all
RUN cp -rf /mnt/rootfs/usr/bin /tmp/bin && rm -f /mnt/rootfs/usr/bin/* && cd /tmp/bin && cp bash ls coreutils /mnt/rootfs/usr/bin && rm -rf /tmp/bin

FROM scratch as ubi8-nano
COPY --from=ubi-nano-build /mnt/rootfs /
CMD [ "/bin/bash" ]