-A: Append a rule to a chain.

-D: Delete a rule from a chain.

-I: Insert a rule at a specific position in a chain.

-R: Replace a rule in a chain.

-L: List all rules in a chain.

-F: Flush all rules in a chain.

-P: Set the default policy for a chain.

-t: Specify the table to operate on (e.g., filter, nat, mangle).

-p: Specify the protocol (e.g., tcp, udp, icmp).

-s / -d: Define source/destination IP addresses.

-i / -o: Specify input/output network interfaces.

-j: Jump to a target action (ACCEPT, DROP, REJECT, etc.).

---

-m state: Match packets based on their connection state (NEW, ESTABLISHED, RELATED, INVALID).

-m limit: Limit the rate of matches.

-m mac: Match packets based on MAC address.

-m multiport: Match packets on multiple ports.
