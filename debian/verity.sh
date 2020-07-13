#!/bin/bash
echo \#!/bin/bash > /sbin/update-verity
chmod +x /sbin/update-verity

cat << EOF >> /sbin/update-verity

echo \#!/bin/bash > /sbin/verity
echo export hash=\$(cat \$(df /boot | tail -n +2 | cut -d" " -f1) | b3sum | base64 -w 0 | cut -d" " -f1) >> /sbin/verity

chmod +x /sbin/verity

echo aWYgWyAkKGNhdCAkKGRmIC9ib290IHwgdGFpbCAtbiArMiB8IGN1dCAtZCcgJyAtZjEpIHwgYjNzdW0gfCBiYXNlNjQgLXcgMCB8IGN1dCAtZCcgJyAtZjEpID0gJGhhc2ggXTsgdGhlbgogICAgICAgIGVjaG8gRXZlcnl0aGluZyBvawplbHNlCiAgICAgICAgZWNobyA+IC9kZXYvdHR5MQogICAgICAgIGVjaG8gVmVyaXR5IHZpb2xhdGlvbiEgPiAvZGV2L3R0eTEKICAgICAgICBoYWx0CmZpCg== | base64 -d >> /sbin/verity

echo W1NlcnZpY2VdCkV4ZWNTdGFydD0vc2Jpbi92ZXJpdHkKW0luc3RhbGxdCldhbnRlZEJ5PWRlZmF1bHQudGFyZ2V0Cg== | base64 -d > /etc/systemd/system/verity.service

systemctl enable verity
EOF
