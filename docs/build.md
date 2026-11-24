# Vox 44 build and release

## Remote Google Cloud builder

Use an x86_64 Fedora 44 Compute Engine VM as host and a Fedora 44 Docker image for the pinned tools. Fedora publishes GCE images; list them and select an exact Fedora 44 image rather than a moving family. Values below are placeholders. The VM and persistent disk are billable; stop/delete them after copying outputs.

On the Chromebook, authenticate gcloud, then:

    gcloud config set project PROJECT_ID
    gcloud compute images list --project=fedora-cloud --no-standard-images --filter='name~fedora-44' --format='table(name,creationTimestamp)'
    gcloud compute instances create vox-builder --zone=ZONE --machine-type=e2-standard-4 --boot-disk-size=100GB --boot-disk-type=pd-balanced --image-project=fedora-cloud --image=IMAGE_NAME
    gcloud compute ssh vox-builder --zone=ZONE

On the VM install Docker and tooling, upload this repository and comment-cleaned.zip to a persistent disk using Git or gcloud compute scp:

    sudo dnf install -y moby-engine docker-cli git tar gzip lorax livemedia-creator pykickstart rpm-build rpmdevtools mock createrepo_c gnupg2 qemu-kvm
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"

Log out and reconnect after adding the account to the docker group. Dockerfile at repository root:

    FROM fedora:44
    RUN dnf -y install dnf5 lorax livemedia-creator pykickstart rpm-build rpmdevtools mock createrepo_c gnupg2 git tar gzip && dnf clean all
    WORKDIR /work
    CMD ["bash"]

Import UniGetUI as a pinned third-party RPM before building. The importer verifies the upstream release checksum, reads the RPM Name rather than guessing it, re-signs the unchanged RPM with your Vox key, adds it to the Vox repo, and generates a Kickstart copy that installs it:

    ./scripts/import-unigetui-rpm.sh 2026.3.4 "$PWD/repo/44/x86_64"

Run the image builder on the disposable VM only. The privileged container has wide device/mount access; no KVM is requested because livemedia-creator uses --no-virt. The host needs loop devices, mount permissions, and disk space. Keep host SELinux enabled.

    cd ~/vox
    sudo modprobe loop
    sudo docker build -t vox/fedora44-builder:0.1 .
    sudo docker run --rm --privileged -v "$PWD:/work:Z" -w /work vox/fedora44-builder:0.1 bash -lc 'livemedia-creator --make-iso --ks=/work/work/kickstart/vox-live.ks --no-virt --resultdir=/work/work/iso --project=Vox --releasever=44 --volid=VOX_44 --iso-only --iso-name=vox-44.0.0-x86_64.iso'

Verify flags with livemedia-creator --help on Fedora 44. First publish Vox RPMs, configure a real repository URL/key, and confirm the Kickstart packages resolve. Placeholder .invalid URLs mean this scaffold cannot produce an ISO unchanged.

Copy output back and sign from a protected environment:

    gcloud compute scp --zone=ZONE vox-builder:~/vox/work/iso/vox-44.0.0-x86_64.iso ./
    sha256sum vox-44.0.0-x86_64.iso > vox-44.0.0-x86_64.iso.sha256
    gpg --detach-sign --armor vox-44.0.0-x86_64.iso
    gcloud compute instances delete vox-builder --zone=ZONE

For releases use a pinned Fedora 44 VM/container digest, build on tag vox-44.*, publish RPMs/repo metadata/ISO, and emit checksums/signatures. Never place the private signing key in GitHub Actions, a Docker image, or the ISO. Hosted runners do not guarantee loop privileges; use the same container on a self-hosted x86_64 runner or the GCE VM.

## RPM signing/repo

On a protected signing host, configure a dedicated RPM signing key and then:

    rpm --addsign RPMS/noarch/*.rpm
    rpm --checksig --verbose RPMS/noarch/*.rpm
    createrepo_c --update repo/44/x86_64
    gpg --detach-sign --armor repo/44/x86_64/repodata/repomd.xml

Place the matching public key in vox-repos and publish the signature at repomd.xml.asc before setting repo_gpgcheck=1. Do not commit private keys. Archive source RPMs, package NEVRAs, signatures, repository metadata, ISO checksum, ISO signature, and a source/license manifest.

## QEMU/virt-manager validation

Run on the developer workstation after transferring the ISO:

    qemu-system-x86_64 -enable-kvm -m 6144 -smp 4 -drive file=vox-44.0.0-x86_64.iso,media=cdrom,readonly=on -boot d -device virtio-vga -netdev user,id=n1 -device virtio-net-pci,netdev=n1

For UEFI use virt-manager with UEFI firmware, 6 GiB RAM, 4 vCPUs, a 40 GiB disk, and the ISO. Test live boot and a full install into a blank VM disk before publishing.
