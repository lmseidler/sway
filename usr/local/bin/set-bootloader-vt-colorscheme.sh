#!/usr/bin/bash
for entry in /efi/loader/entries/*.conf; do
    if [[ $entry != *fallback.conf ]]; then
        # Check if the option is already present
        if ! grep -q "vt.default_red=30,255,186,255,156,195,178,234,83,255,195,186,156,195,178,234 vt.default_grn=31,101,215,215,209,154,185,242,87,155,154,215,209,154,185,242 vt.default_blu=43,122,97,109,187,201,189,241,99,94,201,97,187,201,189,241" "$entry"; then
            sed -i "s/^options .*/& vt.default_red=30,255,186,255,156,195,178,234,83,255,195,186,156,195,178,234 vt.default_grn=31,101,215,215,209,154,185,242,87,155,154,215,209,154,185,242 vt.default_blu=43,122,97,109,187,201,189,241,99,94,201,97,187,201,189,241/" "$entry"
        fi
    fi
done
