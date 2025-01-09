#!/usr/bin/bash
for entry in /efi/loader/entries/*.conf; do
    if [[ $entry != *fallback.conf ]]; then
        # Check if the option is already present
        if ! grep -q "video=3840x2160@60" "$entry"; then
            sed -i "s/^options .*/& video=3840x2160@60/" "$entry"
        fi
    fi
done
