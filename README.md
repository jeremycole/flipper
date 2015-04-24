Flipper is a tool for managing pairs of MySQL servers replicating to each other (commonly known as master-master replication or dual-master replication). Master-master replication is a great way of ensuring high availability for MySQL databases - it enables one half of the pair to be taken offline for maintenance work while the other half carries on dealing with queries from clients.

Flipper achieves this by moving IP addresses based on a role ("read-only", "writable") between the two nodes in the master pair, to ensure that each role is available.

Flipper is written in perl, and has been designed to be as portable as possible.
