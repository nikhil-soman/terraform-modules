#!/bin/bash

cat > index.html <<EOF
<h1> Hello, world. This is Production website </h1>
<p> DB endpint: ${db_address} </p>
<p> DB port: ${db_port} </p>
EOF

nohup busybox httpd -f -p "${server_port}" &
