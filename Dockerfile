# FROM alpine:3.17.3
FROM fedora:36

# Environment Variables
ENV GLIBC_VERSION="2.35-r1"
ENV GODOT_VERSION="4.0.2"

# RUN apk update \
#     && apk add --no-cache bash wget gcompat \
#     && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
#     && apk add --allow-untrusted --force-overwrite glibc-${GLIBC_VERSION}.apk \
#     && rm glibc-${GLIBC_VERSION}.apk \
#     && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
#     && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
#     && mkdir -p ~/.cache ~/.config/godot ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
#     && unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
#     && mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 /usr/local/bin/godot \
#     && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
#     && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
#     && rm Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

RUN dnf update \
    && dnf install -y wget unzip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mkdir -p ~/.cache ~/.config/godot ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && rm Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

#COPY . .

# RUN godot -v --export "Linux" --headless ./build/linux/$exportName.x86_64

