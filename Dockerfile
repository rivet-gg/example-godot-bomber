FROM fedora:36 AS builder

# Install Godot & templates
ENV GODOT_VERSION="4.0.2"
RUN dnf update \
    && dnf install -y wget unzip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz

RUN mkdir -p ~/.cache ~/.config/godot ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable \
    && rm Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip


# Build application
WORKDIR /app
COPY . .
RUN mkdir -p build/linux \
    && godot -v --export-release "Linux/X11" --headless ./build/linux/game.x86_64

FROM fedora:36
COPY --from=builder /app/build/linux/ /app
CMD ["/app/game.x86_64", "--headless"]

