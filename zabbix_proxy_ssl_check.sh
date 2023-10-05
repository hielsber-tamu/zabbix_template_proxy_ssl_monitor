#!/bin/bash

# The following assumes the proxy has been set up with letsencrypt and uses a
# separate folder, named by FQDN, for each certificate.  Also, it is assumed,
# but not necessary, that all vhosts are given a separate certificate.

path="/etc/letsencrypt/live"
exp_thresh_sec_default=1209600
exp_thresh_sec="${1:-$exp_thresh_sec_default}"

[[ "$exp_thresh_sec" =~ ^[0-9]+$ ]] || error "Expiration Threshold should be a positive integer"

for dir in $(find "$path" -mindepth 1 -type d); do

    expiration_date=$(openssl x509 -in $dir/cert.pem -noout -enddate | cut -d '=' -f 2)

    seconds_until_expiration=$(( $(date -d "$expiration_date" +%s) - $(date +%s) ))

    if (( seconds_until_expiration < exp_thresh_sec )); then
        # assumes basename is FQDN
        echo $(basename "$dir") :: $expiration_date
    fi
done
