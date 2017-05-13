#!/bin/sh
cat >/usr/bin/free <<'EOF'
#!/bin/sh
cat <<'__eof'
             total       used       free     shared    buffers     cached
Mem:       1048576     327264     721312          0          0          0
-/+ buffers/cache:     327264     721312
Swap:      2000000          0    2000000
__eof
exit
EOF
chmod 755 /usr/bin/free
exit
