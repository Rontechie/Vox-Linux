FROM fedora:44
RUN dnf -y install dnf5 lorax livemedia-creator pykickstart rpm-build rpmdevtools mock createrepo_c gnupg2 git tar gzip && dnf clean all
WORKDIR /work
CMD ["bash"]
